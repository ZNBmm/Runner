//
//  AppDelegate.swift
//  Runner
//
//  Created by mac on 2017/9/6.
//  Copyright © 2017年 CoderZNBmm. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var blockRotation: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        
        
        MobClick.setAppVersion(version as! String!)
        UMAnalyticsConfig.sharedInstance().appKey = "57c2dc07f29d987f28005d0c"
        UMAnalyticsConfig.sharedInstance().channelId = "AppStore"
        
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        var count = UserDefaults.standard.integer(forKey: "kLaunchCount")
        count += 1
        UserDefaults.standard.set(count, forKey: "kLaunchCount")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
  
        var count = UserDefaults.standard.integer(forKey: "kLaunchCount")
        count += 1
        UserDefaults.standard.set(count, forKey: "kLaunchCount")
        
        print(count)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

