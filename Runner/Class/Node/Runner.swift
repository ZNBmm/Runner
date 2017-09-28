
//
//  Runner.swift
//  Runner
//
//  Created by mac on 2017/9/6.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit
import AVFoundation
enum Status : Int {
    case run=1,jump,jump2,roll;
}

class Runner: SKSpriteNode {
    
    // 跑的纹理集
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    
    // 跑的纹理数组
    var runFrames = [SKTexture]()
    
    // 跳的纹理集
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    
    // 存属跳的纹理数组
    var jumpFrames = [SKTexture]()
    
    //打滚的文理集合
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    
    //存储打滚文理的数组
    var rollFrames = [SKTexture]();
    
    var status = Status.run
    
    // 起跳 y 的坐标
    var jumpStart:CGFloat = 0.0
    // 落地 y 的坐标
    var jumpEnd:CGFloat = 0.0
    
    //起跳特效纹理集
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    //存储起跳特效纹理的数组
    var jumpEffectFrames = [SKTexture]()
    //起跳特效
    var jumpEffect = SKSpriteNode()
    
    var jumpActionSound : SKAction = SKAction.playSoundFileNamed("jumpSound.wav", waitForCompletion: false)
   
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        let texture = runAtlas.textureNamed("panda_run_01")
        let size = texture.size()
        super.init(texture: texture, color: color, size: size)
        
        
        //填充跑的纹理数组
        for textureName in runAtlas.textureNames {
            
            let runTexture = runAtlas.textureNamed(textureName)
            runFrames.append(runTexture)
        }
        
        //填充跳的纹理数组
        for jumpTexture in jumpAtlas.textureNames {
            let jumpTexture = jumpAtlas.textureNamed(jumpTexture)
            jumpFrames.append(jumpTexture)
        }
        
        //填充打滚的纹理数组
        for rollTextureName in rollAtlas.textureNames {
            let rollTexture = rollAtlas.textureNamed(rollTextureName)
            rollFrames.append(rollTexture)
        }
        
        //起跳特效
        for jumpEffectTextureName in jumpEffectAtlas.textureNames {
            let jumpTexture = jumpEffectAtlas.textureNamed(jumpEffectTextureName)
            jumpEffectFrames.append(jumpTexture)
        }
        
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPoint(x: -80, y: -30)
        jumpEffect.isHidden = true
        
        self.addChild(jumpEffect)
        
        run()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 30
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        //弹性
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = BitMaskType.runner
        self.physicsBody?.contactTestBitMask = BitMaskType.floor | BitMaskType.monster | BitMaskType.bianbian
        self.physicsBody?.collisionBitMask = BitMaskType.floor
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func run() {
        // 移除所有动作
        self.removeAllActions()
        // 设置当前状态为跑
        self.status = .run
        //通过SKAction.animateWithTextures将跑的文理数组设置为0.05秒切换一次的动画
        // SKAction.repeatActionForever将让动画永远执行
        // self.runAction执行动作形成动画
        self.run(
            SKAction.repeatForever(
                SKAction.animate(with: runFrames, timePerFrame: 0.05)
            )
        )
    }
    
    // 跳
    func jump() {
        self.removeAllActions()
        if status != Status.jump2 {
            self.run(
                SKAction.animate(with: jumpFrames, timePerFrame: 0.05)
            )
            // 施加一个向上的力.让小人跳起来
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 450)
            if status == Status.jump {
                status = Status.jump2
                self.jumpStart = self.position.y
            }else {
                showJumpEffect()
                status = Status.jump
                self.run(jumpActionSound)

            }
            
        }
    }
    
    // 打滚
    func roll() {
    
        self.removeAllActions()
        status = .roll
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05)) { 
            self.run()
        }
    }
    
    // 起跳特效
    func showJumpEffect() {
        // 先将特效取消隐藏
        jumpEffect.isHidden = false
        // 利用Action 播放特效
        let ectAct = SKAction.animate(with: jumpEffectFrames, timePerFrame: 0.05)
        
        // 执行闭包,再次隐藏特效
        let removeAct = SKAction.run { 
            self.jumpEffect.isHidden = true
        }
        
        // 组成序列Action进行执行
        jumpEffect.run(SKAction.sequence([ectAct,removeAct]))
        
    }
    
    
}
