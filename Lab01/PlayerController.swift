//
//  PlayerController.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/24/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import CoreMedia
import MediaPlayer

@IBDesignable
class PlayerController: UIView {
    
    static var shared = PlayerController(frame: CGRect.zero)
    
    var image: UIImageView!
    var title: UILabel!
    var artist: UILabel!
    var addPlaylistButton: UIButton!
    var progressView: UIProgressView!
    
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Color.playerBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addImage()
        addButton()
        addLabel()
        addProgessBar()
        
    }
    
    
    func setTimer() {

        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }
    

    
    func updateProgressView() {
        if AudioManager.shareInstance.player?.rate != 0 {
            guard AudioManager.shareInstance.player?.currentTime() != nil else { return }
            
            let current = CMTimeGetSeconds(AudioManager.shareInstance.player!.currentTime())
            let dur = CMTimeGetSeconds(AudioManager.shareInstance.player!.currentItem!.asset.duration)
            
            print("current: \(Float(current)) / \(Float(dur)) = \(Float(current) / Float(dur) )")
            progressView.setProgress(Float(current) / Float(dur) , animated: true)
            
        }
    }
    
    func addProgessBar() {
        progressView = UIProgressView()
        progressView.progressTintColor = UIColor.red
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: progressView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: progressView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: progressView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        
        self.addConstraint(top)
        self.addConstraint(trailing)
        self.addConstraint(leading)
        
        NSLayoutConstraint.activate([top, trailing, leading])
        
        self.addSubview(progressView)
    }
    
    func addButton() {
        addPlaylistButton = UIButton()
        addPlaylistButton.translatesAutoresizingMaskIntoConstraints = false
        addPlaylistButton.setImage(UIImage(named: "img-playlist-add"), for: .normal)
        
        let trailing = NSLayoutConstraint(item: addPlaylistButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -12)
        let width = NSLayoutConstraint(item: addPlaylistButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let height = NSLayoutConstraint(item: addPlaylistButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let centerY = NSLayoutConstraint(item: addPlaylistButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraint(trailing)
        self.addConstraint(width)
        self.addConstraint(height)
        self.addConstraint(centerY)
        
        NSLayoutConstraint.activate([trailing, centerY, width, height])
        
        self.addSubview(addPlaylistButton)
    }
    
    func addLabel() {
        title = UILabel()
        title.textColor = UIColor.white
        title.text = "title"
        artist = UILabel()
        artist.textColor = UIColor.white
        artist.text = "artist"
        
        let stackView = UIStackView(arrangedSubviews: [title, artist])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: image, attribute: .leading, multiplier: 1.0, constant: 50)
        let trailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: addPlaylistButton, attribute: .trailing, multiplier: 1.0, constant: -50)
        let centerY = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraint(leading)
        self.addConstraint(trailing)
        self.addConstraint(centerY)
        
        
        NSLayoutConstraint.activate([leading, trailing, centerY])
        
        self.addSubview(stackView)
        
    }
    
    func addImage() {
        image = UIImageView(frame: CGRect.zero)
        image.image = UIImage(named: "genre-9")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        
        let leading = NSLayoutConstraint(item: image, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10)
        let height = NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let width = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let centerY = NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addConstraint(leading)
        self.addConstraint(height)
        self.addConstraint(width)
        self.addConstraint(centerY)
        
        NSLayoutConstraint.activate([centerY, leading, height, width])
        
        self.addSubview(image)
        
    }
    
    func tapped(gesture: UITapGestureRecognizer) {
        print("tapped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
