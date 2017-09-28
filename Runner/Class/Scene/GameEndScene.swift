//
//  GameEndScene.swift
//  Runner
//
//  Created by mac on 2017/9/16.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

class GameEndScene: GameBaseScene {
    
    lazy var floor : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "floor", inContainer: kScreenWidth) as! ScrollingNode
    lazy var back : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "back", inContainer: kScreenWidth) as! ScrollingNode
    
    var loseReasonStr : String = ""
    var score : Int = 0
    lazy var tapActionSound = SKAction.playSoundFileNamed("tap.wav", waitForCompletion: false)
    
    lazy var timoLaughtSound = SKAction.playSoundFileNamed("timoSound.m4a", waitForCompletion: false)
    lazy var shareNode : SKSpriteNode = {
        
        let node = SKSpriteNode(imageNamed: "share")
        node.name = "share"
        node.zPosition = 40
        node.position = CGPoint(x: kScreenWidth-40, y: kScreenHeight-40)
        return node
    }()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.backgroundColor = SKColor(red: 112/255, green: 197/255, blue: 205/255, alpha: 1)
        
        setUpResultLabel()
        
        setUpTryAgain()
        
        setUpScoreLabel()
        
        setUpGameCancel()
        
        setUpGameOver()
        
        setUpShare()
        
        configUI()
        
        self.run(timoLaughtSound)
        
        shareNode.alpha = 1
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first?.location(in: self)
        
        let node = self.atPoint(point!)
        
        if node.name == "tryagainLabel" {
            self.changeToGame()
        }else if node.name == "cancel" {
            self.gameCancel()
        }else if node.name == "share" {
            print("分享")
            self.run(tapActionSound)
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "share"), object: nil, userInfo: nil)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        floor.update(currentTime: currentTime)
        back.update(currentTime: currentTime)
    }
}

// MARK: - 配置场景
extension GameEndScene {
    
    func configUI() {
        self.addChild(floor)
        floor.anchorPoint = .zero
        floor.physicsBody = SKPhysicsBody(edgeLoopFrom: floor.frame)
        floor.physicsBody?.affectedByGravity = false
        floor.position = CGPoint(x: 0, y: -20)
        floor.physicsBody?.categoryBitMask = BitMaskType.floor
        floor.physicsBody?.contactTestBitMask = BitMaskType.feibiao
        floor.physicsBody?.collisionBitMask = BitMaskType.runner
        floor.scrollingSpeed = 3
        
        self.addChild(back)
        back.anchorPoint = .zero
        back.position = CGPoint(x: 0, y: floor.position.y+floor.size.height)
        back.scrollingSpeed = 1
        
    }
}

extension GameEndScene {

    func changeToGame()  {
        let gameBegin = GameSceneA(size: self.size)
        self.run(tapActionSound)
        let reveal = SKTransition.reveal(with: .up, duration: 1.0)
        
        self.scene?.view?.presentScene(gameBegin, transition: reveal)
        
    }
    
    func gameCancel(){
        let gameBegin = GameBeginScene(size: self.size)
        self.run(tapActionSound)
        let reveal = SKTransition.reveal(with: .up, duration: 1.0)
        
        self.scene?.view?.presentScene(gameBegin, transition: reveal)
    }
}

extension GameEndScene {

    func setUpResultLabel() {
        
        let resultLabel = SKLabelNode(fontNamed: "Avenir-Black")
        resultLabel.text = "Tips:\(loseReasonStr)"
        resultLabel.fontSize = 20
        resultLabel.fontColor = SKColor.white
        resultLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        resultLabel.zPosition = 40
        self.addChild(resultLabel)
        
        
        let moveDown = SKAction.moveTo(y: self.size.height*0.4-10, duration: 0.5)
        let moveUp = SKAction.moveTo(y: self.size.height*0.4+10, duration: 0.5)
        let queue = SKAction.repeatForever(SKAction.sequence([moveDown,moveUp]))
        
        resultLabel.run(queue)
    }
    
    func setUpTryAgain()   {
        let tryAgainNode = SKSpriteNode(imageNamed: "tryAgain")
        self.addChild(tryAgainNode)
        tryAgainNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        tryAgainNode.position = CGPoint(x: self.size.width*0.5+10, y: self.size.height*0.2)
        tryAgainNode.zPosition = 40
        tryAgainNode.name = "tryagainLabel"
        
    }
    func setUpGameCancel()   {
        let node = SKSpriteNode(imageNamed: "cancel")
        self.addChild(node)
        node.anchorPoint = CGPoint(x: 1, y: 0.5)
        node.position = CGPoint(x: self.size.width*0.5-10, y: self.size.height*0.2)
        node.zPosition = 40
        node.name = "cancel"
    }
    
    func setUpShare() {
        self.addChild(shareNode)
    }
    
    func setUpScoreLabel() {
        
        let bestScore = UserDefaults.standard.integer(forKey: "kBestScore")
        
        let resultLabel = SKLabelNode(fontNamed: "Avenir-Black")
        
        resultLabel.text = "Cur Score:\(score)    Best Score:\(bestScore)"
        resultLabel.fontSize = 20
        resultLabel.fontColor = SKColor.orange
        resultLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.87)
        resultLabel.zPosition = 40
        self.addChild(resultLabel)
    }
    
    func setUpGameOver() {
        
        let resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        resultLabel.text = "Game Over"
        resultLabel.fontSize = 70
        resultLabel.fontColor = SKColor.white
        resultLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.6)
        resultLabel.alpha = 0.6
        resultLabel.zPosition = 40
        self.addChild(resultLabel)
    }
}
