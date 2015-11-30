//
//  PlanetScene.swift
//  SpaceAdsSwift
//
//  Created by Fritz Huie on 11/23/15.
//  Copyright © 2015 Unity. All rights reserved.

import UIKit
import SpriteKit

class Snowflake : SKStarNode {
    var momentum = CGVector()
}

class PlanetScene : SKScene {
    
    //**** Play a non-skippable ad from SKScene *************
    
    func UnityAdsPlayRewardedVideo() {
        let vc = self.view!.window!.rootViewController as! GameViewController
        vc.playAd("rewardedVideo", sender: self)
    }
    
    //**** Recieve callback from UIViewController *******
    
    func UnityAdsGetReward() {
        addFuel(50)
    }
    
    //***************************************************
    
    var backgroundClicked = false
    var landed = false
    var fuel = 15
    let rootNode = SKNode()
    let fuelPercentage = SKLabelNode()
    let snowflakes = SKNode()
    let background = SKSpriteNode(imageNamed: "landscape.png")
    let frost = SKSpriteNode(imageNamed: "frost.png")
    let console = SKSpriteNode(imageNamed: "console.png")
    let fuelIcon = SKSpriteNode(imageNamed: "battery25.png")
    let rewardedAdButton = SKSpriteNode(imageNamed: "rewardedbutton.png")
    let gatherButton = SKSpriteNode(imageNamed: "gatherbutton.png")
    let crosshairs = SKSpriteNode(imageNamed: "tricurser.png")
    var crosshairsCalled = false
    
    override func didMoveToView(view: SKView) {
        if(self.children.count == 0) {
            initializeScene()
        }
    }
    
    func initializeScene() {
        addChild(rootNode)
        
        rewardedAdButton.name = "rewardedAdButton"
        rewardedAdButton.position = CGPointMake(self.frame.midX + 35, self.frame.midY - 115)
        rewardedAdButton.size = CGSizeMake(200, 100)
        rewardedAdButton.zPosition = 3
        rootNode.addChild(rewardedAdButton)
        
        gatherButton.name = "gather"
        gatherButton.position = CGPointMake(self.frame.midX - 180, self.frame.midY - 115)
        gatherButton.size = CGSizeMake(200, 100)
        gatherButton.zPosition = 3
        rootNode.addChild(gatherButton)
        
        background.position = CGPointMake(self.frame.midX, self.frame.midY - 200)
        background.size.height = self.frame.height + 400
        background.size.width = background.size.height * (2560/1600) //2560×1600 pixels
        background.zPosition = 0
        rootNode.addChild(background)
        
        fuelIcon.position = CGPointMake(self.frame.midX + 190, self.frame.midY - 120)
        fuelIcon.size.height = 50
        fuelIcon.alpha = 0.6
        fuelIcon.size.width = 42
        fuelIcon.zPosition = 3
        fuelIcon.userInteractionEnabled = false
        rootNode.addChild(fuelIcon)
        
        fuelPercentage.fontColor = SKColor(colorLiteralRed: 0, green: 144, blue: 255, alpha: 50)
        fuelPercentage.fontSize = 30
        fuelPercentage.fontName = "arial"
        fuelPercentage.position = CGPointMake(self.frame.midX + 235, self.frame.midY - 120 - fuelPercentage.fontSize/2)
        fuelPercentage.zPosition = 3
        fuelPercentage.text = "\(fuel)%"
        fuelPercentage.userInteractionEnabled = false
        rootNode.addChild(fuelPercentage)
        
        console.position.x = self.frame.midX - 5
        console.position.y = self.frame.midY - 5
        console.size.height = self.frame.size.height + 10
        console.size.width = self.frame.size.width + 10
        console.zPosition = 4
        console.userInteractionEnabled = false
        rootNode.addChild(console)
        
        frost.position = CGPointMake(self.frame.midX, self.frame.midY)
        frost.size.width = self.frame.size.width
        frost.size.height = (background.size.width * (1600/2560)) //2560 × 1600 pixels
        frost.zPosition = 2
        frost.userInteractionEnabled = false
        rootNode.addChild(frost)
        let defrost = SKAction.sequence([SKAction.waitForDuration(4), SKAction.fadeAlphaTo(0.0, duration: 2)])
        frost.runAction(defrost)
        
        let fadeIn = SKShapeNode(rect: self.frame)
        fadeIn.fillColor = SKColor.whiteColor()
        fadeIn.zPosition = 1
        rootNode.addChild(fadeIn)
        let fade = SKAction.fadeAlphaTo(0.0, duration: 1.0)
        fadeIn.runAction(fade)
        
        gatherButton.hidden = true
        reveal(gatherButton, delay: 4.0)
        
        rewardedAdButton.hidden = true
        reveal(rewardedAdButton, delay: 4.2)
        
        fuelIcon.hidden = true
        reveal(fuelIcon, delay: 4.4)
        
        fuelPercentage.setScale(0.1)
        fuelPercentage.runAction(SKAction.sequence([SKAction.waitForDuration(4.6), SKAction.scaleTo(1.0, duration: 0.2)]))
        
        snowflakes.position = self.frame.origin
        snowflakes.zPosition = 2
        rootNode.addChild(snowflakes)
        
        generateSnow()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.locationInNode(rootNode)
        let touchedNodes = rootNode.nodesAtPoint(touchLocation)
        
        for node in touchedNodes {
            if(node.name == nil) {
                continue
            }
            if(node.name == "rewardedAdButton"){
                
                UnityAdsPlayRewardedVideo()
                break
                
            }else if(node.name == "gather"){
                addFuel(random()%5)
                break
            }else if(node.name == "crosshairs"){
                gotoSpace()
                break
            }
        }
    }
    
