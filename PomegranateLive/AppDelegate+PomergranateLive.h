//
//  AppDelegate+PomergranateLive.h
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "AppDelegate.h"
#import "PomegranateLive.h"

@interface AppDelegate (PomergranateLive)

-(void)initPomergranateLiveInApplication:(UIApplication *)application LaunchingWithOptions:(NSDictionary *)launchOptions;
void UncaughtExceptionHandler(NSException *exception);

@end
