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
        UnityAds.initialize("20721", delegate: self)
        
        spaceScene = SpaceScene(size: view.bounds.size)
        planetScene = PlanetScene(size: view.bounds.size)
        scene = spaceScene
        launchSpriteKitScene(scene)
    }
    
    func playAd(_ placement: String, sender: SKScene) {
        scene = sender
        playerIsWatchingRewardedVideo = (placement == "rewardedVideo")
        if (UnityAds.isReady(placement)){
            UnityAds.show(self, placementId: placement)
        }else{
            print("Ads are not ready for placement `\(placement)`")
        }
    }
    
    func unityAdsReady(_ placementId: String) {
        
    }
    
    func unityAdsDidStart(_ placementId: String) {
        
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        
    }
    
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        if !scene.responds(to: Selector("UnityAdsGetReward")){
            print("selector 'UnityAdsGetReward' not available for scene \(scene)")
        }else if (state != .skipped && playerIsWatchingRewardedVideo) {
            let currentScene = scene as! PlanetScene
            currentScene.UnityAdsGetReward()
        }
        
        playerIsWatchingRewardedVideo = false
        launchSpriteKitScene(scene)
    }
    
    func launchSpriteKitScene(_ scene: SKScene) {
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}
