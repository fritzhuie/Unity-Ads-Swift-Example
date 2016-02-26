//
//  SpaceScene.swift
//  SpaceAdsSwift
//
//  Created by Fritz Huie on 11/16/15.
//  Copyright © 2015 Unity. All rights reserved.
//  Planet illustration provided by NASA - Original image by ESA/Hubble (M. Kornmesser) - https://www.spacetelescope.org/
//

import UIKit
import SpriteKit

class SpaceScene: SKScene {
    
    func UnityAdsPlayVideo() {
        //Play a video ad
        let vc = self.view!.window!.rootViewController as! GameViewController
        vc.playAd("video", sender: self)
    }
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        self.constructScene()
    }
    
    func constructScene () {
        removeAllChildren()
        addChild(rootNode)
        
        console.position.x = self.frame.midX - 5
        console.position.y = self.frame.midY - 5
        console.size.height = self.frame.size.height + 10
        console.size.width = self.frame.size.width + 10
        console.zPosition = 3
        rootNode.addChild(console)
        
        background.position = CGPointMake(self.frame.midX, self.frame.midY)
        background.size.width = self.frame.size.width + 100
        background.size.height = (background.size.width * (1035/1365))
        background.zPosition = 0
        rootNode.addChild(background)
        
        rootNode.addChild(planet)
        planet.position = CGPointMake(self.frame.midX + 200, self.frame.midY - 20)
        planet.size.height = 300
        planet.size.width = 300
        planet.zPosition = 1
        let planetMovement = SKAction.moveBy(CGVector(dx: -200, dy: 0), duration: 100)
        planet.runAction(planetMovement)
        
        adButton.name = "adButton"
        adButton.size = buttonSize
        adButton.zPosition = 4
        adButton.size = buttonSize
        if (deviceIsAniPad) {
            adButton.position = CGPointMake(self.frame.midX - 300, self.frame.midY - 250)
            adButton.size.height*=1.5
            adButton.size.width*=1.5
        }else{
            adButton.position = CGPointMake(self.frame.midX, self.frame.midY - 120)
        }
        rootNode.addChild(adButton)
        adButton.hidden = true
        reveal(adButton, delay: 2.0)
        
        
        let fadeIn = SKShapeNode(rect: self.frame)
        fadeIn.fillColor = SKColor.blackColor()
        fadeIn.alpha = 1.0
        fadeIn.zPosition = 3
        rootNode.addChild(fadeIn)
        let fade = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        fadeIn.runAction(fade)
        
        starTravelNodes.position = self.frame.origin
        starTravelNodes.zPosition = 1
        rootNode.addChild(starTravelNodes)
        generateParalaxStarscape()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(rootNode)
        let touchedNodes = rootNode.nodesAtPoint(touchLocation)
        
        for node in touchedNodes {
            if(node.name == "adButton"){
                UnityAdsPlayVideo()
                return
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        //animate stars
        for s in starTravelNodes.children {
            let star = s as! SKStarNode
            star.position.x = star.position.x - CGFloat(star.velocity)
            if ( star.position.x < 1) {
                star.position.x = self.frame.maxX
                star.position.y = CGFloat(random()%Int(self.frame.maxY))
            }
        }
    }
    
    func generateParalaxStarscape () {
        func addStar() {
            let star = SKStarNode(circleOfRadius: 2.0)
            star.fillColor = SKColor.whiteColor()
            star.position = CGPointMake(CGFloat(random()%Int(self.frame.maxX)), CGFloat(random()%Int(self.frame.maxY)))
            star.velocity = random()%10
            star.setScale(0.1 * CGFloat(star.velocity))
            if(star.velocity < 3){
                star.fillColor = SKColor.darkGrayColor()
            }else if (star.velocity < 6) {
                star.fillColor = SKColor.lightGrayColor()
            }
            starTravelNodes.addChild(star)
        }
        while (starTravelNodes.children.count < 25) {
            addStar()
        }
    }
    
    func reveal(node: SKSpriteNode, delay: Double) {
        node.yScale = 0.01
        node.runAction(SKAction.sequence([SKAction.waitForDuration(delay), SKAction.runBlock({node.hidden = false}), SKAction.scaleYTo(1, duration: 0.1)]))
    }
    
    let starTravelNodes = SKNode()
    var rootNode = SKNode()
    let planet = SKSpriteNode(imageNamed: "planetb.png")
    let background = SKSpriteNode(imageNamed: "stars.jpg")
    let console = SKSpriteNode(imageNamed: "console.png")
    let adButton = SKSpriteNode(imageNamed: "playadbutton.png")
    let buttonSize = CGSizeMake(200, 100)
    var deviceIsAniPad: Bool = UIDevice.currentDevice().userInterfaceIdiom == .Pad
}


class SKStarNode : SKShapeNode {
    var velocity = Int()
    var brightness = Int()
}