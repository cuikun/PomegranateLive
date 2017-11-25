//
//  PLLobbyHorizonCollectionViewCell.h
//  PomegranateLive
//
//  Created by CKK on 17/2/22.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveCategoryManager.h"

@protocol PLLobbyHorizonCollectionViewCellDelegate <NSObject>

/**
 *  Item选中
 *
 *  @param liveRoomInfoModel 选中的Item的model数据
 */
-(void)lobbyVerticalCollectionViewSelectItemModel:(LiveRoomInfoModel *)liveRoomInfoModel;

@end

static NSString * const lobbyVerticalCollectionViewCellID = @"lobbyVerticalCollectionViewCellID";
@class PLLobbyVerticalCollectionBackgroundView;

@interface PLLobbyHorizonCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LiveCategoryManagerDelegate>
{
    UICollectionView * _lobbyVerticalCollectionView;
    UICollectionViewFlowLayout * _lobbyVerticalCollectionViewFlowLayout;
}
@property (nonatomic,weak) id<PLLobbyHorizonCollectionViewCellDelegate> delegate;
@property (nonatomic,weak) LiveCategoryManager * liveCategoryManager;
@property (nonatomic,strong) UICollectionView * lobbyVerticalCollectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * lobbyVerticalCollectionViewFlowLayout;
@property (nonatomic,strong) PLLobbyVerticalCollectionBackgroundView * viewLobbyVerticalBack;

@end

@class PLRefreshControl;

@interface PLLobbyVerticalCollectionBackgroundView : UIView

@property (nonatomic,strong) PLRefreshControl * refreshControl;
@property (nonatomic,weak) UICollectionView * lobbyVerticalCollectionView;
@property (nonatomic,strong) UIActivityIndicatorView * backViewCenterRefreshIndicatorView;


@end
