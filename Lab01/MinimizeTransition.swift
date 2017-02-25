//
//  minimizeTransition.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/20/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit

class MinimizeTransition: NSObject {
    var duration = 1.0
    var originalFrame: CGRect!
    var presenting = true
    
    
    func setOriginalFrame(origin: inout CGPoint, size: inout CGSize) {
        originalFrame = CGRect(origin: origin, size: size)
    }
}

extension MinimizeTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let contrainerView = transitionContext.containerView
        contrainerView.backgroundColor = UIColor.black
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        var transitionImage: UIImageView!
        if let fromVC = transitionContext.viewController(forKey: .from) as? CategoryViewController, let toVC = transitionContext.viewController(forKey: .to) as? ListSongViewController {
            
            
            
            let darkBackground = UIView(frame: fromView!.frame)
            darkBackground.backgroundColor = UIColor.black
            darkBackground.alpha = 0
            contrainerView.addSubview(darkBackground)
            
            transitionImage = UIImageView(image: fromVC.transitionImage?.image)
            transitionImage.contentMode = .scaleAspectFill
            transitionImage.frame = originalFrame
            
            contrainerView.addSubview(transitionImage)
            
            UIView.animate(withDuration: duration, animations: { [unowned self] in
                darkBackground.alpha = 1
                contrainerView.bringSubview(toFront: transitionImage)
                print("transition: \(toVC.imageFromCategoryVC.superview?.convert(toVC.imageFromCategoryVC.frame, to: toVC.view))")
                transitionImage.frame = toVC.imageFromCategoryVC.superview!.convert(toVC.imageFromCategoryVC.frame, to: toVC.view)
            }) { (success) in
                contrainerView.addSubview(toView!)
                darkBackground.removeFromSuperview()
                transitionImage.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
            
        } else if let fromVC = transitionContext.viewController(forKey: .from) as? ListSongViewController , let toVC = transitionContext.viewController(forKey: .to) as? CategoryViewController{
            let darkBackground = UIView(frame: fromView!.frame)
            darkBackground.backgroundColor = UIColor.black
            darkBackground.alpha = 0
            contrainerView.addSubview(darkBackground)
            //            //
            //            contrainerView.addSubview(transitionImage!)
            
            UIView.animate(withDuration: duration, animations: { [unowned self] in
                darkBackground.alpha = 1
                //                contrainerView.bringSubview(toFront: self.transitionImage!)
                print("original frame from listSong: \(self.originalFrame!)")
                fromVC.imageFromCategoryVC.frame = self.originalFrame!
            }) { (success) in
                contrainerView.addSubview(toView!)
                darkBackground.removeFromSuperview()
                
                
                //                self.transitionImage?.frame = CGRect(x: 100, y: 100, width: 150, height: 130)
                //                        print("transition image from category: \(self.transitionImage?.frame)")
                transitionContext.completeTransition(success)
            }
            
        }
        
        
        
    }
}
