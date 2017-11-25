//
//  PLLiveListMenuView.h
//  PomegranateLive
//
//  Created by CKK on 17/2/25.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveCategoryManager.h"
#import "LiveSongCategoryManager.h"
#import "PLVerticalCollectionFlowLayout.h"

@protocol PLLiveListMenuViewDelegate <NSObject>

-(void)liveListMenuViewDidSelectItemIndex:(NSInteger)itemIndex;
-(void)closeMenuView;

@end

@interface PLLiveListMenuView : UIControl

@property (nonatomic,strong) NSMutableArray<LiveCategoryManager *> * arrLivecategoryManager;
@property (nonatomic) NSInteger selectedCategoryItemIndex;
@property (nonatomic,weak) id<PLLiveListMenuViewDelegate> delegate;
-(void)liveListMenuViewShowInView:(UIView *)superView;

@end

@interface PLLiveListMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic) BOOL isSelected;
@property (nonatomic,strong) LiveCategoryModel * liveCategoryModel;
@property (nonatomic,strong) UIView * viewCustomContent;

@end

@interface PLLiveListMenuCollectionHeaderView : UICollectionReusableView

@property (nonatomic,strong) UIView * viewLine;
@property (nonatomic,strong) UILabel * lblSectionTitle;

@end
