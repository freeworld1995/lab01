//
//  CustomeSlider.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/26/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class CustomeSlider: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let thumbImage = UIImage(named: "img-slider-thumb") {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
 
    }

}
