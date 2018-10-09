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
    
    //**** Play non-rewarded ad (5-second skip) *************/
    
    func UnityAdsPlayVideo() {
        let vc = self.view!.window!.rootViewController as! GameViewController
        vc.playAd("video", sender: self)
    }
    
    //******************************************************/
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        if(self.children.count == 0) {
            self.constructScene()
        }else{
            self.resetScene()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: rootNode)
        let touchedNodes = rootNode.nodes(at: touchLocation)
        
        for node in touchedNodes {
            
            if(node.name == nil) {
                continue
            }
            if(node.name == "adButton"){
                UnityAdsPlayVideo()
                break
                
            }else if(node.name == "search"){
                if (!crosshairsCalled){
                    addcrosshairs()
                    hide(searchButton)
                    hide(tapArrow)
                    break
                }
            }else if(node.name == "crosshairs") {
                //Switch scenes to planet
                landOnPlanet()
                break
            }
        }
    }
    
    func resetScene() {
        planet.name = "planet"
        planet.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY - 20)
        planet.size.height = 300
        planet.size.width = 300
        planet.zPosition = 0
        let planetMovement = SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 100)
        planet.run(planetMovement)
        
        fuelIcon.texture = SKTexture(imageNamed: "battery25.png")
    }
    
    func constructScene () {
        addChild(rootNode)
        
        console.position.x = self.frame.midX - 5
        console.position.y = self.frame.midY - 5
        console.size.height = self.frame.size.height + 10
        console.size.width = self.frame.size.width + 10
        console.zPosition = 3
        rootNode.addChild(console)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size.width = self.frame.size.width + 100
        background.size.height = (background.size.width * (1035/1365))
        background.zPosition = -1
        rootNode.addChild(background)
        
        fuelIcon.position = CGPoint(x: self.frame.midX + 190, y: self.frame.midY - 120)
        fuelIcon.size.height = 50
        fuelIcon.alpha = 0.6
        fuelIcon.size.width = 42
        if (deviceIsAniPad) {
            fuelIcon.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY - 250)
            fuelIcon.size.width*=1.5
            fuelIcon.size.height*=1.5
        }else{
            fuelIcon.position = CGPoint(x: self.frame.midX + 190, y: self.frame.midY - 120)
        }
        fuelIcon.zPosition = 3
        rootNode.addChild(fuelIcon)
        
        fuelPercentage.fontColor = SKColor(colorLiteralRed: 0, green: 144, blue: 255, alpha: 50)
        fuelPercentage.fontSize = 30
        fuelPercentage.fontName = "arial"
        fuelPercentage.position = CGPoint(x: self.frame.midX + 235, y: self.frame.midY - 120 - fuelPercentage.fontSize/2)
        fuelPercentage.zPosition = 3
        fuelPercentage.text = "\(fuel)%"
        rootNode.addChild(fuelPercentage)
        
        adButton.name = "adButton"
        adButton.size = buttonSize
        adButton.zPosition = 4
        adButton.size = buttonSize
        if (deviceIsAniPad) {
            adButton.position = CGPoint(x: self.frame.midX - 300, y: self.frame.midY - 250)
            adButton.size.height*=1.5
            adButton.size.width*=1.5
        }else{
            adButton.position = CGPoint(x: self.frame.midX - 180, y: self.frame.midY - 120)
        }
        rootNode.addChild(adButton)
        
        searchButton.name = "search"
        searchButton.position = CGPoint(x: self.frame.midX + 35, y: self.frame.midY - 120)
        searchButton.size = buttonSize
        searchButton.zPosition = 4
        rootNode.addChild(searchButton)
        
        rootNode.addChild(tapArrow)
        tapArrow.zPosition = 5
        tapArrow.size = CGSize(width: 64, height: 64)
        tapArrow.position = CGPoint(x: searchButton.position.x, y: searchButton.position.y + 75)
        
        rootNode.addChild(planet)
        planet.name = "planet"
        planet.position = CGPoint(x: self.frame.midX + 200, y: self.frame.midY - 20)
        planet.size.height = 300
        planet.size.width = 300
        planet.zPosition = 0
        let planetMovement = SKAction.move(by: CGVector(dx: -300, dy: 0), duration: 100)
        planet.run(planetMovement)
        
        
        let fadeIn = SKShapeNode(rect: self.frame)
        fadeIn.fillColor = SKColor.black
        fadeIn.alpha = 1.0
        fadeIn.zPosition = 3
        rootNode.addChild(fadeIn)
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
        fadeIn.run(fade)
        
        tapArrow.isHidden = true
        reveal(tapArrow, delay: 3.0)
        startBouncing(tapArrow, distance: 30.0, delay: 3.0)
        
        adButton.isHidden = true
        reveal(adButton, delay: 2.0)
        
        searchButton.isHidden = true
        reveal(searchButton, delay: 2.2)
        
        fuelIcon.isHidden = true
        reveal(fuelIcon, delay: 2.4)
        
        fuelPercentage.setScale(0.1)
        fuelPercentage.run(SKAction.sequence([SKAction.wait(forDuration: 2.6), SKAction.scale(to: 1.0, duration: 0.2)]))
        
        
        starTravelNodes.position = self.frame.origin
        starTravelNodes.zPosition = 1
        rootNode.addChild(starTravelNodes)
        generateParalaxStarscape()
    }
    
    func addcrosshairs() {
        crosshairs.size.width = 100
        crosshairs.size.height = 100
        crosshairs.alpha = 0.7
        crosshairs.zPosition = 2
        crosshairs.setScale(5)
        crosshairs.name = "crosshairs"
        rootNode.addChild(crosshairs)
        let zoom = SKAction.scale(to: 1, duration: 0.5)
        crosshairs.run(zoom)
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: 2*3.1415926, duration: 3))
        crosshairs.run(rotate)
        crosshairsCalled = true
    }
    
    func landOnPlanet () {
        
        fuelPercentage.isHidden = true
        starTravelNodes.isHidden = true
        crosshairs.isHidden = true
        fuelIcon.isHidden = true
        searchButton.isHidden = true
        adButton.isHidden = true
        
        let dive = SKAction.move(to: CGPoint(x: self.frame.midX + 300, y: self.frame.midY - 300), duration: 1)
        let dive2 = SKAction.scale(to: 10, duration: 1)
        planet.run(dive)
        planet.run(dive2)
        
        let fadeOut = SKShapeNode(rect: self.frame)
        fadeOut.fillColor = SKColor.white
        fadeOut.zPosition = 2
        fadeOut.name = "fade"
        fadeOut.alpha = 0.0
        rootNode.addChild(fadeOut)
        let fade = SKAction.fadeIn(withDuration: 1)
        let transition = SKAction.perform(#selector(SpaceScene.transition), onTarget: self)
        fadeOut.run(SKAction.sequence([fade, transition]))
    }
    
    func transition () {
        rootNode.childNode(withName: "fade")?.removeFromParent()
        let nextScene = PlanetScene(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        scene?.view?.presentScene(nextScene)
    }
   
    override func update(_ currentTime: TimeInterval) {
        self.updateParalaxStarscape()
        crosshairs.position = CGPoint(x: planet.position.x - 30, y: planet.position.y + 30)
    }
    
    func generateParalaxStarscape () {
        
        func addStar() {
            
            let star = SKStarNode(circleOfRadius: 2.0)
            star.fillColor = SKColor.white
            star.position = CGPoint(x: CGFloat(Int(arc4random())%Int(self.frame.maxX)), y: CGFloat(Int(arc4random())%Int(self.frame.maxY)))
            star.velocity = Int(arc4random())%10
            star.setScale(0.1 * CGFloat(star.velocity))
            if(star.velocity < 3){
                star.fillColor = SKColor.darkGray
            }else if (star.velocity < 6) {
                star.fillColor = SKColor.lightGray
            }
            
            starTravelNodes.addChild(star)
        }
        while (starTravelNodes.children.count < 25) {
            addStar()
        }
    }
    
    func updateParalaxStarscape () {
        for s in starTravelNodes.children {
            let star = s as! SKStarNode
            star.position.x = star.position.x - CGFloat(star.velocity)
            if ( star.position.x < 1) {
                star.position.x = self.frame.maxX
                star.position.y = CGFloat(Int(arc4random())%Int(self.frame.maxY))
            }
        }
    }

    func hide(_ node: SKSpriteNode) {
        node.removeAllActions()
        node.run(SKAction.sequence([SKAction.scaleY(to: 0.1, duration: 0.1), SKAction.hide()]))
    }
    
    func reveal(_ node: SKSpriteNode, delay: Double) {
        node.yScale = 0.01
        node.run(SKAction.sequence([SKAction.wait(forDuration: delay), SKAction.run({node.isHidden = false}), SKAction.scaleY(to: 1, duration: 0.1)]))
    }
    
    func startBouncing(_ node: SKSpriteNode, distance: CGFloat, delay: Double){
        let ratios : [CGFloat] = [0.4, 0.3, 0.2, 0.1, 0.0, -0.1, -0.2, -0.3, -0.4]
        var sequence = [SKAction]()
        for i in ratios {
            sequence.append(SKAction.move(by: CGVector(dx: 0,dy: (distance * i)), duration: 0.1))
        }
        node.run(SKAction.repeatForever(SKAction.sequence(sequence)))
        print(sequence.count)
    }
    
    var fuel = 15
    var shipPosition = CGPoint()
    var crosshairsCalled = false
    let fuelPercentage = SKLabelNode()
    let starTravelNodes = SKNode()
    var rootNode = SKNode()
    let crosshairs = SKSpriteNode(imageNamed: "tricurser.png")
    let planet = SKSpriteNode(imageNamed: "planetb.png")
    let fuelIcon = SKSpriteNode(imageNamed: "battery25.png")
    let background = SKSpriteNode(imageNamed: "stars.jpg")
    let console = SKSpriteNode(imageNamed: "console.png")
    let searchButton = SKSpriteNode(imageNamed: "locatefuelbutton.png")
    let adButton = SKSpriteNode(imageNamed: "playadbutton.png")
    let tapArrow = SKSpriteNode(imageNamed: "arrow.png")
    let buttonSize = CGSize(width: 200, height: 100)
    var deviceIsAniPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
}


class SKStarNode : SKShapeNode {
    var velocity = Int()
    var brightness = Int()
}
