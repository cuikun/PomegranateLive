//
//  AppDelegate+PomergranateLive.m
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "AppDelegate+PomergranateLive.h"
#import "CommonTabBarController.h"
#import "AFNetworkReachabilityManager.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>
#import <arpa/inet.h>

@implementation AppDelegate (PomergranateLive)

-(void)initPomergranateLiveInApplication:(UIApplication *)application LaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initRootViewController];
    [self initAFNReachabilityManager];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [self getDNSServers];
    NSLog(@"%@",[self carrierName]);
    NSLog(@"%@",[self getIpAddresses]);
}

-(void)initRootViewController
{
    CommonTabBarController * tabController = [[CommonTabBarController alloc]init];
    self.window.rootViewController = tabController;
}

-(void)initAFNReachabilityManager
{
    AFNetworkReachabilityManager * shareManager = [AFNetworkReachabilityManager sharedManager];
    [shareManager startMonitoring];
}

/**
 *  获取异常崩溃信息
 */
void UncaughtExceptionHandler(NSException *exception) {
    
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];

    DEBUG_LOG(@"%@",content);
}


- (NSString *) getDNSServers
{
    // dont forget to link libresolv.lib
    NSMutableString *addresses = [[NSMutableString alloc]initWithString:@"DNS Addresses \n"];
    
    res_state res = malloc(sizeof(struct __res_state));
    
    int result = res_ninit(res);
    
    if ( result == 0 )
    {
        for ( int i = 0; i < res->nscount; i++ )
        {
            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
            [addresses appendFormat:@"%@\n",s];
            NSLog(@"%@",s);
        }
    }
    else
        [addresses appendString:@" res_init result != 0"];
    
    return addresses;
}

-(NSString*)carrierName
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
#if TARGET_IPHONE_SIMULATOR
    return @"Simulator";
#else
    if (carrier.carrierName == nil || carrier.carrierName.length <= 0) return @"N/A";
#endif
    return carrier.carrierName;
}

//获取ip地址
- (NSString *)getIpAddresses{
    NSMutableString *address = [[NSMutableString alloc]init];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    [address appendFormat:@"%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
