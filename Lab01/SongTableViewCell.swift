//
//  SongTableViewCell.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/21/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SDWebImage

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        songImage.layer.cornerRadius = songImage.frame.width / 2
        songImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(song: Song) {
        self.name.text = song.name
        self.artist.text = song.artist
        
        self.songImage.setShowActivityIndicator(true)
        self.songImage.setIndicatorStyle(.gray)
        self.songImage.sd_setImage(with: URL(string: song.image))
    }
    
}