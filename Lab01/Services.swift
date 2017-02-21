//
//  Services.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import Foundation

class Services {
    
    
    class func getCategoryImageURLs(index: [Int]) -> [String] {
        
        var urls = [String]()
 
        for i in index {
            let url = "https://itunes.apple.com/us/rss/topsongs/limit=50/genre=\(i)/explicit=true/json"
            urls.append(url)
        }
        
        return urls
    }
}
