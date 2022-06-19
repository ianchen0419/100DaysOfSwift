//
//  GameScene.swift
//  ShootGallery
//
//  Created by 陳怡安 on 2022/5/1.
//

import SpriteKit

class GameScene: SKScene {
    let hardItems = ["shaved ice", "sushi", "birthday"]
    let mediumItems = ["icecream", "dango", "candy", "doughnut"]
    let easyItems = ["football", "8ball", "baseball", "soccer"]
    
    var hardTimer: Timer?
    var mediumTimer: Timer?
    var easyTimer: Timer?
    
    var isGameOver = false
    
    var hitCounts = 0 {
        didSet {
            hitLabel.text = "Hit Count: \(hitCounts)/5"
        }
    }
    var hitLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 382)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let shelfTop = SKSpriteNode(imageNamed: "shelf")
        shelfTop.position = CGPoint(x: 512, y: 586)
        addChild(shelfTop)
        
        let shelfMiddle = SKSpriteNode(imageNamed: "shelf")
        shelfMiddle.position = CGPoint(x: 512, y: 374)
        addChild(shelfMiddle)
        
        let shelfBottom = SKSpriteNode(imageNamed: "shelf")
        shelfBottom.position = CGPoint(x: 512, y: 162)
        addChild(shelfBottom)
        
        hitLabel = SKLabelNode(fontNamed: "Chalkduster")
        hitLabel.text = "Hit Count: 0/5"
        hitLabel.position = CGPoint(x: 1016, y: 8)
        hitLabel.horizontalAlignmentMode = .right
        hitLabel.fontSize = 36
        addChild(hitLabel)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 36
        addChild(scoreLabel)
        
        physicsWorld.gravity = .zero
        
        hardTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createHardItems), userInfo: nil, repeats: true)
        mediumTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createMediumItems), userInfo: nil, repeats: true)
        easyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createEasyItems), userInfo: nil, repeats: true)
        
    }
    
    @objc func createHardItems() {
        guard let item = hardItems.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: item)
        sprite.zPosition = 2
        sprite.position = CGPoint(x: 1200, y: 660)
        sprite.name = "hard"
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -1000, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        addChild(sprite)
    }
    
    @objc func createMediumItems() {
        guard let item = mediumItems.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: item)
        sprite.zPosition = 2
        sprite.position = CGPoint(x: 1200, y: 448)
        sprite.name = "medium"
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        addChild(sprite)
    }
    
    @objc func createEasyItems() {
        guard let item = easyItems.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: item)
        sprite.zPosition = 2
        sprite.position = CGPoint(x: 1200, y: 236)
        sprite.name = "easy"
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -250, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        addChild(sprite)
    }
    
    func hitItem(node: SKNode, scorePlus: Int) {
        score += scorePlus
        
        node.removeFromParent()
        if let explosion = SKEmitterNode(fileNamed: "explosion") {
            explosion.position = node.position
            addChild(explosion)
        }
        run(SKAction.playSoundFileNamed("hitGood.mp3", waitForCompletion: false))
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver == false {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            guard let node = tappedNodes.first else { return }
            
            if hitCounts < 5 {
                hitCounts += 1
                if hitCounts == 5 {
                    isGameOver = true
                }
            }
            
            if node.name == "hard" {
                hitItem(node: node, scorePlus: 10)
            } else if node.name == "medium" {
                hitItem(node: node, scorePlus: 5)
            } else if node.name == "easy" {
                hitItem(node: node, scorePlus: 1)
            } else {
                run(SKAction.playSoundFileNamed("hitBad.mp3", waitForCompletion: false))
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
    }
}
