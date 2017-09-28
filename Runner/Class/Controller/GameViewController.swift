//
//  GameViewController.swift
//  Runner
//
//  Created by mac on 2017/9/6.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let scene = GameBeginScene(size: self.view.frame.size)
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.share), name: NSNotification.Name(rawValue: "share"), object: nil)
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension GameViewController: GameBaseSceneDelegate {

    func share() {
        
        let bestScore = UserDefaults.standard.integer(forKey: "kBestScore")
        let shareString = "熊猫快跑-我获得了\(bestScore)分,还有谁!!"
        let shareImage = UIImage(named: "icon83")!
        let shareUrl = URL(string: "https://itunes.apple.com/cn/app/%E7%86%8A%E7%8C%AB%E5%BF%AB%E8%B7%91-%E8%BF%90%E6%B0%94%E4%B8%8E%E5%AE%9E%E5%8A%9B%E5%B9%B6%E5%AD%98/id1286626537?mt=8")!
        let activityItems = [shareString,shareImage,shareUrl] as [Any]
        
        let activityVc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVc.excludedActivityTypes = [UIActivityType.print,UIActivityType.copyToPasteboard, .assignToContact, .saveToCameraRoll]
        
        self.present(activityVc, animated: true) { 
            activityVc.completionWithItemsHandler = {
                (type : UIActivityType?, completed : Bool, activityItems: [Any]?, error: Error?) -> () in
                if completed {
                   // print("分享成功")
                }else {
                   // print("分享取消")
                }
                
               // print(error ?? "没有错误")
            }
        }
    }
}
