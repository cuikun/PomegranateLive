//
//  LiveLocationCategoryManager.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveLocationCategoryManager.h"
#import "LiveListLocationRequest.h"

@interface LiveLocationCategoryManager ()

@property (nonatomic,strong) NSString * pid;

@end
@implementation LiveLocationCategoryManager

-(void)reloadLiveRoomInfoListWithPid:(NSString *)pid
{
    self.pid = pid;
    //重置 arrLiveRoomInfoModel，updateDatetime为初始状态
    [self.arrLiveRoomInfoModel removeAllObjects];
    self.updateDatetime = [NSDate distantPast];
    [self checkUpdateWhenCategotyItemSelected];
}

-(void)reloadLiveRoomInfoList
{
    self.updateDatetime = [NSDate date];
    NSDictionary * dicRequest = @{
                            @"size":@"0",
                            @"p":@"0",
                            @"pid":self.pid
                            };
    [LiveListLocationRequest requestWithParameterObject:dicRequest andSuccHandler:^(RequestCompletionSuccModel *succModel) {
        LiveListLocationRequestSuccModel * locationSuccModel = (LiveListLocationRequestSuccModel *)succModel;
        if ([self.pid isEqualToString:locationSuccModel.localProvinceNumModel.pid] || self.pid.length == 0) { //返回数据是当前选择的地区的数据
            self.arrLiveRoomInfoModel = locationSuccModel.arrSuccModel;
            self.arrProvnceNumModel = locationSuccModel.arrProvinceNumModel;
            self.localProvinceNumModel = locationSuccModel.localProvinceNumModel;
            if ([self.delegate respondsToSelector:@selector(liveCategoryManager:reloadLiveRoomInfoListUIWithDataSource:)]) {
                [self.delegate liveCategoryManager:self reloadLiveRoomInfoListUIWithDataSource:self.arrLiveRoomInfoModel];
            }
        }
    } failHandler:^(RequestCompletionFailModel *failModel) {
        if ([self.delegate respondsToSelector:@selector(liveCategoryManager:requestFailedWithDataSource:)]) {
            [self.delegate liveCategoryManager:self requestFailedWithDataSource:self.arrLiveRoomInfoModel];
        }
    }];
}

#pragma mark - getter

-(NSString *)pid
{
    if (!_pid) {
        _pid = @"";
    }
    return _pid;
}

@end
