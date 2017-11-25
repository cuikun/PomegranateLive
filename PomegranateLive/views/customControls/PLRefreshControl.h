//
//  PLRefreshControl.h
//  PomegranateLive
//
//  Created by CKK on 17/2/28.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"

//下拉刷新的三种状态
typedef NS_ENUM(NSInteger,EnumRefreshState){
    
    EnumRefreshStateBeginPullDown = 0,   //开始下拉
    EnumRefreshStateWillRefresh,     //即将刷新(松手即刷新)
    EnumRefreshStateBeginRefresh,   //开始刷新
    EnumRefreshStateEndRefresh //刷新结束
    
};

@interface PLRefreshControl : UIControl

@property (nonatomic, assign) EnumRefreshState refreshState;
@property (nonatomic, strong) UIScrollView *currentScrollView;

-(void)startRefresh;
-(void)endRefresh;

@end
