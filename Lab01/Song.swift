//
//  Song.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

class Song {
    var name = ""
    var artist = ""
    var image = ""
    
    init(name: String, artist: String, image: String) {
        self.name = name
        self.artist = artist
        self.image = image
    }

    class func parse(json: JSON) -> [Song] {
        var songs = [Song]()
        let feed = json["feed"]
        let entries = feed["entry"].array!
        for entry in entries {
            let name = entry["title"]["label"].string!
            let artist = entry["im:artist"]["label"].string!
            let image = entry["im:image"][0]["label"].string!
            let song = Song(name: name, artist: artist, image: image)
            songs.append(song)
        }
        return songs
    }
}

extension Song {
    static func ==(lhs: Song, rhs: Song) -> Bool {
        return lhs.name == rhs.name && lhs.artist == rhs.artist && lhs.image == rhs.image
    }
}
