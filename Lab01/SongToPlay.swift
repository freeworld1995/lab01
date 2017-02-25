//
//  SongToPlay.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/23/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SongToPlay {
    var title = ""
    var link = ""
    
    init(title: String, link: String) {
        self.title = title
        self.link = link
    }
}
