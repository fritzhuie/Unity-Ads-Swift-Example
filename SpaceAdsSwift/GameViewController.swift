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
    
    //Used to track rewarded video rewards in the client
    var playerIsWatchingRewardedVideo = false
    
    override func viewDidLoad() {
        
        //initialize Unity Ads
        UnityAds.sharedInstance().delegate = self
        UnityAds.sharedInstance().startWithGameId("1016671", andViewController: self)
        
        //initialize the SpriteKit Scene
        super.viewDidLoad()
        spaceScene = SpaceScene(size: view.bounds.size)
        planetScene = PlanetScene(size: view.bounds.size)
        scene = spaceScene
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }

    func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {
        //Required by UnityAdsDelegate
        print("unityAdsVideoCompleted called with")
        print("reward key item: \(rewardItemKey), skipped: \(skipped)")
        if (!skipped && playerIsWatchingRewardedVideo) {
            if scene.respondsToSelector("UnityAdsGetReward") {
                let currentScene = scene as! PlanetScene
                currentScene.UnityAdsGetReward()
            } else {
                print("scene not found")
            }
        }
        playerIsWatchingRewardedVideo = false
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    func playAd(rewardedAd: String, sender: SKScene) {
        scene = sender
        if (UnityAds.sharedInstance().canShow()) {
            if(rewardedAd == "rewardedVideo"){
                playerIsWatchingRewardedVideo = true
                UnityAds.sharedInstance().setZone("rewardedVideo");
                //Player cannot skip video
            }else{
                playerIsWatchingRewardedVideo = false
                UnityAds.sharedInstance().setZone("video");
                //Player can skip after 5 seconds
            }
            print("Show: \(UnityAds.sharedInstance().show([kUnityAdsOptionNoOfferscreenKey:true, kUnityAdsOptionGamerSIDKey:"m", kUnityAdsOptionVideoUsesDeviceOrientation:true]))")
        }else{
            print("Ads are not ready")
        }
    }
}
