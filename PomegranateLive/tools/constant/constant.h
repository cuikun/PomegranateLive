//
//  constant.h
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - APP_UI

FOUNDATION_EXTERN float const kNavigationBarHeight;
FOUNDATION_EXTERN float const kTabbarHeight;

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height


#pragma mark - APP_NETWORK
extern NSString * const kNetworkNotReachableErrorCode;
extern NSString * const kNetworkNotReachableErrorDescription;
