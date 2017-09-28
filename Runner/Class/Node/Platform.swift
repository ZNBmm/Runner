//
//  Platform.swift
//  Runner
//
//  Created by mac on 2017/9/6.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

class Platform: SKNode {
    //宽
    var width :CGFloat = 0.0
    //高
    var height :CGFloat = 10.0
    
    //是否下沉
    var isDown = false
    
    func onCreate(arrSprite:[SKSpriteNode])  {
        // 通过接受SKSpriteNode数组来创建平台
        
        for platform in arrSprite {
            // 以当前宽度为平台零件的x坐标
            platform.position.x = self.width
            // 加载
            self.addChild(platform)
            // 更新宽度
            self.width += platform.size.width
            
            self.height = platform.size.height
        }
        
        // 当平台的零件只有三样,左,中,又时,设为会下落的平台
        if arrSprite.count <= 3 {
            isDown = true
        }
        self.zPosition = 20
        
        // 设置物理体为当前宽高组成的矩形
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: self.height), center: CGPoint(x: self.width/2, y: -self.height*0.5))
        
        // 设置物理标识
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        // 不响应物理效果
        self.physicsBody?.isDynamic = false
        // 不旋转
        self.physicsBody?.allowsRotation = false
        // 弹性0
        self.physicsBody?.restitution = 0
        
    }
}
