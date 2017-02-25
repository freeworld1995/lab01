//
//  ListSongViewController.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/21/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import SDWebImage

class ListSongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageFromCategoryVC: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var image: UIImageView?
    var label: String?
    
    var genreNum: Int!
    
    let datasource = ListSongDataSource()
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource.getSongs(tableView: tableView, genreNum: genreNum)
        tableView.rx.setDelegate(self).addDisposableTo(disposebag)
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        imageFromCategoryVC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToCategory)))
        imageFromCategoryVC.isUserInteractionEnabled = true
        
        navigationItem.title = "Discovery"
        setupDidSelectRow()
    }
    
    func setupDidSelectRow() {
        tableView.rx.modelSelected(Song.self).subscribe(onNext: { (song) in
            Services.playSongWithTitle(title: song.name)
            PlayerController.shared.title.text = song.name
            PlayerController.shared.artist.text = song.artist
            PlayerController.shared.image.sd_setImage(with: URL(string: song.image))
            PlayerController.shared.setTimer()
        }, onError: { (error) in
            print(error)
        }, onCompleted: { 
            print("completed touch song")
        }, onDisposed: nil).addDisposableTo(disposebag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageFromCategoryVC.image = image?.image
        categoryLabel.text = label
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func backToCategory(gesture: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

extension ListSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
