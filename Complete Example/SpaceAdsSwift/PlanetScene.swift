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
    
    //**** Play rewarded ad (non-skippable) *********/
    
    func UnityAdsPlayRewardedVideo() {

    }
    
    //**** callback from UIViewController ***********/
    
    func UnityAdsGetReward() {
        addFuel(40)
    }
    
    //***********************************************/
    
    var backgroundClicked = false
    var landed = false
    var fuel = 15
    var displayedFuel = 15
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
    var touchEnabled = true
    
    override func didMove(to view: SKView) {
        if(self.children.count == 0) {
            initializeScene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: rootNode)
        let touchedNodes = rootNode.nodes(at: touchLocation)
        
        if (touchEnabled == false) {
            return
        }
        
        for node in touchedNodes {
            if(node.name == nil) {
                continue
            }
            if(node.name == "rewardedAdButton"){
                UnityAdsPlayRewardedVideo()
                return
            }else if(node.name == "gather"){
                addFuel(Int(arc4random())%4 + 2)
                return
            }else if(node.name == "crosshairs"){
                drainFuel()
                gotoSpace()
                return
            }
        }
    }
    
    func initializeScene() {
        addChild(rootNode)
        
        rewardedAdButton.name = "rewardedAdButton"
        rewardedAdButton.position = CGPoint(x: self.frame.midX + 35, y: self.frame.midY - 115)
        rewardedAdButton.size = CGSize(width: 200, height: 100)
        rewardedAdButton.zPosition = 3
        rootNode.addChild(rewardedAdButton)
        
        gatherButton.name = "gather"
        gatherButton.position = CGPoint(x: self.frame.midX - 180, y: self.frame.midY - 115)
        gatherButton.size = CGSize(width: 200, height: 100)
        gatherButton.zPosition = 3
        rootNode.addChild(gatherButton)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        background.size.height = self.frame.height + 400
        background.size.width = background.size.height * (2560/1600) //2560×1600 pixels
        background.zPosition = 0
        rootNode.addChild(background)
        
        fuelIcon.position = CGPoint(x: self.frame.midX + 190, y: self.frame.midY - 120)
        fuelIcon.size.height = 50
        fuelIcon.alpha = 0.6
        fuelIcon.size.width = 42
        fuelIcon.zPosition = 3
        rootNode.addChild(fuelIcon)
        
        fuelPercentage.fontColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 1, alpha: 0.5)
        fuelPercentage.fontSize = 30
        fuelPercentage.fontName = "arial"
        fuelPercentage.position = CGPoint(x: self.frame.midX + 235, y: self.frame.midY - 120 - fuelPercentage.fontSize/2)
        fuelPercentage.zPosition = 3
        fuelPercentage.text = "\(fuel)%"
        rootNode.addChild(fuelPercentage)
        
        console.position.x = self.frame.midX - 5
        console.position.y = self.frame.midY - 5
        console.size.height = self.frame.size.height + 10
        console.size.width = self.frame.size.width + 10
        console.zPosition = 4
        rootNode.addChild(console)
        
        frost.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        frost.size.width = self.frame.size.width
        frost.size.height = (background.size.width * (1600/2560)) //2560 × 1600 pixels
        frost.zPosition = 2
        rootNode.addChild(frost)
        let defrost = SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.fadeAlpha(to: 0.0, duration: 2)])
        frost.run(defrost)
        
        let fadeIn = SKShapeNode(rect: self.frame)
        fadeIn.fillColor = SKColor.white
        fadeIn.zPosition = 1
        rootNode.addChild(fadeIn)
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        fadeIn.run(fade)
        
        gatherButton.isHidden = true
        reveal(gatherButton, delay: 4.0)
        
        rewardedAdButton.isHidden = true
        reveal(rewardedAdButton, delay: 4.2)
        
        fuelIcon.isHidden = true
        reveal(fuelIcon, delay: 4.4)
        
        fuelPercentage.setScale(0.1)
        fuelPercentage.run(SKAction.sequence([SKAction.wait(forDuration: 4.6), SKAction.scale(to: 1.0, duration: 0.2)]))
        
        snowflakes.position = self.frame.origin
        snowflakes.zPosition = 2
        rootNode.addChild(snowflakes)
        
        generateSnow()
    }
    
    @objc func enableTouch() {
        touchEnabled = true
    }
    
    @objc func disableTouch() {
        touchEnabled = false
    }
    
    func hide(_ node: SKSpriteNode) {
        node.run(SKAction.sequence([SKAction.scaleY(to: 0.1, duration: 0.1), SKAction.hide()]))
    }
    
    func reveal(_ node: SKSpriteNode, delay: Double) {
        node.yScale = 0.01
        node.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.run({node.isHidden = false}), SKAction.scaleY(to: 1, duration: 0.1)]))
    }
    
    func addCrosshairs() {
        crosshairs.size.width = 100
        crosshairs.size.height = 100
        crosshairs.alpha = 0.7
        crosshairs.zPosition = 2
        crosshairs.setScale(5)
        crosshairs.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY + 120)
        crosshairs.name = "crosshairs"
        rootNode.addChild(crosshairs)
        let zoom = SKAction.scale(to: 1, duration: 0.5)
        crosshairs.run(SKAction.sequence([SKAction.perform(#selector(PlanetScene.disableTouch), onTarget: self), zoom, SKAction.perform(#selector(PlanetScene.enableTouch), onTarget: self)]))
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: 2*3.1415926, duration: 3))
        crosshairs.run(rotate)
        crosshairsCalled = true
    }

    override func update(_ currentTime: TimeInterval) {
        updateLandingAnimation()
        updateSnowFlakes()
    }
    
    func generateSnow () {

        func addSnowflake() {
            let s = Snowflake(circleOfRadius: 2.0)
            s.fillColor = SKColor.white
            s.position = CGPoint(x: CGFloat(Int(arc4random())%Int(self.frame.maxX)), y: CGFloat(Int(arc4random())%Int(self.frame.maxY)))
            s.velocity = Int(arc4random())%8
            s.momentum = CGVector(dx: 0, dy: 0)
            s.setScale(0.1 * CGFloat(s.velocity))
            if(s.velocity < 3) {
                s.fillColor = SKColor.darkGray
            }else if (s.velocity < 6) {
                s.fillColor = SKColor.lightGray
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
            
            s.momentum.dx = clampf((s.momentum.dx + CGFloat(Int(arc4random())%3) - 1), min: 0, max: 3)
            s.momentum.dy = clampf((s.momentum.dy + CGFloat(Int(arc4random())%3) - 1), min: 0, max: 1)
            
            s.position.x = s.position.x - s.momentum.dx
            s.position.y = s.position.y - CGFloat(s.velocity) - s.momentum.dy
            s.position.y = s.position.y + (self.frame.midY - background.position.y)
            if ( s.position.x < 1) {
                s.position.x = self.frame.maxX
                s.position.y = CGFloat(Int(arc4random())%Int(self.frame.maxY))
            }
            if ( s.position.y < 1) {
                s.position.y = self.frame.maxY
            }
            if ( s.position.y > self.frame.maxY) {
                s.position.y = CGFloat(Int(arc4random())%Int(self.frame.maxY))
            }
        }
    }
    
    func updateLandingAnimation() {
        let offset = self.frame.midY - background.position.y
        background.position.y = (background.position.y) + offset/35.0
        if(offset > 31) {
            let jitter = CGFloat(Int(arc4random()) % Int(offset - 30))
            background.position.x = self.frame.midX + jitter
        }
        if (offset > 10) {
            landed = true
        }
    }

    func gotoSpace () {
        crosshairs.isHidden = true
        let wait = SKAction.wait(forDuration: 1)
        
        let fadeOut = SKShapeNode(rect: self.frame)
        fadeOut.fillColor = SKColor.black
        fadeOut.zPosition = 3
        fadeOut.alpha = 0.0
        rootNode.addChild(fadeOut)
        let fade = SKAction.fadeAlpha(to: 1, duration: 2.0)
        let liftoff = SKAction.sequence([SKAction.move(by: CGVector(dx: 0, dy: -400), duration: 1), SKAction.move(by: CGVector(dx: 0, dy: -4000), duration: 2)])
        let takeoff = SKAction.sequence([wait, SKAction.scale(by: 10, duration: 2)])
        let transition = SKAction.perform(#selector(PlanetScene.loadSpaceScene), onTarget: self)
        background.run(liftoff)
        background.run(takeoff)
        fadeOut.run(SKAction.sequence([wait, fade, transition]))
    }
    
    @objc func loadSpaceScene() {
        let nextScene = SpaceScene(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
    
    func drainFuel() {
        fuel = 15
        
        fuelPercentage.removeAllActions()
        
        var fuelSequence = [SKAction]()
        var fuelActionValue : Int = displayedFuel
        
        while ( fuelActionValue > fuel) {
            fuelActionValue -= 1
            let fuelDisplayValue: Int = fuelActionValue
            fuelSequence.append(SKAction.run({
                self.fuelPercentage.text = "\(fuelDisplayValue)%"
                print(fuelDisplayValue)
                self.displayedFuel = fuelDisplayValue
                self.updatefuelIcon()
            }))
            fuelSequence.append(SKAction.wait(forDuration: 0.03))
        }
        
        fuelPercentage.run(SKAction.sequence(fuelSequence))
        
    }
    
    func addFuel(_ count: Int) {

        //you can use this example to pass values from the View Controller to your scene
        
        if(count < 1 || fuel == 100) {return}
        
        fuel = fuel > 100 - count ? 100 : fuel + count
        
        fuelPercentage.removeAllActions()
        
        var fuelSequence = [SKAction]()
        var fuelActionValue : Int = displayedFuel
        
        while ( fuelActionValue < fuel) {
            fuelActionValue += 1
            let fuelDisplayValue: Int = fuelActionValue
            fuelSequence.append(SKAction.run({
                self.fuelPercentage.text = "\(fuelDisplayValue)%"
                self.displayedFuel = fuelDisplayValue
                self.updatefuelIcon()
            }))
            let delay = 0.5 / (3 + Double(self.fuel) - Double(displayedFuel))
            fuelSequence.append(SKAction.wait(forDuration: delay))
        }
        
        fuelPercentage.run(SKAction.sequence(fuelSequence))
    }
    
    func updatefuelIcon() {
        if (displayedFuel >= 100) {
            displayedFuel = 100
            fuelIcon.texture = SKTexture(imageNamed: "battery100.png")
            hide(gatherButton)
            hide(rewardedAdButton)
            addCrosshairs()
        }else if (displayedFuel > 75){
            fuelIcon.texture = SKTexture(imageNamed: "battery75.png")
        }else if (displayedFuel > 50){
            fuelIcon.texture = SKTexture(imageNamed: "battery50.png")
        }else{
            fuelIcon.texture = SKTexture(imageNamed: "battery25.png")
        }
    }
    
    func max (_ n: CGFloat, max: CGFloat)->CGFloat {
        return n > max ? max : n
    }
    
    func clampf(_ n: CGFloat, min: CGFloat, max: CGFloat)->CGFloat {
        if(n < min){return min}else if(n > max){return max}else{return n}
    }
}