    func hide(node: SKSpriteNode) {
        node.userInteractionEnabled = false
        node.runAction(SKAction.sequence([SKAction.scaleYTo(0.1, duration: 0.1), SKAction.hide()]))
    }
    
    func reveal(node: SKSpriteNode, delay: Double) {
        node.hidden = false
        node.yScale = 0.01
        node.runAction(SKAction.sequence([SKAction.waitForDuration(delay), SKAction.waitForDuration(0.3), SKAction.scaleYTo(1, duration: 0.1)]))
    }
    
    func addCrosshairs() {
        
        
        crosshairs.size.width = 100
        crosshairs.size.height = 100
        crosshairs.alpha = 0.7
        crosshairs.zPosition = 2
        crosshairs.setScale(5)
        crosshairs.position = CGPointMake(self.frame.midX - 80, self.frame.midY + 120)
        crosshairs.name = "crosshairs"
        rootNode.addChild(crosshairs)
        let zoom = SKAction.scaleTo(1, duration: 0.5)
        crosshairs.runAction(zoom)
        let rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(2*3.1415926, duration: 3))
        crosshairs.runAction(rotate)
        crosshairsCalled = true
    }

    override func update(currentTime: CFTimeInterval) {
        updateLandingAnimation()
        updateSnowFlakes()
    }
    
    func generateSnow () {

        func addSnowflake() {
            let s = Snowflake(circleOfRadius: 2.0)
            s.fillColor = SKColor.whiteColor()
            s.position = CGPointMake(CGFloat(random()%Int(self.frame.maxX)), CGFloat(random()%Int(self.frame.maxY)))
            s.velocity = random()%8
            s.momentum = CGVectorMake(0, 0)
            s.setScale(0.1 * CGFloat(s.velocity))
            if(s.velocity < 3) {
                s.fillColor = SKColor.darkGrayColor()
            }else if (s.velocity < 6) {
                s.fillColor = SKColor.lightGrayColor()
            }
            
            snowflakes.addChild(s)
        }
        while (snowflakes.children.count < 40) {
            addSnowflake()
        }
    }
    
    func updateSnowFlakes () {
        for snowflake in snowflakes.children {
            let s = snowflake as! Snowflake
            
            s.momentum.dx = clampf((s.momentum.dx + CGFloat(random()%3) - 1), min: 0, max: 3)
            s.momentum.dy = clampf((s.momentum.dy + CGFloat(random()%3) - 1), min: 0, max: 1)
            
            s.position.x = s.position.x - s.momentum.dx
            s.position.y = s.position.y - CGFloat(s.velocity) - s.momentum.dy
            s.position.y = s.position.y + (self.frame.midY - background.position.y)
            if ( s.position.x < 1) {
                s.position.x = self.frame.maxX
                s.position.y = CGFloat(random()%Int(self.frame.maxY))
            }
            if ( s.position.y < 1) {
                s.position.y = self.frame.maxY
            }
            if ( s.position.y > self.frame.maxY) {
                s.position.y = CGFloat(random()%Int(self.frame.maxY))
            }
        }
    }
    
    func updateLandingAnimation() {
        let offset = self.frame.midY - background.position.y
        background.position.y = (background.position.y) + offset/35.0
        if(offset > 31) {
            let jitter = CGFloat(random() % Int(offset - 30))
            background.position.x = self.frame.midX + jitter
        }
        if (offset > 10) {
            landed = true
        }
    }

    func gotoSpace () {
        crosshairs.hidden = true
        let wait = SKAction.waitForDuration(1)
        
        let fadeOut = SKShapeNode(rect: self.frame)
        fadeOut.fillColor = SKColor.blackColor()
        fadeOut.zPosition = 3
        fadeOut.alpha = 0.0
        rootNode.addChild(fadeOut)
        let fade = SKAction.fadeAlphaTo(1, duration: 2.0)
        let liftoff = SKAction.sequence([SKAction.moveBy(CGVectorMake(0, -400), duration: 1), SKAction.moveBy(CGVectorMake(0, -4000), duration: 2)])
        let takeoff = SKAction.sequence([wait, SKAction.scaleBy(10, duration: 2)])
        let transition = SKAction.performSelector("loadSpaceScene", onTarget: self)
        background.runAction(liftoff)
        background.runAction(takeoff)
        fadeOut.runAction(SKAction.sequence([wait, fade, transition]))
    }
    
    func loadSpaceScene() {
        let nextScene = SpaceScene(size: scene!.size)
        nextScene.scaleMode = .AspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    func addFuel(count: Int) {

        //you can use this example to pass values from the View Controller to your scene
        
        if(count > 0) {
            fuel+=count
        }
        if (fuel >= 100) {
            fuel = 100
            fuelIcon.texture = SKTexture(imageNamed: "battery100.png")
            hide(gatherButton)
            addCrosshairs()
        }else if (fuel > 65){
            fuelIcon.texture = SKTexture(imageNamed: "battery75.png")
        }else if (fuel > 35){
            fuelIcon.texture = SKTexture(imageNamed: "battery50.png")
        }else{
            fuelIcon.texture = SKTexture(imageNamed: "battery25.png")
        }
        
        fuelPercentage.text = "\(fuel)%"
        
    }
    
    func max (n: CGFloat, max: CGFloat)->CGFloat {
        return n > max ? max : n
    }
    
    func clampf(n: CGFloat, min: CGFloat, max: CGFloat)->CGFloat {
        if(n < min){return min}else if(n > max){return max}else{return n}
    }
}
