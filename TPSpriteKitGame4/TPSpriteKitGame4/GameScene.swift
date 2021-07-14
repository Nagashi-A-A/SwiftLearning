//
//  GameScene.swift
//  Project20
//
//  Created by Anton Yaroshchuk on 01.07.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var scoreLabel: SKLabelNode!
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1048
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.fontSize = 28
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 0
        addChild(scoreLabel)
        
        score = 0
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed(){
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    @objc func launchFireworks(){
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3){
        case 0:
            var slideAmount = -200
            for _ in 0..<5 {
                createFirework(xMovement: 0, x: 512 + slideAmount, y: bottomEdge)
                slideAmount += 100
            }
        case 1:
            var slideAmount = -200
            for _ in 0..<5{
                createFirework(xMovement: CGFloat(slideAmount), x: 512 + slideAmount, y: bottomEdge)
                slideAmount += 100
            }
            
        case 2:
            var slideAmount = 400
            for _ in 0..<5{
                createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + slideAmount)
                slideAmount -= 100
            }
        case 3:
            var slideAmount = 400
            for _ in 0..<5{
                createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + slideAmount)
                slideAmount -= 100
            }
        default:
            break
            
        }
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int){
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2){
            case 0:
                firework.color = .cyan
            case 1:
                firework.color = .green
            default:
                firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        fireworks.append(node)
        addChild(node)
    }
    
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodesAtpoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtpoint{
            guard node.name == "firework" else { continue }
            
            for parent in fireworks{
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    func explode(firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode"){
            emitter.position = firework.position
            addChild(emitter)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks(){
        var numExploded = 0
        
        for (index, fireworkContainer) in fireworks.enumerated().reversed(){
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue}
            
            if firework.name == "selected" {
                //destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded{
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
}
