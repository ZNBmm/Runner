//
//  GameSceneA.swift
//  Runner
//
//  Created by mac on 2017/9/16.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit
import AVFoundation

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

class GameSceneA: GameBaseScene {
    
    lazy var platformFactory = PlatformFactory()
    lazy var runner : Runner = Runner()
    lazy var floor : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "floor", inContainer: kScreenWidth) as! ScrollingNode
    lazy var back : ScrollingNode = ScrollingNode.scrollingNodeWithImageNamed(name: "back", inContainer: kScreenWidth) as! ScrollingNode
    
    // 子弹数组
    lazy var projects : [SKSpriteNode] = []
    // 小怪数组
    lazy var monsters : [Monster] = []
    
    lazy var jump : SKSpriteNode = SKSpriteNode(imageNamed: "jump")
    
    lazy var scoreLabel = SKLabelNode(fontNamed: "Avenir-Black")
    
    var score : Int = 0
    
    var feibiaoActionSound : SKAction = SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false)
    
    
    
    var isLose:Bool = false
    /// bgmPlayer
    var bgmPlayer : AVAudioPlayer?
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let path = Bundle.main.path(forResource: "runnerBGMusic", ofType: "caf")
        
        bgmPlayer = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        bgmPlayer?.delegate = self
        bgmPlayer?.numberOfLoops = -1
        bgmPlayer?.play()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.backgroundColor = SKColor(red: 112/255, green: 197/255, blue: 205/255, alpha: 1)
        self.physicsWorld.contactDelegate = self
        // 配置UI
        configUI()
       
        let monsterTime = arc4random()%1+1
        let bianbianTime = arc4random()%3+3
        configAction(monsterWaitTime: TimeInterval(monsterTime), bianbianWaitTime: TimeInterval(bianbianTime))
       
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first?.location(in: self)
        let node = self.atPoint(point!) as? SKSpriteNode
       
        if node?.name == "jump" {
            
            if isLose {
                print("游戏结束")
//                self.gameover()
            }else {
                runner.jump()
                
                           }
        }else {
        
            if isLose {
                print("游戏结束")
//                self.gameover()
                
            }else {
                shotDrat(targetP: point!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        

    }
    
    override func update(_ currentTime: TimeInterval) {
        floor.update(currentTime: currentTime)
        back.update(currentTime: currentTime)
        
        //如果小人出现了位置偏差，就逐渐恢复
        if runner.position.x < 100 {
            let x = runner.position.x + 1
            runner.position = CGPoint(x: x, y: runner.position.y)
        }
        
        // 更新分数
        scoreLabel.text = "\(score)"
        
    
    }
}

 // MARK: - 配置场景
extension GameSceneA {
    
    func configUI() {
        
        runner.position = CGPoint(x: 100, y: 200)
        
        self.addChild(runner)
        
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
        
        self.addChild(jump)
        jump.anchorPoint = .zero
        jump.position = CGPoint(x: 10, y: 10)
        jump.name = "jump"
        jump.zPosition = 40
        
        self.addChild(scoreLabel)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 31
        scoreLabel.alpha = 0.6
        scoreLabel.fontSize = 180
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        scoreLabel.isUserInteractionEnabled = false
        
        
    }
}

extension GameSceneA {

    func shotDrat(targetP:CGPoint) {
        // 飞镖的开始位置
        let orginalP = runner.position
        
        let drat = DratNode.dratNode(name: "feibiao")
        drat.position = CGPoint(x:orginalP.x+runner.size.width*0.5+1, y:orginalP.y+20)
        drat.zPosition = 40
        
        let offset = CGPoint(x: targetP.x - drat.position.x, y: targetP.y - drat.position.y)
        if offset.x < 0 {
            return
        }
        self.addChild(drat)
        
        let ratio = offset.y / offset.x
        
        let realX = self.frame.width - runner.position.x+runner.size.width + drat.size.width*0.5
        let realY = realX * ratio + drat.position.y
        
        let realDest = CGPoint(x: realX, y: realY)
        
        let offRealX = realX - drat.position.x
        let offRealY = realY - drat.position.y
        
        let length = sqrt((offRealX*offRealX)+(offRealY*offRealY))
        
        let velocity = (self.size.width - runner.size.width - runner.position.x)/1
        
        let realMoveDuration = length/velocity
        
        let moveAction = SKAction.move(to: realDest, duration: TimeInterval(realMoveDuration))
        
        
        projects.append(drat)
        
        let actionQueue = SKAction.group([moveAction,feibiaoActionSound])
        
        drat.run(actionQueue) {
            drat.removeFromParent()
            
//            let index = self.projects.index(of: drat)!
//
//            self.projects.remove(at: index)
        }
        
    }
}

extension GameSceneA:SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == BitMaskType.feibiao && contact.bodyB.categoryBitMask == BitMaskType.floor{
            let feibiao = contact.bodyA.node
            feibiao?.removeFromParent()
            
            
        }else if contact.bodyA.categoryBitMask == BitMaskType.floor && contact.bodyB.categoryBitMask == BitMaskType.feibiao {
            let feibiao = contact.bodyB.node
            feibiao?.removeFromParent()
            
        }else if contact.bodyA.categoryBitMask == BitMaskType.floor && contact.bodyB.categoryBitMask == BitMaskType.runner {
            let runner = contact.bodyB.node as! Runner
            runner.run()
            
        }else if contact.bodyA.categoryBitMask == BitMaskType.runner && contact.bodyB.categoryBitMask == BitMaskType.floor {
            let runner = contact.bodyA.node as! Runner
            runner.run()
        
        }else if contact.bodyA.categoryBitMask == BitMaskType.feibiao && contact.bodyB.categoryBitMask == BitMaskType.monster {
            score += 1
            
            let feibiao = contact.bodyA.node
            feibiao?.removeFromParent()
            let monster = contact.bodyB.node
            monster?.removeFromParent()
            
        }else if contact.bodyA.categoryBitMask == BitMaskType.monster && contact.bodyB.categoryBitMask == BitMaskType.feibiao {
            
            score += 1
            let feibiao = contact.bodyB.node
            feibiao?.removeFromParent()
            let monster = contact.bodyA.node
            monster?.removeFromParent()
            
        }else if contact.bodyA.categoryBitMask == BitMaskType.bianbian && contact.bodyB.categoryBitMask == BitMaskType.feibiao {
            let feibiao = contact.bodyB.node
            feibiao?.removeFromParent()
            print("你射到了便便,GAMEOVER")
            self.gameover(reason: "你射到了便便,便便是不能射到的")
            self.isLose = true
        }else if contact.bodyA.categoryBitMask == BitMaskType.feibiao && contact.bodyB.categoryBitMask == BitMaskType.bianbian {
            let feibiao = contact.bodyA.node
            feibiao?.removeFromParent()
            self.isLose = true
            self.gameover(reason: "你射到了便便,便便是不能射到的")
            print("你射到了便便,GAMEOVER")
        }else if contact.bodyA.categoryBitMask == BitMaskType.runner && contact.bodyB.categoryBitMask == BitMaskType.bianbian {
            
            self.isLose = true
            self.gameover(reason: "你踩到了便便,这个便便要比你看到的要大哦")
            print("你踩到了便便,GAMEOVER")
        }else if contact.bodyA.categoryBitMask == BitMaskType.bianbian && contact.bodyB.categoryBitMask == BitMaskType.runner {
            
            self.isLose = true
            self.gameover(reason: "你踩到了便便,这个便便要比你看到的要大哦")
            print("你踩到了便便,GAMEOVER")
        }
    }
    
}


 // MARK: - 添加小煤球
