//
//  AppDelegate.swift
//  swiftShrb
//
//  Created by PayBay on 15/9/28.
//  Copyright © 2015年 PayBay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().barTintColor = shrbPink
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:font20]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().tintColor = shrbPink
        UITableView.appearance().tintColor = shrbTableViewColor
        UITextField.appearance().tintColor = shrbTableViewColor
        UITextView.appearance().tintColor = shrbTableViewColor
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -60), forBarMetrics:UIBarMetrics.Default)
        
        //        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        
               
        
        let firstItemIcon : UIApplicationShortcutIcon = UIApplicationShortcutIcon(templateImageName: "vipIcon")
        
        let firstItem : UIMutableApplicationShortcutItem = UIMutableApplicationShortcutItem(type: "first", localizedTitle: "卡包", localizedSubtitle: nil, icon: firstItemIcon, userInfo: nil)
        
        let secondItemIcon : UIApplicationShortcutIcon = UIApplicationShortcutIcon(templateImageName: "设置Icon")
        
        let secondItem : UIMutableApplicationShortcutItem = UIMutableApplicationShortcutItem(type: "second", localizedTitle: "设置", localizedSubtitle: nil, icon: secondItemIcon, userInfo: nil)
        
        let thirdItemIcon : UIApplicationShortcutIcon = UIApplicationShortcutIcon(templateImageName: "QRIcon")
        
        let thirdItem : UIMutableApplicationShortcutItem = UIMutableApplicationShortcutItem(type: "third", localizedTitle: "扫码支付", localizedSubtitle: nil, icon: thirdItemIcon, userInfo: nil)
        
        application.shortcutItems = [firstItem,secondItem,thirdItem]
        
        return true
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        
        
        let tabBarController : UITabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        
        
        if shortcutItem.type == "first" {
            tabBarController.selectedIndex = 1
            
            let cardViewController = CardViewController()
            cardViewController.hidesBottomBarWhenPushed = true
            
            let nav = tabBarController.selectedViewController as! UINavigationController
            nav.pushViewController(cardViewController, animated: true)
        }
        else if shortcutItem.type == "second" {
            tabBarController.selectedIndex = 2
            
            let settingViewController = SettingViewController()
            settingViewController.hidesBottomBarWhenPushed = true
            let nav = tabBarController.selectedViewController as! UINavigationController
            nav.pushViewController(settingViewController, animated: true)
        }
        else {
            tabBarController.selectedIndex = 0
            UserDefaultsSaveInfo.userDefaultsStandardUserDefaultsObject("viewControllers[0]", keyString: "QRPay")
            
            let supermarketQRViewController = SupermarketQRViewController()
            supermarketQRViewController.merchId = "201508111544260859"
            supermarketQRViewController.hidesBottomBarWhenPushed = true
            
            let nav = tabBarController.selectedViewController as! UINavigationController
            nav.pushViewController(supermarketQRViewController, animated: true)

        }
    }
    
    func setupWithStatusBar(application: UIApplication) {
        
        // 设置状态栏高亮
        application.statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

