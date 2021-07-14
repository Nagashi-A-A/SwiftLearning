//
//  GameScene.swift
//  Project17
//
//  Created by Anton Yaroshchuk on 29.06.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    var restartBttn: SKLabelNode!
    
    var isGameOver = false
    var gameTimer: Timer?
    var difficulty = 0.35
    var threshold = 30
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.position = CGPoint(x: 512 , y: 384)
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 44
        gameOverLabel.zPosition = 2
        addChild(gameOverLabel)
        gameOverLabel.isHidden = true
        
        restartBttn = SKLabelNode(fontNamed: "Chalkduster")
        restartBttn.position = CGPoint(x: 512, y: 184)
        restartBttn.text = "RESTART"
        restartBttn.fontSize = 36
        restartBttn.zPosition = 2
        addChild(restartBttn)
        restartBttn.isHidden = true
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        startGame()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if isGameOver{
            gameTimer?.invalidate()
            gameOverLabel.isHidden = false
            restartBttn.isHidden = false
        }
        
        for node in children {
            if node.position.x < -100 {
                node.removeFromParent()
                if !isGameOver{
                    score += 1
                }
            }
        }
        
        if score > threshold {
            gameTimer?.invalidate()
            difficulty -= 0.05
            threshold += 30
            gameTimer = Timer.scheduledTimer(timeInterval: difficulty, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            
            print("Timer was changed to: diff: \(difficulty), threshold: \(threshold)")
            
        }
        
    }
    
    @objc func createEnemy(){
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 80 {
            location.y = 80
        } else if location.y > 688{
            location.y = 688
        }
        
        player.position = location
        
        let objects = nodes(at: location)
        
        if objects.contains(restartBttn){
            startGame()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
    }
    
    func startGame(){
        isGameOver = false
        gameOverLabel.isHidden = true
        restartBttn.isHidden = true
        backgroundColor = .black
        
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 10, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
}
