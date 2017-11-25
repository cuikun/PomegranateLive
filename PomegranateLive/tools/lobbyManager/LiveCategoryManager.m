//
//  LiveCategoryManager.m
//  PomegranateLive
//
//  Created by CKK on 17/2/17.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveCategoryManager.h"
#import "LiveListNewRequest.h"
//TODO 百度一下time.h
#import <time.h>

static NSTimeInterval const kUpdateTimeInterval = 180;//刷新时间间隔

@interface LiveCategoryManager ()


@end

@implementation LiveCategoryManager


-(void)reloadSelectedCategoryItem
{
    //刷新数据
    if ([self.delegate respondsToSelector:@selector(liveCategoryManager:requestFailedWithDataSource:)]) {
        [self.delegate liveCategoryManager:self reloadLiveRoomInfoListUIWithDataSource:self.arrLiveRoomInfoModel];
    }
}

-(void)checkUpdateWhenCategotyItemSelected
{
    //检查是否需要更新数据
    if ([self needUpdateDataSource]) {
        if ([self.delegate respondsToSelector:@selector(liveCategoryManager:startRequestWithDataSource:)]) {
            [self.delegate liveCategoryManager:self startRequestWithDataSource:self.arrLiveRoomInfoModel];
        }
    }
}

-(void)reloadLiveRoomInfoList
{
    self.updateDatetime = [NSDate date];
    NSDictionary * dicRequest = @{
                                  @"rate":@"1",
                                  @"type":self.liveCategoryModel.categoryTypeCode,
                                  @"size":@"0",
                                  @"p":@"0",
                                  @"av":@"2.1"
                                  };
    [LiveListNewRequest requestWithParameterObject:dicRequest andSuccHandler:^(RequestCompletionSuccModel *succModel) {
        self.arrLiveRoomInfoModel = succModel.arrSuccModel;
        if ([self.delegate respondsToSelector:@selector(liveCategoryManager:reloadLiveRoomInfoListUIWithDataSource:)]) {
            [self.delegate liveCategoryManager:self
             reloadLiveRoomInfoListUIWithDataSource:self.arrLiveRoomInfoModel];
        }
    } failHandler:^(RequestCompletionFailModel *failModel) {
        if ([self.delegate respondsToSelector:@selector(liveCategoryManager:requestFailedWithDataSource:)]) {
            [self.delegate liveCategoryManager:self requestFailedWithDataSource:self.arrLiveRoomInfoModel];
        }
    }];
}

#pragma mark - uitl

/**
 *  是否需要更新数据
 *
 */
-(BOOL)needUpdateDataSource
{
    NSDate * currentDatetime = [NSDate date];
    NSTimeInterval timeInterval = [currentDatetime timeIntervalSinceDate:self.updateDatetime];
    if (timeInterval > kUpdateTimeInterval || self.arrLiveRoomInfoModel.count == 0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - getter

-(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (!_arrLiveRoomInfoModel) {
        _arrLiveRoomInfoModel = [[NSMutableArray alloc]init];
    }
    return _arrLiveRoomInfoModel;
}

-(NSDate *)updateDatetime
{
    if (!_updateDatetime) {
        _updateDatetime = [NSDate distantPast];
    }
    return _updateDatetime;
}


@end
