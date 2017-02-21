//
//  ViewController.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tap: UIButton!
    
    let disposeBag = DisposeBag()
    let list  = Variable<[Song]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://itunes.apple.com/us/rss/topsongs/limit=50/genre=1/explicit=true/json").responseJSON { (response) in
            if let value = response.result.value {
                self.list.value = Song.parse(json: JSON(value))
                self.list.asObservable().bindTo(self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)
                ) { (row, song, cell) in
                    cell.textLabel?.text = song.name
                    cell.detailTextLabel?.text = song.artist
                    }.addDisposableTo(self.disposeBag)
            }
        }

        
        let lists = Observable<[Song]>.create { (observer) -> Disposable in
            let request = Alamofire.request("https://itunes.apple.com/us/rss/topsongs/limit=50/genre=1/explicit=true/json").responseJSON(completionHandler: { (response) in
                if let error = response.error {
                    observer.onError(error)
                }
                
                if let value = response.result.value {
                    observer.onNext(Song.parse(json: JSON(value)))
                }
                
                observer.onCompleted()
            })
            
            return Disposables.create {
                request.cancel()
            }
        }

        lists.do(onNext: { (songs) in
            let listSong = Variable<[Song]>(songs)
        }, onError: { (error) in

        }, onCompleted: {
            
        }, onSubscribe: nil, onDispose: nil)
        
        
        self.tap.rx.controlEvent(UIControlEvents.touchUpInside).bindNext {

        }.addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

