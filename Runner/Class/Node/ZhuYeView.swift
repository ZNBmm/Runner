//
//  ZhuYeView.swift
//  Runner
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import UIKit

class ZhuYeView: UIView, zhuye {

    var name : String = "zhuye"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createZhuYe(name: name)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 这个方法一定要重写 不然会在这个位置___let emitter = self.layer as! CAEmitterLayer____报类型不匹配的错误
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }

}
