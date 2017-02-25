//
//  Category.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RxSwift
import RxCocoa

class Category {
    var title = ""
    var imageUrl = ""
    var genreNum = 0

    init(title: String, imageUrl: String, genreNum: Int) {
        self.title = title
        self.imageUrl = imageUrl
        self.genreNum = genreNum
    }
    
    init() {
    }
    
    class func parse(json: JSON) -> String {
        let feed = json["feed"]
        let title = feed["title"]
        let label = title["label"].string!
        let final = label.replacingOccurrences(of: "iTunes Store: Top Songs in ", with: "")
        return final
    }
    
//    class func getCategory(index: [Int]) -> [Category] {
//        var categories = [Category]()
//        
//        for i in index {
//            let category = Category()
//            
//            Alamofire.request("https://itunes.apple.com/us/rss/topsongs/limit=50/genre=\(i)/explicit=true/json").responseJSON { (response) in
//                if let value = response.result.value {
//                    let title = Category.parse(json: JSON(value))
//                    category.title = title
//                    category.image = UIImage(named: "genre-\(i)")
//                }
//            }
//            
//            categories.append(category)
//        }
//        
//        return categories
//    }
}
