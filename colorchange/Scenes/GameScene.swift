//
//  GameScene.swift
//  colorchange
//
//  Created by Manish Ghimire on 3/28/18.
//  Copyright © 2018 Manish Ghimire. All rights reserved.
//

import SpriteKit

enum PlayColors{
    static let colors = [
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
    ]
}

enum SwitchState : Int{
    case blue, red, yellow, green
}

class GameScene: SKScene {
    
    var colorchange: SKSpriteNode!
    var switchState  = SwitchState.blue
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func levelIncreaser() -> Double {
        let x:Double = -1.0 - (Double(score)*0.2)
        return Double(x)
    }
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx:0.0, dy:levelIncreaser())
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red:44/255, green:62/255, blue:80/255, alpha:1.0)
        colorchange = SKSpriteNode(imageNamed:"colorCircle")
        colorchange.size = CGSize(width: frame.size.width/3,height:frame.size.width/3)
        colorchange.position = CGPoint(x: frame.midX,y: frame.minY + colorchange.size.height)
        colorchange.zPosition = ZPositons.colorchange
        colorchange.physicsBody = SKPhysicsBody(circleOfRadius:colorchange.size.width/2)
        colorchange.physicsBody?.categoryBitMask = PhysicsCatogeries.switchCategory
        colorchange.physicsBody?.isDynamic = false
        addChild(colorchange)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x:frame.midX,y:frame.midY)
        scoreLabel.zPosition =  ZPositons.level
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    
    func spawnBall() {
        
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball =  SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0,height:30.0))
        
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX,y: frame.maxY)
        ball.zPosition = ZPositons.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius:colorchange.size.width/2)
        ball .physicsBody?.categoryBitMask = PhysicsCatogeries.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCatogeries.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCatogeries.none
        addChild(ball  )
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .blue
        }
        
        colorchange.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver(){
        
        UserDefaults.standard.set(score, forKey: "RecentScore")

        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    
  }

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCatogeries.ballCategory | PhysicsCatogeries.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    run(SKAction.playSoundFileNamed("blink", waitForCompletion: false))
                    score += 1
                    setupPhysics()
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration:  0.10), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                        })
                } else{
                    gameOver()
                }
            }
        }
    }
}
