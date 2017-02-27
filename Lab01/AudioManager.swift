//
//  AudioManager.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/24/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import GameplayKit
import RxSwift
import RxCocoa

class AudioManager {
    static var shareInstance = AudioManager()
    
    var songs: Variable<[Song]>?
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    var isShuffle: Bool
    
    enum Repeat {
        case repeatNone
        case repeatOne
        case repeatAll
    }
    
    var repeatType: Repeat {
        didSet {
            print(repeatType)
        }
    }
    var isPlaying: Bool {
        didSet {
            if isPlaying {
                player?.play()
            } else {
                player?.pause()
            }
        }
    }
    
    var selectedSong: Variable<Song>!
    var selectedSongIndex: Int!
    
    init() {
        isShuffle = false
        isPlaying = false
        repeatType = .repeatNone
        songs = nil
    }

    func next(songCount: Int) {
        switch repeatType {
        case .repeatOne:
            player?.seek(to: kCMTimeZero)
        case .repeatAll:
            if isShuffle {
                let randomIndex = GKRandomDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: songCount - 1).nextInt()
                let title = songs!.value[randomIndex].name
                AudioManager.shareInstance.selectedSongIndex = randomIndex
                Services.playSongWithTitle(title: title)
            } else {
                
                let finalIndex = selectedSongIndex + 1 < songCount ? selectedSongIndex + 1 : 0
                AudioManager.shareInstance.selectedSongIndex = finalIndex
                let title = songs!.value[finalIndex].name
                
                Services.playSongWithTitle(title: title)
            }
        case .repeatNone:
            if isShuffle {
                let randomIndex = GKRandomDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: songCount - 1).nextInt()
                let title = songs!.value[randomIndex].name
                AudioManager.shareInstance.selectedSongIndex = randomIndex
                Services.playSongWithTitle(title: title)
            } else {
                
                let finalIndex = selectedSongIndex + 1 < songCount ? selectedSongIndex + 1: selectedSongIndex
                AudioManager.shareInstance.selectedSongIndex = finalIndex
                let title = songs!.value[finalIndex!].name
                
                Services.playSongWithTitle(title: title)
            }
        }
    }
    
    func previous(songCount: Int) {
        switch repeatType {
        case .repeatOne:
            player?.seek(to: kCMTimeZero)
        case .repeatAll:
            if isShuffle {
                let randomIndex = GKRandomDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: songCount - 1).nextInt()
                let title = songs!.value[randomIndex].name
                AudioManager.shareInstance.selectedSongIndex = randomIndex
                Services.playSongWithTitle(title: title)
            } else {
                
                let finalIndex = selectedSongIndex - 1 >= 0 ? selectedSongIndex - 1 : songCount - 1
                AudioManager.shareInstance.selectedSongIndex = finalIndex
                let title = songs!.value[finalIndex].name
                
                Services.playSongWithTitle(title: title)
            }
        case .repeatNone:
            if isShuffle {
                let randomIndex = GKRandomDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: songCount - 1).nextInt()
                let title = songs!.value[randomIndex].name
                AudioManager.shareInstance.selectedSongIndex = randomIndex
                Services.playSongWithTitle(title: title)
            } else {
                
                let finalIndex = selectedSongIndex - 1 >= 0 ? selectedSongIndex - 1 : 0
                AudioManager.shareInstance.selectedSongIndex = finalIndex
                let title = songs!.value[finalIndex].name
                
                Services.playSongWithTitle(title: title)
            }
        }
    }
}
