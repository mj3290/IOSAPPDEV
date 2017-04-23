/**
 * Copyright 2015-2016 Kakao Corp.
 *
 * Redistribution and modification in source or binary forms are not permitted without specific prior written permission.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var loginViewController: UINavigationController!
    var mainViewController: UINavigationController!
    var mainTopViewController: UIViewController!
    
    func setupEntryController() {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.loginViewController = storyBoard.instantiateViewController(withIdentifier: "navigator") as! UINavigationController
        self.mainViewController = storyBoard.instantiateViewController(withIdentifier: "navigator") as! UINavigationController
        
        let viewController:UIViewController = storyBoard.instantiateViewController(withIdentifier: "login")
        self.loginViewController.pushViewController(viewController, animated: true)
        self.mainTopViewController = storyBoard.instantiateViewController(withIdentifier: "main")
        self.mainViewController.pushViewController(self.mainTopViewController, animated: true)
    }
    
    func loadRootViewController() {
        self.mainViewController.popToRootViewController(animated: true)
        self.window?.rootViewController = self.loginViewController
        self.window?.makeKeyAndVisible()
    }
    
    func reloadRootViewController() {
        let isOpened:Bool = KOSession.shared().isOpen()
        
        if isOpened {
            self.mainViewController.popToRootViewController(animated: true)
        }
        
        self.window?.rootViewController = isOpened ? self.mainViewController: self.loginViewController
        self.window?.makeKeyAndVisible()
    }

    func kakaoSessionDidChangeWithNotification() {
        self.reloadRootViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupEntryController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification), name: NSNotification.Name.KOSessionDidChange, object: nil)
        self.loadRootViewController()
        
        let session:KOSession = KOSession.shared()
        session.presentedViewBarTintColor = UIColor(red: 0x2a/255.0, green: 0x2a/255.0, blue: 0x2a/255.0, alpha: 1.0)
        session.presentedViewBarButtonTintColor = UIColor(red: 0xe5 / 255.0, green: 0xe5 / 255.0, blue: 0xe5 / 255.0, alpha: 1.0)
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return false
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

