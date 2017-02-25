//
//  AudioManager.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/24/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import AVFoundation

class AudioManager: NSObject {
    static var shareInstance = AudioManager()
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
}
