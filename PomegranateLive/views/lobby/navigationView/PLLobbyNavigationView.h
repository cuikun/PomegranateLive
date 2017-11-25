//
//  PLLobbyNavigationView.h
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "PLLiveCategoryListBar.h"
#import "PLAnimationButton.h"

@interface PLLobbyNavigationView : UIView

/* 左侧搜索按钮 */
@property (nonatomic,strong) UIButton * btnLeftbarButtonItem;
@property (nonatomic,strong) PLLiveCategoryListBar * liveCategoryListBar;
/* 右侧更多按钮 */
@property (nonatomic,strong) PLAnimationButton * btnRightBarButtonItem;

-(instancetype)initWithMainDataSource:(NSMutableArray *)arrLiveCategoryManager;

@end
