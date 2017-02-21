//
//  CategoryCollectionViewCell.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadImage(url: String) {
        indicator.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            if let value = response.result.value {
                let title = Category.parse(json: JSON(value))
                self.categoryLabel.text = title
                self.categoryImage.image = UIImage(named: "genre-\(self.tag)")
                self.indicator.stopAnimating()
                self.indicator.isHidden = true
            }
        }
        
    }

}
