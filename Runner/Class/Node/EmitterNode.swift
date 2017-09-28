//
//  EmitterNode.swift
//  Runner
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import UIKit
import QuartzCore

protocol zhuye {
    
}

extension zhuye where Self : UIView {
    func createZhuYe(name:String) {
        // 1.创建粒子发射器
        let emitter = self.layer as! CAEmitterLayer
        // 1.1 设置粒子发射器的位置
        emitter.emitterPosition = CGPoint(x: kScreenWidth, y: 0)
        // 1.2 设置粒子发射器的范围
        emitter.emitterSize = bounds.size
        // 1.3 设置粒子的形状
        emitter.emitterShape = kCAEmitterLayerCircle
        
        // 2. 创建粒子
        let emitterCell = CAEmitterCell()
        
        // 2.1载入粒子
        emitterCell.contents = UIImage(named: name)!.cgImage
        // 2.2设置粒子的出生速率
        emitterCell.birthRate = 10
        // 2.3设置每个粒子的生命周期
        emitterCell.lifetime = 3.5
        // 2.4粒子的颜色
        emitterCell.color = UIColor.white.cgColor
        // 2.5RGBA设置
        emitterCell.redRange = 0.0 // RGBA设置
        emitterCell.blueRange = 0.1
        emitterCell.greenRange = 0.0
        emitterCell.alphaRange = 0.5
        emitterCell.velocity = 9.8 // 重力加速度也就是物理里面G
        emitterCell.velocityRange = 550 // 加速范围
        emitterCell.emissionRange = CGFloat(M_PI_2) // 下落是旋转的角度
        emitterCell.emissionLongitude = CGFloat(-M_PI) //
        emitterCell.yAcceleration = 70
        emitterCell.xAcceleration = 0
        emitterCell.scale = 0.33 // 发射比例
        emitterCell.scaleRange = 1.0
        emitterCell.scaleSpeed = -0.25
        emitterCell.alphaRange = 0.5 // 透明度调整
        emitterCell.alphaSpeed = -0.15
        emitter.emitterCells = [emitterCell] // 载入
    }
    
}