extension GameSceneA {
    func addMonster()  {
        let monster = Monster()
        
        let minY = floor.frame.size.height + floor.position.y + monster.size.height
        
        let maxY = self.size.height-monster.size.height*0.5
        
        let targetX = runner.position.x + runner.size.width*0.5
        
        let rangeY = maxY - minY
        
        let actualY = arc4random()%(UInt32)(rangeY) + (UInt32)(minY)
        
        monster.position = CGPoint(x: self.size.width+monster.size.width*0.5, y: (CGFloat)(actualY))
        
        self.addChild(monster)
        
        let minDuration = 2.0
        let maxDuration = 4.0
        let rangeDuration = maxDuration - minDuration
        let actualDuration = arc4random()%(UInt32)(rangeDuration) + (UInt32)(minDuration)
        
        let actionMove = SKAction.move(to: CGPoint(x:targetX,y:(CGFloat)(actualY)), duration: (TimeInterval)(actualDuration))
        
        let actionMoveDone = SKAction.run { 
            monster.removeFromParent()
            
            let index = self.monsters.index(of: monster)
            self.monsters.remove(at: index!)
            print("游戏结束")
            self.gameover(reason: "在小怪在到达熊猫前干掉他")
            self.isLose = true
            
        }
        
        monster.run(SKAction.sequence([actionMove,actionMoveDone]))
        
        self.monsters.append(monster)
    }
}
 // MARK: - 添加便便
