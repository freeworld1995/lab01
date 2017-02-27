//
//  MusicPlayerViewController.swift
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

class MusicPlayerViewController: UIViewController {
    
    static var shared = instantiateViewController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var durationSlider: CustomeSlider!
    @IBOutlet weak var presentDuration: UILabel!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isExecutable = true
    var shouldExecute = false
    var datasource = MusicPlayerDataSource()
    let disposebag = DisposeBag()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).addDisposableTo(disposebag)
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        datasource.getSongs(tableView: tableView, genreNum: PlayerController.shared.genreNum!)
        
        setupTable()
        setupRepeat()
        setupShuffle()
        setupPlayPause()
        
        handleRepeatButton()
        handleDismissButton()
        handlePlayPauseButton()
        handlePreviousButton()
        handleNextButton()
        handleShuffleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldExecute {
            
            let selectedSong = datasource.songs.value[AudioManager.shareInstance.selectedSongIndex]
            for cell in tableView.visibleCells as! [SongTableViewCell] {
                if cell.name.text == selectedSong.name {
                    cell.isSelected = true
                } else {
                    cell.isSelected = false
                }
            }
        }
        
        setupImage()
        updateDurationSlider()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDurationSlider), userInfo: nil, repeats: true)
        
    }
    
    func updateDurationSlider() {
        if AudioManager.shareInstance.player?.rate != 0 {
            guard AudioManager.shareInstance.player?.currentTime() != nil else { return }
            
            let current = CMTimeGetSeconds(AudioManager.shareInstance.player!.currentTime())
            let dur = CMTimeGetSeconds(AudioManager.shareInstance.player!.currentItem!.asset.duration)
            
            
            if isExecutable {
                
                durationSlider.minimumValue = 0.0

                isExecutable = false
                shouldExecute = true
            }
            durationSlider.maximumValue = Float(dur)
            durationSlider.value = Float(current)
            totalDuration.text = caculateDuration(duration: Float(dur) - Float(current))
            presentDuration.text = caculateDuration(duration: Float(current))
            
        }
        
    }
    
    func caculateDuration(duration: Float) -> String {
        let roundedDuration = Int(roundf(duration))
        
        let result = secondsToMinutesSeconds(seconds: roundedDuration)
        
        let minuteString = String(result.minute)
        let secondString = result.second < 10 ? "0\(result.second)" : "\(result.second)"
        
        return "\(minuteString):\(secondString)"
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> ( minute: Int, second: Int) {
        return ( (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func instantiateViewController() -> MusicPlayerViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "MusicPlayerVC") as? MusicPlayerViewController
        return vc!
    }
    
    @IBAction func handleSlider(_ sender: CustomeSlider) {
        let dur = CMTime(seconds: Double(sender.value), preferredTimescale: 10000)
        AudioManager.shareInstance.player?.seek(to: dur, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimePositiveInfinity)
    }
    
    deinit {
        print("MusicPlayerVC deinit")
    }
}

extension MusicPlayerViewController: UITableViewDelegate {
    // MARK: Setup
    
    func setupTable() {
        tableView.rx.itemDeselected.subscribe(onNext: { [unowned self] indexPath in
            if let cell = self.tableView.cellForRow(at: indexPath) as? SongTableViewCell {
                cell.isSelected = false
                
            }
        }).addDisposableTo(disposebag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            self.turnOffCellDot()
            if let cell = self.tableView.cellForRow(at: indexPath) as? SongTableViewCell {
                cell.isSelected = true
                
                AudioManager.shareInstance.selectedSongIndex = indexPath.row
                self.setupImage()
            }
        }).addDisposableTo(disposebag)
        
        tableView.rx.modelSelected(Song.self).subscribe(onNext: { (song) in
            
            Services.playSongWithTitle(title: song.name)
            PlayerController.shared.song = song
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
    
    func setupImage() {
        image.sd_setImage(with: URL(string: datasource.songs.value[AudioManager.shareInstance.selectedSongIndex].image))
    }
    
    func setupRepeat() {
        switch AudioManager.shareInstance.repeatType {
        case .repeatNone:
            repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat-none"), for: .normal)
        case .repeatOne:
            repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat-1"), for: .normal)
        case .repeatAll:
            repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat"), for: .normal)
        }
    }
    
    func setupShuffle() {
        if AudioManager.shareInstance.isShuffle {
            shuffleButton.setImage(#imageLiteral(resourceName: "img-player-shuffle"), for: .normal)
        } else {
            shuffleButton.setImage(#imageLiteral(resourceName: "img-player-shuffle-off"), for: .normal)
        }
    }
    
    func setupPlayPause() {
        if AudioManager.shareInstance.isPlaying {
            playPauseButton.setImage(#imageLiteral(resourceName: "img-player-play"), for: .normal)
        } else {
            playPauseButton.setImage(#imageLiteral(resourceName: "img-player-pause"), for: .normal)
        }
    }
    
    // MARK: Handler
    
    func handleDismissButton() {
        dismissButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }).addDisposableTo(disposebag)
    }
    
    func handlePreviousButton() {
        previousButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.turnOffCellDot()
            AudioManager.shareInstance.previous(songCount: self.datasource.songs.value.count)
            self.turnOnCellDot()
            self.setupImage()
        }).addDisposableTo(disposebag)
    }
    
    func handleNextButton() {
        nextButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            self.turnOffCellDot()
            AudioManager.shareInstance.next(songCount: self.datasource.songs.value.count)
            self.turnOnCellDot()
            self.setupImage()
        }).addDisposableTo(disposebag)
    }
    
    func handlePlayPauseButton() {
        playPauseButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            AudioManager.shareInstance.isPlaying = !AudioManager.shareInstance.isPlaying
            
            self.setupPlayPause()
        }).addDisposableTo(disposebag)
    }
    
    func handleShuffleButton() {
        shuffleButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            AudioManager.shareInstance.isShuffle = !AudioManager.shareInstance.isShuffle
            
            self.setupShuffle()
        }).addDisposableTo(disposebag)
    }
    
    func handleRepeatButton() {
        repeatButton.rx.tap.subscribe(onNext: { [unowned self] _ in
            let type = AudioManager.shareInstance.repeatType
            
            switch type {
            case .repeatNone:
                AudioManager.shareInstance.repeatType = .repeatOne
                self.repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat-1"), for: .normal)
            case .repeatOne:
                AudioManager.shareInstance.repeatType = .repeatAll
                self.repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat"), for: .normal)
            case .repeatAll:
                AudioManager.shareInstance.repeatType = .repeatNone
                self.repeatButton.setImage(#imageLiteral(resourceName: "img-player-repeat-none"), for: .normal)
            }
            
            self.setupShuffle()
        }).addDisposableTo(disposebag)
        
    }
    
    
    func turnOffCellDot() {
        self.tableView.beginUpdates()
        self.tableView.cellForRow(at: IndexPath(row: AudioManager.shareInstance.selectedSongIndex, section: 0))?.isSelected = false
        self.tableView.endUpdates()
    }
    
    func turnOnCellDot() {
        self.tableView.beginUpdates()
        self.tableView.cellForRow(at: IndexPath(row: AudioManager.shareInstance.selectedSongIndex, section: 0))?.isSelected = true
        self.tableView.endUpdates()
    }
    
}
