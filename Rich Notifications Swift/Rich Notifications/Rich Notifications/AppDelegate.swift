//
//  AppDelegate.swift
//  PushBotsSwiftDemo
//
//  Created by Atiaa on 1/5/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //implement PushBots SDK
        
        _ = Pushbots(appId:"YOUR_APPID", prompt: true);
        //Track Push notification opens while launching the app form it
        Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: launchOptions);
        
        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                //Capture notification data e.g. badge, alert and sound

                if let aps = userInfo["aps"] as? NSDictionary {
                    Pushbots.openURL(userInfo as! [AnyHashable : Any])

                    let alert_message = aps["alert"] as! String
                    let alert = UIAlertController(title: "Push notification title",
                                                  message: alert_message,
                                                  preferredStyle: .alert)
                    
                    
                    //IF you send title for the notification.
                    //  if let aps = userInfo["aps"] as? NSDictionary {
                    //
                    //     if let alertDic = aps["alert"] as? NSDictionary{
                    //         let alert_message = alertDic["body"] as! String
                    //         let alert = UIAlertController(title: alertDic["title"] as? String,
                    //                                                  message: alert_message,
                    //                                                  preferredStyle: .alert)
                    
                    let defaultButton = UIAlertAction(title: "OK",
                                                      style: .default) {(_) in
                                                        // your defaultButton action goes here
                    }
                    
                    alert.addAction(defaultButton)
                    self.window?.rootViewController?.present(alert, animated: true) {
                        // completion goes here
                    }
                }
                
                
            }
        }
        
        //Notifications extensions
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // actions based on whether notifications were authorized or not
            }
            application.registerForRemoteNotifications()

        } else {
            // Fallback on earlier versions
        }
        setNotificationsCategories()

        return true
    }
    
    func setNotificationsCategories() {
        if #available(iOS 10.0, *) {

        let readNow = UNNotificationAction(
            identifier: "ReadNow",
            title: "Read Now 📰 "
        )
        let later = UNNotificationAction(
            identifier: "Later",
            title: "Later",
            options: [.destructive]
        )
        let newscategory = UNNotificationCategory(
            identifier: "News",
            actions: [readNow, later],
            intentIdentifiers: []
        )
        
        let shop = UNNotificationAction(
            identifier: "Shop",
            title: "Go Shopping 🛍️"
        )
        let dismiss = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [.destructive]
        )
        let categoryz = UNNotificationCategory(
            identifier: "Shopping",
            actions: [shop, dismiss],
            intentIdentifiers: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([newscategory,categoryz])
        UNUserNotificationCenter.current().delegate = self
        }else{
        
        
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
    
    // MARK: - push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This method will be called everytime you open the app
        // Register the deviceToken on Pushbots
        Pushbots.sharedInstance().register(onPushbots: deviceToken);
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification Registration Error \(error)")
    }
    
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .inactive  {
            Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: userInfo);
        }
        
        //The application was already active when the user got the notification, just show an alert.
        //That should *not* be considered open from Push.
        if application.applicationState == .active  {
            
            //Capture notification data e.g. badge, alert and sound
            
            //IF you didn't send title for the notification
            //            if let aps = userInfo["aps"] as? NSDictionary {
            //                let alert_message = aps["alert"] as! String
            //                let alert = UIAlertController(title: "Push notification title",
            //                                                          message: alert_message,
            //                                                          preferredStyle: .alert)
            //
            
            //IF you send title for the notification.
            if let aps = userInfo["aps"] as? NSDictionary {
                
                if let alertDic = aps["alert"] as? NSDictionary{
                    let alert_message = alertDic["body"] as! String
                    
                    let alert = UIAlertController(title: alertDic["title"] as? String,
                                                  message: alert_message,
                                                  preferredStyle: .alert)
                    
                    let defaultButton = UIAlertAction(title: "OK",
                                                      style: .default) {(_) in
                                                        // your defaultButton action goes here
                    }
                    
                    alert.addAction(defaultButton)
                    self.window?.rootViewController?.present(alert, animated: true) {
                        // completion goes here
                    }
                }
            }
            
        }    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Shop":
            print("Shop !!")
        case "ReadNow":
            print("Read Now")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
}
