//
//  DratNode.swift
//  Runner
//
//  Created by mac on 2017/9/16.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

class DratNode: SKSpriteNode {

    class func dratNode(name:String)->DratNode {
    
        let rotate = SKAction.rotate(byAngle: (CGFloat)(M_PI*2), duration: 1)
        
        let node = DratNode(imageNamed: name)
        node.run(SKAction.repeatForever(rotate))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width*0.5)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = BitMaskType.feibiao
        node.physicsBody?.contactTestBitMask = BitMaskType.floor | BitMaskType.monster
        
        return node
        
    }
}
