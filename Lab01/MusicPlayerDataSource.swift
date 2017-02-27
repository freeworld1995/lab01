//
//  MusicPlayerDataSource.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/26/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import SDWebImage
import AVFoundation
import MediaPlayer

class MusicPlayerDataSource {
    var songs = Variable<[Song]>([])
    let disposeBag = DisposeBag()
    
    func getSongs(tableView: UITableView, genreNum: Int) {
        Alamofire.request("https://itunes.apple.com/us/rss/topsongs/limit=50/genre=\(genreNum)/explicit=true/json").responseJSON { (response) in
            if let value = response.result.value {
                self.songs.value = Song.parse(json: JSON(value))
                self.songs.asObservable().bindTo(tableView.rx.items(cellIdentifier: "SongTableViewCell", cellType: SongTableViewCell.self)
                ) { (row, song, cell) in
                    cell.setup(song: song)
                    
                    if AudioManager.shareInstance.selectedSongIndex == row {
                        cell.isSelected = true
                    }
                }.addDisposableTo(self.disposeBag)
            }
        }
    }

}
