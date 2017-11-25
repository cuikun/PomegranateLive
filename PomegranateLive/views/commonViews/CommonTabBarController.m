//
//  CommonTabBarController.m
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "CommonTabBarController.h"
#import "PLLobbyViewController.h"

@implementation CommonTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabbar];
}

-(void)initTabbar
{
    PLLobbyViewController * lobbyViewController = [[PLLobbyViewController alloc]init];
    UINavigationController * lobbyNav = [[UINavigationController alloc]initWithRootViewController:lobbyViewController];
     self.viewControllers = [NSArray arrayWithObjects:lobbyNav,nil];
}

@end
