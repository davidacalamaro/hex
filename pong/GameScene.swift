//  GameScene.swift
//  pong
//
//  Created by david on 12/14/21.

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball = SKSpriteNode()
    var score = SKLabelNode()
    var scoreNum = 0
    var hex = SKNode()
    var plus = SKNode()
    var pause = SKSpriteNode()
    var gPaused = false
    var resume = SKSpriteNode()
    var resumeLabel = SKLabelNode()
    let time = Double.random(in: 0.45...0.75)
    var rotBox = SKSpriteNode()
    var wait = 0.8
    override func didMove(to view: SKView)
    {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        score = self.childNode(withName: "score")! as! SKLabelNode
        hex = self.childNode(withName: "hex")!
        plus = hex.childNode(withName: "plus")! //
        pause = self.childNode(withName: "pause") as! SKSpriteNode
        resume = self.childNode(withName: "resume")! as! SKSpriteNode
        resumeLabel = resume.childNode(withName: "resumeLabel")! as! SKLabelNode
        rotBox = self.childNode(withName: "turnBox")! as! SKSpriteNode
        plus.physicsBody?.categoryBitMask = 7
        physicsWorld.contactDelegate = self
        
        
        
        
        
        

       
        run(SKAction.repeatForever(SKAction.sequence(
            [
                SKAction.wait(forDuration: wait),
                SKAction.run(make)
            ]
        )))
    }
    
    func gameIsPaused()
    {view?.isPaused = true}
    
    func move()
    {resume.position = CGPoint(x: 0, y: 110)}
       
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = (touches.first?.location(in: self))!
        
        if pause.frame.contains(location)
        {
            if gPaused == false
                {
                let sequence = SKAction.sequence([SKAction.run(move),SKAction.run(gameIsPaused)])
                run(sequence)
                gPaused = true
                }
         
            else
            {
                resume.position = CGPoint(x: -5000, y: 0)
                view?.isPaused = false
                gPaused = false
            }
        }
   
        if resume.frame.contains(location)
        {
            view?.isPaused = false
            resume.position = CGPoint(x: -5000, y: 0)
            gPaused = false
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
//        if ball.position.x == -210 || ball.position.x == 210 || ball.position.y == -350 || ball.position.y == 350
//        {ball.removeFromParent()}
        
        wait = Double.random(in: 0.7...0.8)
        wait = 0
        
        if scoreNum > 9
        {wait = Double.random(in: 0.65...0.75)}
        if scoreNum > 19
        {wait = Double.random(in: 0.6...0.7)}
        if scoreNum > 29
        {wait = Double.random(in: 0.55...0.65)}
        if scoreNum > 39
        {wait = Double.random(in: 0.5...0.6)}
        if scoreNum > 49
        {wait = Double.random(in: 0.45...0.55)}

        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 7
       
        {contact.bodyA.node?.removeFromParent()
            scoreNum+=1
            score.text = "Score: \(scoreNum)"}
        
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 6
       
        {contact.bodyA.node?.removeFromParent()
            scoreNum-=1
            score.text = "Score: \(scoreNum)"}
    
        
        if contact.bodyA.categoryBitMask == 7 && contact.bodyB.categoryBitMask == 2
       
        {contact.bodyB.node?.removeFromParent()
            scoreNum+=1
            score.text = "Score: \(scoreNum)"}
        
        
        if contact.bodyA.categoryBitMask == 6 && contact.bodyB.categoryBitMask == 2
       
        {contact.bodyB.node?.removeFromParent()
            scoreNum-=1
            score.text = "Score: \(scoreNum)"}
        
        explode(pos: contact.contactPoint)
        
    }
    
    func explode(pos: CGPoint)
    {
        if let emitterNode = SKEmitterNode(fileNamed: "MyParticle.sks")
        {
            emitterNode.position = pos
            emitterNode.targetNode = self
            emitterNode.zPosition = 3
            addChild(emitterNode)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let location = (touches.first?.location(in: self))!
        if rotBox.frame.contains(location) && resume.frame.contains(location) == false && gPaused == false
    {
        if let touch = touches.first
        {
                    let touchLocation = touch.location(in: self)
                    rotate(sprite: hex, toPosition: touchLocation)
        }
    }
    
    
    }
    
    
    func rotate(sprite: SKNode, toPosition position: CGPoint)
    {
            
            // Use the atan2 function to determine the angle the sprite should rotate to.
            let angle = atan2(position.y - sprite.position.y, position.x - sprite.position.x)

            // Setup the rotate action using pi to convert the angle into radians
            // for the action.
            let rotateAction = SKAction.rotate(toAngle: angle - .pi / 2, duration: 0.02, shortestUnitArc:true)

            // Run the action on the sprite.
            sprite.run(rotateAction)
    
    }
    
    
    func make()
    {
//        let rWidth = /12.5
//        let rHeight = /22.233333333
//        let xBallBound = (/2)+(rWidth/2)
//        let yBallBound = (/2)+(rHeight/2)
        
        ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30, height: 30))
        ball.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 30))
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.pinned = false
        ball.physicsBody?.mass = 0.257692009210587
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.categoryBitMask = 2
        ball.physicsBody?.collisionBitMask = 2
        ball.physicsBody?.fieldBitMask = 0
        ball.physicsBody?.contactTestBitMask = 6 | 7
        
        let ToB = Int.random(in: 1...3)
        var trueX = 0.0
        var posY = Double.random(in: -348.5...348.5)
        let posY2 = [-348.5, 348.5]
        let posX = Double.random(in: -202.5...202.5)
        let posX2 = [-202.5, 202.5]
        
        if ToB != 3
        {
            if posY == -348.5 || posY == 348.5
            {trueX = posX}
            else
            {trueX = posX2.randomElement()!}
            
        }
        
        else
        {posY = posY2.randomElement()!
            trueX = posX}
        
        ball.position = CGPoint(x: trueX, y: posY)
        ball.physicsBody?.velocity = CGVector(dx: -1*(ball.position.x), dy: -1*(ball.position.y))
        ball.name = "ball"

        addChild(ball)
        print(wait)
    }
    

}
