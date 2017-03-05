//
//  AppDelegate.m
//  DeepLinkingObjc
//
//  Created by Atiaa on 2/26/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

#import "AppDelegate.h"
#import "PaymentViewController.h"
#import "ItemDetailsViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.PushbotsClient = [[Pushbots alloc] initWithAppId:@"YOUR_APP_ID" prompt:YES];
    
    [self.PushbotsClient trackPushNotificationOpenedWithLaunchOptions:launchOptions];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        //Check for openURL [optional]
// Deprecated       [Pushbots openURL:userInfo];
        
        
        //Handle notifications " open url , deeplinking "
//        [Pushbots handleNotifications:userInfo];
        
        //Capture notification data e.g. badge, alert and sound
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        
        if (aps) {
            //If you send title for the notifications
            NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
            NSDictionary *alertDict = [notificationDict objectForKey:@"alert"];
            NSString *alertbody = [alertDict objectForKey:@"body"];
            NSString *alertTitle= [alertDict objectForKey:@"title"];
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:alertTitle
                                         message:alertbody
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            /* If you didn't send title for the notifications
             NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
             NSString *alertString = [notificationDict objectForKey:@"alert"];
             
             UIAlertController * alert = [UIAlertController
             alertControllerWithTitle:@"Push Notification Received"
             message:alertString
             preferredStyle:UIAlertControllerStyleAlert];
             
             */
            
            [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
        }
        //Capture custom fields
        //        NSString* articleId = [userInfo objectForKey:@"articleId"];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSString *vcID = components.host;
    
    //return if this is not a promotion deep link
    if(![vcID isEqualToString:@"Payment"] && ![vcID isEqualToString:@"ItemDetails"] )
        return NO;
    
    //Handle Payment scheme
    if ([vcID isEqualToString:@"Payment"]) {
        NSString *payementID;
        for(NSURLQueryItem *item in components.queryItems)
        {
            //get the param you need.
            if([item.name isEqualToString:@"id"])
                payementID = item.value;
        }
        
        //push the viewcontroller and pass your data to.
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        PaymentViewController *pvc = (PaymentViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        pvc.payementID = payementID;
        
        self.window.rootViewController = pvc;
        
    }else if ([vcID isEqualToString:@"ItemDetails"]){
        
        NSString *itemID;
        
        for(NSURLQueryItem *item in components.queryItems)
        {
            if([item.name isEqualToString:@"id"])
                itemID = item.value;
        }
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ItemDetailsViewController *ivc = (ItemDetailsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ItemDetailsViewController"];
        ivc.itemID = itemID;
        
        self.window.rootViewController = ivc;
        
    }
    return YES;
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Register the deviceToken on Pushbots
    [self.PushbotsClient registerOnPushbots:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error description]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Check for openURL [optional]
    
    // Deprecated       [Pushbots openURL:userInfo];
    
    
    //Handle notifications " open url , deeplinking "
    //        [Pushbots handleNotifications:userInfo];
    

    //Track notification only if the application opened from Background by clicking on the notification.
    if (application.applicationState == UIApplicationStateInactive) {
        [self.PushbotsClient trackPushNotificationOpenedWithPayload:userInfo];
    }
    
    //The application was already active when the user got the notification, just show an alert.
    //That should *not* be considered open from Push.
    if (application.applicationState == UIApplicationStateActive) {
        
        //If you send title for the notifications
        NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
        NSDictionary *alertDict = [notificationDict objectForKey:@"alert"];
        NSString *alertbody = [alertDict objectForKey:@"body"];
        NSString *alertTitle= [alertDict objectForKey:@"title"];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:alertTitle
                                     message:alertbody
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        /* If you didn't send title for the notifications
         NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
         NSString *alertString = [notificationDict objectForKey:@"alert"];
         
         UIAlertController * alert = [UIAlertController
         alertControllerWithTitle:@"Push Notification Received"
         message:alertString
         preferredStyle:UIAlertControllerStyleAlert];
         
         */
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
        
    }
}

@end