extension GameSceneA {

    func addBianBian() {
        let bianbian = BianBian()
        
        let minY = floor.frame.size.height + floor.position.y + bianbian.size.height*0.5
    
        let targetX = -bianbian.size.width*0.5
        
        bianbian.position = CGPoint(x: self.size.width+bianbian.size.width*0.5, y: (CGFloat)(minY))
        
        self.addChild(bianbian)
        
        let minDuration = 4.0
        let maxDuration = 6.0
        let rangeDuration = maxDuration - minDuration
        let actualDuration = arc4random()%(UInt32)(rangeDuration) + (UInt32)(minDuration)
        
        let actionMove = SKAction.move(to: CGPoint(x:targetX,y:(CGFloat)(minY)), duration: (TimeInterval)(actualDuration))
        
        let actionMoveDone = SKAction.run {
            bianbian.removeFromParent()
    
        }
        bianbian.run(SKAction.sequence([actionMove,actionMoveDone]))
        
    }
}

extension GameSceneA {
    
    func gameover(reason:String) {
        
        bgmPlayer?.stop()
        bgmPlayer = nil
        
        let bestScore = UserDefaults.standard.integer(forKey: "kBestScore")
        
        if score > bestScore {
            UserDefaults.standard.set(score, forKey: "kBestScore")
        }
        
        let gameEndscene = GameEndScene(size: self.size)
        gameEndscene.loseReasonStr = reason
        gameEndscene.score = score
        let reveal = SKTransition.reveal(with: .up, duration: 1.0)
        self.scene?.view?.presentScene(gameEndscene, transition: reveal)
    }
   
}

extension GameSceneA {

    func configAction(monsterWaitTime:TimeInterval,bianbianWaitTime:TimeInterval)  {
        
        
        
        print("+++++++++++\(score)+++++++++")
        
        let actionAddMonster = SKAction.run {
            self.addMonster()
        }
        
        let actionWait = SKAction.wait(forDuration: monsterWaitTime)
        
        self.run(SKAction.repeatForever(SKAction.sequence([actionAddMonster,actionWait])))
        
        let actionWait1 = SKAction.wait(forDuration: bianbianWaitTime)
        
        let actionAddBianbian = SKAction.run {
            self.addBianBian()
        }
        self.run(SKAction.repeatForever(SKAction.sequence([actionAddBianbian,actionWait1])))
    }
}

extension GameSceneA:AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        player.play()
        
        print("audioPlayerDidFinishPlaying")
    }
}

