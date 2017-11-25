//
//  PLLobbyNavigationView.m
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyNavigationView.h"

static float const kLiveCategoryListBarAlpha = 0.9f;

@interface PLLobbyNavigationView ()

@property (nonatomic,strong) NSMutableArray * arrLiveCategoryManager;

@end

@implementation PLLobbyNavigationView

-(instancetype)initWithMainDataSource:(NSMutableArray *)arrLiveCategoryManager
{
    self = [super init];
    if (self) {
        self.arrLiveCategoryManager = arrLiveCategoryManager;
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    self.size = CGSizeMake(SCREEN_WIDTH, kNavigationBarHeight + kStatusBarHeight);
    self.backgroundColor = [UIColor colorWithRed:0.85f green:0.24f blue:0.20f alpha:kLiveCategoryListBarAlpha];
    
    self.btnLeftbarButtonItem.origin = CGPointMake(10, (kNavigationBarHeight - self.btnLeftbarButtonItem.height)/2 + kStatusBarHeight);
    [self addSubview:self.btnLeftbarButtonItem];
    self.btnRightBarButtonItem.origin = CGPointMake(SCREEN_WIDTH - self.btnRightBarButtonItem.width - 10, (kNavigationBarHeight - self.btnRightBarButtonItem.height)/2 + kStatusBarHeight);
    [self addSubview:self.btnRightBarButtonItem];
    self.liveCategoryListBar.frame = CGRectMake(self.btnLeftbarButtonItem.rightX, kStatusBarHeight,self.btnRightBarButtonItem.originX - self.btnLeftbarButtonItem.rightX,kNavigationBarHeight);
    [self addSubview:self.liveCategoryListBar];
}


#pragma mark - getter

-(UIButton *)btnLeftbarButtonItem
{
    if (!_btnLeftbarButtonItem) {
        _btnLeftbarButtonItem  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kNavigationBarHeight, kNavigationBarHeight)];
        [_btnLeftbarButtonItem setImage:[UIImage imageNamed:@"live_list_button_show_search_normal"] forState:UIControlStateNormal];
        [_btnLeftbarButtonItem setImage:[UIImage imageNamed:@"live_list_button_show_search_highlight"] forState:UIControlStateHighlighted];
    }
    return _btnLeftbarButtonItem;
}

-(PLAnimationButton *)btnRightBarButtonItem
{
    if (!_btnRightBarButtonItem) {
        _btnRightBarButtonItem = [[PLAnimationButton alloc]initWithFrame:CGRectMake(0, 0, kNavigationBarHeight, kNavigationBarHeight)];
    }
    return _btnRightBarButtonItem;
}

-(PLLiveCategoryListBar *)liveCategoryListBar
{
    if (!_liveCategoryListBar) {
        _liveCategoryListBar = [[PLLiveCategoryListBar alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, kNavigationBarHeight) andMainDataSource:self.arrLiveCategoryManager];
    }
    return _liveCategoryListBar;
}

@end
