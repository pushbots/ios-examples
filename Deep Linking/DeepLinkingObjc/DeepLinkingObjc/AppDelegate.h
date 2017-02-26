//
//  AppDelegate.h
//  DeepLinkingObjc
//
//  Created by Atiaa on 2/26/17.
//  Copyright © 2017 PushBots. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pushbots/Pushbots.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Pushbots *PushbotsClient;


@end

