//
//  GameScene.swift
//  GuessCard
//
//  Created by Anton Babko on 18.10.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var state: Bool = false
    
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        let aspectRatio = background.size.width / background.size.height
        if size.width > size.height {
            background.size = CGSize(width: size.width, height: size.width / aspectRatio)
        } else {
            background.size = CGSize(width: size.height * aspectRatio, height: size.height)
        }
        addChild(background)
    }
    
    func fire() {
        let particle = SKEmitterNode(fileNamed: "FireUp.sks")
        particle!.zPosition = 11
        particle?.particlePositionRange.dx = size.width
        particle!.targetNode = self
        addChild(particle!)
        particle!.position = CGPoint(x: size.width/2, y: 0)
        particle?.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
            particle?.particleAlpha = 0
        }, SKAction.wait(forDuration: 1) , SKAction.removeFromParent()]))
        let particle2 = SKEmitterNode(fileNamed: "FireDown.sks")
        particle2!.zPosition = 11
        particle2?.particlePositionRange.dx = size.width
        particle2!.targetNode = self
        addChild(particle2!)
        particle2!.position = CGPoint(x: size.width/2, y: size.height)
        particle2?.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
            particle2?.particleAlpha = 0
        }, SKAction.wait(forDuration: 1) , SKAction.removeFromParent()]))
    }
    
    func complete() {
        let particle = SKEmitterNode(fileNamed: "FireUp.sks")
        particle!.zPosition = 11
        particle?.particlePositionRange.dx = size.width
        particle!.targetNode = self
        addChild(particle!)
        particle?.particleColor = .cyan
        particle!.position = CGPoint(x: size.width/2, y: 0)
        particle?.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
            particle?.particleAlpha = 0
        }, SKAction.wait(forDuration: 1) , SKAction.removeFromParent()]))
        let particle2 = SKEmitterNode(fileNamed: "FireDown.sks")
        particle2!.zPosition = 11
        particle2?.particlePositionRange.dx = size.width
        particle2!.targetNode = self
        addChild(particle2!)
        particle2?.particleColor = .cyan
        particle2!.position = CGPoint(x: size.width/2, y: size.height)
        particle2?.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
            particle2?.particleAlpha = 0
        }, SKAction.wait(forDuration: 1) , SKAction.removeFromParent()]))
    }
    
    func next() {
        state.toggle()
        let particle = SKEmitterNode(fileNamed: "Magic.sks")
        particle!.zPosition = 11
        particle?.particlePositionRange.dx = size.width
        particle?.particlePositionRange.dy = size.height
        particle!.targetNode = self
        addChild(particle!)
        particle!.position = CGPoint(x: size.width/2, y: size.height/2)
        particle?.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
            if self.state {
                self.background.run(SKAction.setTexture(SKTexture(imageNamed: "background2")))
            } else {
                self.background.run(SKAction.setTexture(SKTexture(imageNamed: "background")))
            }
           
            particle?.particleAlpha = 0
        }, SKAction.wait(forDuration: 3) , SKAction.removeFromParent()]))
    }
    
}
