//
//  GameBaseScene.swift
//  Runner
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

protocol GameBaseSceneDelegate : class {
    func share()
}

class GameBaseScene: SKScene {

    
    weak var shareDelegate : GameBaseSceneDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        
    }
    
}
