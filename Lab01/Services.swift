//
//  Services.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AVFoundation

class Services {
    
    
    class func getCategoryImageURLs(index: [Int]) -> [Category] {
        
        var categories = [Category]()
        
        
        for i in index {
            let category = Category()
            category.genreNum = i
            let url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=\(i)/explicit=true/json"
            category.title = url
            categories.append(category)
        }
        
        return categories
    }
    
    class func playSongWithTitle(title: String) {
        
        let url = "http://api.mp3.zing.vn/api/mobile/search/song?requestdata={\"q\":\"\(title)\", \"sort\":\"hot\", \"start\":\"0\", \"length\":\"5\"}"
        
        let finalUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire.request(finalUrl!).responseJSON { (response) in
            
            guard !response.result.isFailure else {
                print("Error while getting song")
                return
            }
            
            if let value = response.result.value {
                
                guard checkEmptyResult(json: JSON(value)) else {
                    print("Found no songs")
                    return
                }
                
                let songsToPlay = getSongToPlay(json: JSON(value))
                let streamUrl = songsToPlay[0].link
                
                Alamofire.request(streamUrl).responseData { (response) in
                    if let value = response.response?.url?.absoluteString {
                        let playerItem = AVPlayerItem(url: URL(string: value)!)
                        AudioManager.shareInstance.player = AVPlayer(playerItem: playerItem)
                        AudioManager.shareInstance.isPlaying = true
                    }
                }
            }
        }
    }
    
    class func checkEmptyResult(json: JSON) -> Bool {
        if let count = json["numFound"].int {
            return count > 0
        }
        return false
        
    }
    
    class func getSongToPlay(json: JSON) -> [SongToPlay] {
        var max: Double = 0.0
        
        var songsToPlay = [SongToPlay]()
        let docs = json["docs"].array!
        for i in 0...docs.count - 1 {
            let title = docs[i].dictionary?["title"]?.string!
            
            if let score = title?.score(title!) {
                if score > max {
                    max = score
                    let link = docs[i].dictionary?["source"]?["128"].string!
                    let songtoPlay = SongToPlay(title: title!, link: link!)
                    songsToPlay.append(songtoPlay)
                }
            }
        }
        
        return songsToPlay
    }
}
