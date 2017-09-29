//
//  GameLevelChooseScene.swift
//  Runner
//
//  Created by mac on 2017/9/29.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import SpriteKit

protocol GameLevelChooseSceneDelegate : class {
    func gameLevelChoose(text:String)
}

class GameLevelChooseScene: GameBaseScene {

    weak var levelDelegate:GameLevelChooseSceneDelegate?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        configUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let node = self.atPoint(point!)
        
        if node.name == "Easy" {
            levelDelegate?.gameLevelChoose(text: "Easy")
            changeToBegin(level: "Easy")
            
        }else if node.name == "Normal" {
            levelDelegate?.gameLevelChoose(text: "Normal")
            changeToBegin(level: "Normal")
        }else if node.name == "Crazy" {
            levelDelegate?.gameLevelChoose(text: "Crazy")
            changeToBegin(level: "Crazy")
        }
        
        
    }
}

extension GameLevelChooseScene {
    
    func configUI() {
        makeNode(text: "Easy", position: CGPoint(x: kScreenWidth*0.5, y: kScreenHeight*0.7))
        makeNode(text: "Normal", position: CGPoint(x: kScreenWidth*0.5, y: kScreenHeight*0.5))
        makeNode(text: "Crazy", position: CGPoint(x: kScreenWidth*0.5, y: kScreenHeight*0.3))
    }
    
    func makeNode(text:String,position:CGPoint) {
        let node = SKLabelNode(text: text)
        node.position = position
        self.addChild(node)
        node.fontName = "Chalkduster"
        node.name = text
    }
    
    func changeToBegin(level:String)  {
    
        let gameBegin = GameBeginScene(size: self.size)
        gameBegin.gameLevelNode.text = "DIFFICULTY : \(level)"
        let reveal = SKTransition.reveal(with: .left, duration: 1.0)
        
        self.scene?.view?.presentScene(gameBegin, transition: reveal)
    }
}
