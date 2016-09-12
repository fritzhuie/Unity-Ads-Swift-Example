//
//  GameViewController.swift
//  SpaceAdsSwift
//
//  Created by Fritz Huie on 11/2/15.
//  Copyright (c) 2015 Unity. All rights reserved.

import UIKit
import SpriteKit

class GameViewController: UIViewController, UnityAdsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize Unity Ads
        UnityAds.sharedInstance().delegate = self
        UnityAds.sharedInstance().setTestMode(true)
        UnityAds.sharedInstance().startWithGameId("84187", andViewController: self)
        
        //Load SpriteKit scene
        let scene = SpaceScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    func playAd(placement: String, sender: SKScene) {
        if (UnityAds.sharedInstance().canShow()) {
            UnityAds.sharedInstance().show()
        }
    }   
    
    func unityAdsVideoCompleted(rewardItemKey: String!, skipped: Bool) {
        if (!skipped) {
            //Reward the player
        }
    }
}
