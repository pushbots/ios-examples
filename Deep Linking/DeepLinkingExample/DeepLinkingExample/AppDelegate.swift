//
//  AppDelegate.swift
//  DeepLinkingExample
//
//  Created by Atiaa on 2/26/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        _ = Pushbots(appId:"YOUR_APPID", prompt: true);
        //Track Push notification opens while launching the app form it
        Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: launchOptions);
        
        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                //Capture notification data e.g. badge, alert and sound
                
                if let aps = userInfo["aps"] as? NSDictionary {
                    
                    //Handle Notification if it's URL or DeepLinking.
                    
//         depercated           Pushbots.openURL(userInfo as! [AnyHashable : Any])
                    
                    
//                    Pushbots.handleNotification(userInfo as! [AnyHashable : Any])

                    
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
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let vcID = components?.host;
        
        //return if this is not a promotion deep link
        
        if (vcID  != "Payment" && vcID  != "ItemDetails") {
            return false
        }
        
        switch vcID! {
        case "Payment":
            
            var payementID:String = ""
            
            for var item:URLQueryItem in  (components?.queryItems!)!
            {
                if (item.name == "id"){
                    payementID = item.value!
                }
            }
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let PaymentViewController = mainStoryboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
            PaymentViewController.paymentID = payementID;
            self.window?.rootViewController = PaymentViewController
            
            
            break
        case "ItemDetails":
            
            var itemID:String = ""
            
            for var item:URLQueryItem in  (components?.queryItems!)!
            {
                if (item.name == "id"){
                    itemID = item.value!
                }
            }
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ItemDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: "ItemDetailsViewController") as! ItemDetailsViewController
            
            ItemDetailsViewController.itemID = itemID;
            self.window?.rootViewController = ItemDetailsViewController
            break
        default:
            return true
        }
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        //         depercated           Pushbots.openURL(userInfo as! [AnyHashable : Any])
        
        
        Pushbots.handleNotification(userInfo as! [AnyHashable : Any])

        
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
            
        }
    }


}

