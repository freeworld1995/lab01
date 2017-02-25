//
//  AppDelegate.swift
//  Lab01
//
//  Created by Jimmy Hoang on 2/19/17.
//  Copyright © 2017 Jimmy Hoang. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let scc = MPRemoteCommandCenter.shared()
    func createMenuView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let categoryViewController = storyboard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc = CustomNavigationController(rootViewController: categoryViewController)
        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        self.window?.rootViewController = slideMenuController
        PlayerController.shared.frame = CGRect(x: 0, y: 0, width: self.window!.frame.width, height: 70)
        self.window?.rootViewController?.view.addSubview(PlayerController.shared)
        
        let rectBottom = NSLayoutConstraint(item: PlayerController.shared, attribute: .bottom, relatedBy: .equal, toItem: self.window?.rootViewController?.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let rectTrailing = NSLayoutConstraint(item: PlayerController.shared, attribute: .trailing, relatedBy: .equal, toItem: self.window?.rootViewController?.view, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let rectLeading = NSLayoutConstraint(item: PlayerController.shared, attribute: .leading, relatedBy: .equal, toItem: self.window?.rootViewController?.view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let rectHeight = NSLayoutConstraint(item: PlayerController.shared, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 70)
        
        self.window?.rootViewController?.view.addConstraint(rectTrailing)
        self.window?.rootViewController?.view.addConstraint(rectLeading)
        self.window?.rootViewController?.view.addConstraint(rectHeight)
        self.window?.rootViewController?.view.addConstraint(rectBottom)
        
        NSLayoutConstraint.activate([rectBottom, rectTrailing, rectLeading, rectHeight])
        
        //        self.window?.bringSubview(toFront: smallVC.view)
        //        let rect = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        //        rect.backgroundColor = UIColor.red
        
        
        //        UIApplication.shared.keyWindow?.addSubview(rect)
        //        UIApplication.shared.keyWindow?.bringSubview(toFront: rect)
        self.window?.makeKeyAndVisible()
        setupControlCenter()
    }
    
    func setupControlCenter() {
        
        
        scc.playCommand.addTarget { (success) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        scc.pauseCommand.addTarget(self, action: #selector(doPause))
        scc.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
        
    }
    
    func doPlay(_ event: MPRemoteCommandEvent) {
        print("play")
        AudioManager.shareInstance.player?.play()
    }
    
    func doPause(_ event: MPRemoteCommandEvent) {
        print("pause")
        AudioManager.shareInstance.player?.pause()
    }
    
    func doPlayPause(_ event: MPRemoteCommandEvent) {
        print("PlayPause")
        if AudioManager.shareInstance.player?.rate != 0 {
            AudioManager.shareInstance.player?.play()
        } else {
            AudioManager.shareInstance.player?.pause()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        createMenuView()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

