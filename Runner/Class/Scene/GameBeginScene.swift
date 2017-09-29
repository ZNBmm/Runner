
//
//  GameBeginScene.swift
//  Runner
//
//  Created by mac on 2017/9/16.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameBeginScene: GameBaseScene {
    lazy var runner : Runner = Runner()
    lazy var floor : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "floor", inContainer: kScreenWidth) as! ScrollingNode
    lazy var back : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "back", inContainer: kScreenWidth) as! ScrollingNode
    lazy var tapActionSound = SKAction.playSoundFileNamed("tap.wav", waitForCompletion: false)
    lazy var  tipLabel = UILabel(frame: CGRect(x: kScreenWidth*0.5-200, y: 50, width: 400, height:150))
    var gameLevelNode : SKLabelNode = SKLabelNode(text: "DIFFICULTY : Easy")
    /// bgmPlayer
    var bgmPlayer : AVAudioPlayer?
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let path = Bundle.main.path(forResource: "runnerBGMusic", ofType: "caf")
        
        bgmPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        
        bgmPlayer?.numberOfLoops = -1
        bgmPlayer?.play()
        self.backgroundColor = SKColor(red: 112/255, green: 197/255, blue: 205/255, alpha: 1)
        configUI()
        
        setUpBegin()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        floor.update(currentTime: currentTime)
        back.update(currentTime: currentTime)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        
        let node = self.atPoint(point!)
        
        if node.name == "begin" {
            self.changeToGame()
            self.run(tapActionSound)
        }else if node.name == "gameLevel" {
            
            changeToGameLevel()
            self.run(tapActionSound)
        }
    }
   
}
// MARK: - 配置场景
extension GameBeginScene {
    
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
        
        runner.position = CGPoint(x: self.size.width*0.5, y: 300)
        runner.physicsBody?.affectedByGravity = true
        self.addChild(runner)
        
        tipLabel.alpha = 1
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = UIColor(white: 1, alpha: 0.7)
        tipLabel.textColor = UIColor.orange
        tipLabel.font = UIFont.systemFont(ofSize: 20)
        tipLabel.text = "操作提示:\n1.点击屏幕空白处发射子弹击败黑色精灵\n2.在黑色精灵越过熊猫之前干掉黑色精灵\n3.不要射到地上💩他会让你直接结束游戏\n游戏失败,你会收到提莫魔王的嘲讽"
        tipLabel.layer.cornerRadius = 0.2
        tipLabel.layer.masksToBounds = true
        self.view?.addSubview(tipLabel)
        
        
        gameLevelNode.position = CGPoint(x: self.size.width*0.5, y: floor.position.y+floor.size.height+40)
        gameLevelNode.fontName = "Chalkduster"
        gameLevelNode.fontSize = 20
        gameLevelNode.name = "gameLevel"
        gameLevelNode.zPosition = 40
        gameLevelNode.fontColor = SKColor.orange
        
        self.addChild(gameLevelNode)
    }
    
    func setUpBegin()   {
        let node = SKSpriteNode(imageNamed: "begin")
        self.addChild(node)
        node.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        node.zPosition = 40
        node.name = "begin"
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        let rotate = SKAction.rotate(toAngle: -0.05, duration: 0.5)
        
        let rotateDown = SKAction.rotate(toAngle: 0.05, duration: 0.5)
        
        let queue = SKAction.repeatForever(SKAction.sequence([rotate,rotateDown]))
        
        node.run(queue)
    }
    
    
    func changeToGame()  {
        
        bgmPlayer?.stop()
        bgmPlayer = nil
        let gameBegin = GameSceneA(size: self.size)
        gameBegin.gameLevel = gameLevelNode.text
        tipLabel.alpha = 0
        let reveal = SKTransition.reveal(with: .up, duration: 1.0)
        
        self.scene?.view?.presentScene(gameBegin, transition: reveal)
    }
    
    func changeToGameLevel()  {
        
        bgmPlayer?.stop()
        bgmPlayer = nil
        let gameBegin = GameLevelChooseScene(size: self.size)
        
        tipLabel.alpha = 0
        let reveal = SKTransition.reveal(with: .right, duration: 1.0)
        
        self.scene?.view?.presentScene(gameBegin, transition: reveal)
    }
}
