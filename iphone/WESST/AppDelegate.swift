//
//  AppDelegate.swift
//  WESST
//
//  Created by Nathan Tannar on 2016-06-12.
//  Copyright © 2016 NathanTannar. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let navbar = UINavigationBar.appearance()
        navbar.barTintColor = UIColor(red: 153.0/255, green:62.0/255.0, blue:123.0/255, alpha: 1)
        navbar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navbar.tintColor = UIColor.whiteColor()
        navbar.translucent = false
        
        
        Parse.setApplicationId("hKmxGJE5hCHKaJzo6gLaHiTA0rHP4LLfaU3glM5w", clientKey: "eaRPKYGEroESs0JFj1LrJImfjCVEKyJTZUb9orj3")
        
        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
            
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    
    // Mark - Push Notification methods
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock{ (succeeed: Bool, error: NSError?) -> Void in
            if error != nil {
                print("didRegisterForRemoteNotificationsWithDeviceToken")
                print(error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }
    
    // TODO: Rewrite this method with notifications
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //        let delay = 4.0 * Double(NSEC_PER_SEC)
        //        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        //        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
        //            MessagesViewController.refreshMessagesView()
        //        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
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

