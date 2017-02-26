    //
//  AppDelegate.m
//  PushBotsObjcDemo
//
//  Created by Atiaa on 1/4/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.PushbotsClient = [[Pushbots alloc] initWithAppId:@"YOUR_APPID" prompt:YES];
    
    [self.PushbotsClient trackPushNotificationOpenedWithLaunchOptions:launchOptions];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        //Check for openURL [optional]
        [Pushbots openURL:userInfo];
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
    
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
           }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];
                 [self setNotificationsCategories];
                 // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }
    
    
    return YES;
    
}

- (void)setNotificationsCategories {
    
    UNNotificationAction *readAction = [UNNotificationAction actionWithIdentifier:@"ReadNow"
                                                                              title:@"Read Now 📰 " options:UNNotificationActionOptionNone];
    UNNotificationAction *laterAction = [UNNotificationAction actionWithIdentifier:@"Later"
                                                                              title:@"Later" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *newsCategory = [UNNotificationCategory categoryWithIdentifier:@"News"
                                                                              actions:@[readAction,laterAction] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    
    UNNotificationAction *shopAction = [UNNotificationAction actionWithIdentifier:@"ShopNow"
                                                                            title:@"Shop Now 🛍️" options:UNNotificationActionOptionNone];
    UNNotificationAction *dismissAction = [UNNotificationAction actionWithIdentifier:@"Dismiss"
                                                                             title:@"Dismiss" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *shopCategory = [UNNotificationCategory categoryWithIdentifier:@"Shopping"
                                                                              actions:@[shopAction,dismissAction] intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObjects:newsCategory,shopCategory, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];

    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Register the deviceToken on Pushbots
    [self.PushbotsClient registerOnPushbots:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Notification Registration Error %@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
    }];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:NotificationActionOneIdent]) {
        
        NSLog(@"You chose action 1.");
    }
    else if ([identifier isEqualToString:NotificationActionTwoIdent]) {
        
        NSLog(@"You chose action 2.");
    }
    if (completionHandler) {
        
        completionHandler();
    }
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert);
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    NSLog(@"%@", notification.request.content.userInfo);
}
@end
