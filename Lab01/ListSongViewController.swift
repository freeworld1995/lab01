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
import AVFoundation
import MediaPlayer

class ListSongViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageFromCategoryVC: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var image: UIImageView?
    var label: String?
    
    var genreNum: Int!
    
    let datasource = ListSongDataSource()
    let disposebag = DisposeBag()
    var shouldExecute = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        datasource.getSongs(tableView: tableView, genreNum: genreNum)
        
        AudioManager.shareInstance.songs = datasource.songs
        
        tableView.rx.setDelegate(self).addDisposableTo(disposebag)
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
        imageFromCategoryVC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToCategory)))
        imageFromCategoryVC.isUserInteractionEnabled = true
        
        navigationItem.title = "Discovery"
        setupDidSelectRow()
    }
    
    func setupDidSelectRow() {
        tableView.rx
            .itemSelected
            .subscribe (onNext: { [unowned self] indexPath in
                if let cell = self.tableView.cellForRow(at: indexPath) as? SongTableViewCell {
                    cell.isSelected = true
                    AudioManager.shareInstance.selectedSongIndex = indexPath.row
                    self.shouldExecute = true
                    UIView.animate(withDuration: 1.0, animations: {
                        PlayerController.shared.isHidden = false
                    })
                    
                }
            }).addDisposableTo(disposebag)
        
        tableView.rx
            .itemDeselected
            .subscribe (onNext: { [unowned self] indexPath in
                if let cell = self.tableView.cellForRow(at: indexPath) as? SongTableViewCell {
                    cell.isSelected = false
                }
            }).addDisposableTo(disposebag)
        
        tableView.rx.modelSelected(Song.self).subscribe(onNext: { (song) in
            
            Services.playSongWithTitle(title: song.name)
            PlayerController.shared.song = song
            PlayerController.shared.genreNum = self.genreNum
            PlayerController.shared.title.text = song.name
            PlayerController.shared.artist.text = song.artist
            PlayerController.shared.image.sd_setImage(with: URL(string: song.image))
            PlayerController.shared.setTimer()
            
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle: song.name,
                MPMediaItemPropertyArtist: song.artist,
            ]
            
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            self.becomeFirstResponder()
            
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed touch song")
        }, onDisposed: nil).addDisposableTo(disposebag)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        print("it's happening")
        
        guard let event = event else {
            return
        }
        
        guard event.type == .remoteControl else { return }
        
        switch event.subtype {
        case .remoteControlPlay:
            AudioManager.shareInstance.player?.play()
        case .remoteControlPause:
            AudioManager.shareInstance.player?.pause()
        case .remoteControlTogglePlayPause:
            if AudioManager.shareInstance.player?.rate != 0 {
                AudioManager.shareInstance.player?.play()
            } else {
                AudioManager.shareInstance.player?.pause()
            }
        default:
            print("error")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldExecute {
            let selectedSong = datasource.songs.value[AudioManager.shareInstance.selectedSongIndex]
            tableView.scrollToRow(at: IndexPath(row: AudioManager.shareInstance.selectedSongIndex, section: 0), at: .middle, animated: false)
            for cell in tableView.visibleCells as! [SongTableViewCell] {
                if cell.name.text == selectedSong.name {
                    cell.isSelected = true
                } else {
                    cell.isSelected = false
                }
            }
        }
        
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
    
    deinit {
        print("ListSongVC deinit")
    }
}

extension ListSongViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
