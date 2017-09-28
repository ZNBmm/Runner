//
//  BianBian.swift
//  Runner
//
//  Created by mac on 2017/9/17.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

class BianBian: SKSpriteNode {
    let monsterAtlas = SKTextureAtlas(named: "bianbian.atlas")
    var monsterFrames = [SKTexture]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let texture = monsterAtlas.textureNamed("bianbian00")
        let size = texture.size()
        super.init(texture: texture, color: color, size: size)
        
        for textureName in monsterAtlas.textureNames {
            let texture = monsterAtlas.textureNamed(textureName)
            monsterFrames.append(texture)
        }
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.zPosition = 40
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        //弹性
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = BitMaskType.bianbian
        self.physicsBody?.contactTestBitMask = BitMaskType.runner | BitMaskType.feibiao
        self.run(
            SKAction.repeatForever(
                SKAction.animate(with: monsterFrames, timePerFrame: 0.1)
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
