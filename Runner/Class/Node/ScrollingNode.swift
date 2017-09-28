//
//  ScrollingNode.swift
//  Runner
//
//  Created by mac on 2017/9/16.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

class ScrollingNode: SKSpriteNode {
    var scrollingSpeed : CGFloat = 0
    
    
    class func scrollingNodeWithImageNamed(name:String, inContainer width:CGFloat) -> SKSpriteNode? {
        let image = UIImage(named: name)
        guard (image != nil) else {
            return nil
        }
        let realNode = ScrollingNode(color: SKColor.clear, size: CGSize(width: width, height: (image?.size.height)!))
        realNode.scrollingSpeed = 1
        
        var total : CGFloat = 0
        while total < (width + image!.size.width) {
            let child = SKSpriteNode(imageNamed: name)
            child.anchorPoint = CGPoint.zero
            child.position = CGPoint(x: total, y: 0)
            realNode.addChild(child)
            total += child.size.width
        }
        
        return realNode
    }
    
    
    func update(currentTime:TimeInterval) {
        for node in self.children {
            let child = node as! SKSpriteNode
            
            child.position = CGPoint(x: child.position.x-self.scrollingSpeed, y: child.position.y)
            if child.position.x <= -child.size.width {
                let delta : CGFloat = child.position.x + child.size.width
                let px : CGFloat = child.size.width*(CGFloat)(self.children.count-1)+delta
                child.position = CGPoint(x: px, y: child.position.y)
            }
            
        }
    }
    
}
