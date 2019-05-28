//
//  AppDelegate.swift
//  ITMO X
//
//  Created by Alexey Voronov on 11/05/2019.
//  Copyright © 2019 Alexey Voronov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.checkBlackTheme()
        window = UIWindow()
        if UserDefaults.standard.string(forKey: "login") == nil {
            let loginScreen = LoginViewController()
            window?.rootViewController = loginScreen
        } else {
            window?.rootViewController = Helper.app.getMainScreenController()
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    // Очень костыльное решение, но пока так. По идее нужно вынести в конфиг
    static func checkBlackTheme() {
        if UserDefaults.standard.bool(forKey: "enabled_black") {
            Config.Colors.black = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Config.Colors.blue = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            Config.Colors.gray = #colorLiteral(red: 0.09927443316, green: 0.09962337722, blue: 0.1006702094, alpha: 1)
            Config.Colors.grayText = #colorLiteral(red: 0.728748858, green: 0.7488489747, blue: 0.7654711604, alpha: 1)
            Config.Colors.green = #colorLiteral(red: 0, green: 0.790019691, blue: 0.467805326, alpha: 1)
            Config.Colors.red = #colorLiteral(red: 0.9951623082, green: 0.2123986185, blue: 0.2090759277, alpha: 1)
            Config.Colors.white = #colorLiteral(red: 0.06273300201, green: 0.06275205314, blue: 0.06273179501, alpha: 1)
            Config.Colors.whiteBars = #colorLiteral(red: 0.04605636048, green: 0.04651236405, blue: 0.04651236405, alpha: 1)
            Config.Colors.blackStatus = true
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

