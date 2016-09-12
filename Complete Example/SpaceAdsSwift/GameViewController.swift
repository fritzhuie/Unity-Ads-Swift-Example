//
//  GameViewController.swift
//  SpaceAdsSwift
//
//  Created by Fritz Huie on 11/2/15.
//  Copyright (c) 2015 Unity. All rights reserved.

import UIKit
import SpriteKit
import UnityAds

class GameViewController: UIViewController, UnityAdsDelegate {

    var spaceScene = SpaceScene()
    var planetScene = PlanetScene()
    var scene = SKScene()
    
    //Used to track rewarded ads in the client
    var playerIsWatchingRewardedVideo = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //initialize Unity Ads
        UnityAds.initialize("1003843", delegate: self)
        
        spaceScene = SpaceScene(size: view.bounds.size)
        planetScene = PlanetScene(size: view.bounds.size)
        scene = spaceScene
        launchSpriteKitScene(scene)
    }
    
    func playAd(placement: String, sender: SKScene) {
        scene = sender
        playerIsWatchingRewardedVideo = (placement == "rewardedVideo")
        if (UnityAds.isReady(placement)){
            UnityAds.show(self, placementId: placement)
        }else{
            print("Ads are not ready for placement `\(placement)`")
        }
    }
    
    func unityAdsReady(placementId: String) {
        
    }
    
    func unityAdsDidStart(placementId: String) {
        
    }
    
    func unityAdsDidError(error: UnityAdsError, withMessage message: String) {
        
    }
    
    func unityAdsDidFinish(placementId: String, withFinishState state: UnityAdsFinishState) {
        if !scene.respondsToSelector(Selector("UnityAdsGetReward")){
            print("selector 'UnityAdsGetReward' not available for scene \(scene)")
        }else if (state != .Skipped && playerIsWatchingRewardedVideo) {
            let currentScene = scene as! PlanetScene
            currentScene.UnityAdsGetReward()
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
