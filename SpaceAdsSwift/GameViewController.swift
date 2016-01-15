//
//  GameViewController.swift
//  SpaceAdsSwift
//
//  Created by Fritz Huie on 11/2/15.
//  Copyright (c) 2015 Unity. All rights reserved.

import UIKit
import SpriteKit

class GameViewController: UIViewController, UnityAdsDelegate {

    var spaceScene = SpaceScene()
    var planetScene = PlanetScene()
    var scene = SKScene()
    
    //Used to track rewarded ads in the client
    var playerIsWatchingRewardedVideo = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //initialize Unity Ads
        UnityAds.sharedInstance().delegate = self
        UnityAds.sharedInstance().startWithGameId("1016671", andViewController: self)
        
        spaceScene = SpaceScene(size: view.bounds.size)
        planetScene = PlanetScene(size: view.bounds.size)
        scene = spaceScene
        launchSpriteKitScene(scene)
    }
    
    func playAd(placement: String, sender: SKScene) {
        scene = sender
        playerIsWatchingRewardedVideo = (placement == "rewardedVideo")
        UnityAds.sharedInstance().setZone(placement);
        
        if (UnityAds.sharedInstance().canShowZone(placement)) {
            UnityAds.sharedInstance().show()
        }else{
            print("Ads are not ready for zoneId \(placement)")
        }
    }
    
    func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {
        //Unity Ads Callback - Called when ad finishes
        print("unityAdsVideoCompleted called with")
        print("reward key item: \(rewardItemKey), skipped: \(skipped)")
        if (!skipped && playerIsWatchingRewardedVideo) {
            if scene.respondsToSelector("UnityAdsGetReward") {
                let currentScene = scene as! PlanetScene
                currentScene.UnityAdsGetReward()
            } else {
                print("selector 'UnityAdsGetReward' not available for scene \(scene)")
            }
        }
        playerIsWatchingRewardedVideo = false
        
        launchSpriteKitScene(scene)
    }
    
    func launchSpriteKitScene(scene: SKScene) {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
}
