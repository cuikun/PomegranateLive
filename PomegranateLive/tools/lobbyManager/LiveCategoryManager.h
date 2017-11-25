//
//  LiveCategoryManager.h
//  PomegranateLive
//
//  Created by CKK on 17/2/17.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveCategoryModel.h"
#import "LiveRoomInfoModel.h"

@class LiveCategoryManager;
/**
 *  分类管理类，管理每一个分类下的列表动作
 */
@protocol LiveCategoryManagerDelegate <NSObject>


/**
 刷新列表

 @param liveCategoryManager self
 @param arrLiveRoomInfoModel 数据源
 */
-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager reloadLiveRoomInfoListUIWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *) arrLiveRoomInfoModel;

/**
 开始请求数据

 @param liveCategoryManager self
 @param arrLiveRoomInfoModel 数据源
 */
-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager startRequestWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *) arrLiveRoomInfoModel;

/**
 请求失败

 @param liveCategoryManager self
 @param arrLiveRoomInfoModel 数据源
 */
-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager requestFailedWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *) arrLiveRoomInfoModel;

@end

@interface LiveCategoryManager : NSObject

@property (nonatomic,strong) NSDate * updateDatetime;
@property (nonatomic,weak) id<LiveCategoryManagerDelegate> delegate;
@property (nonatomic,strong) LiveCategoryModel * liveCategoryModel;
@property (nonatomic,strong) NSMutableArray<LiveRoomInfoModel *> * arrLiveRoomInfoModel;

/*
 * 填充数据
 */
-(void)reloadSelectedCategoryItem;

/**
 *  分类Item选中时，检查刷新
 */
-(void)checkUpdateWhenCategotyItemSelected;
/**
 *  直接下拉刷新
 */
-(void)reloadLiveRoomInfoList;

@end
