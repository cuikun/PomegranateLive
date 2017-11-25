//
//  LiveSongCategoryManager.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveSongCategoryManager.h"
#import "LiveListNewRequest.h"

@implementation LiveSongCategoryManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self arrSongLiveCategoryModel]; // 初始化数组
    }
    return self;
}

-(void)selectSongCategoryWithSongLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel
{
    [self reloadLiveRoomInfoListWithLiveCategoryModel:liveCategoryModel];
    
    if ([self.songDelegate respondsToSelector:@selector(selectSoncategoryButtonWithSongLiveCategoryModel:)]) {
        [self.songDelegate selectSoncategoryButtonWithSongLiveCategoryModel:liveCategoryModel];
    }
}

-(void)reloadLiveRoomInfoListWithLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel
{
    self.selectedSongCategoryModel = liveCategoryModel;
    self.updateDatetime = liveCategoryModel.updateTime;
    self.arrLiveRoomInfoModel = liveCategoryModel.arrLiveRoomInfoModel;
    [self reloadSelectedCategoryItem];
    [self checkUpdateWhenCategotyItemSelected];
}

-(void)reloadLiveRoomInfoList
{
    NSDate * currentTime = [NSDate date];
    self.updateDatetime = currentTime;
    self.selectedSongCategoryModel.updateTime = currentTime;
    NSDictionary * dicRequest = @{
                                  @"rate":@"1",
                                  @"type":self.selectedSongCategoryModel.categoryTypeCode,
                                  @"size":@"0",
                                  @"p":@"0",
                                  @"av":@"2.1"
                                  };
    [self.selectedSongCategoryModel requestWithParameterObject:dicRequest andSuccHandler:^(RequestCompletionSuccModel *succModel,id obj) {
        if (obj == self.selectedSongCategoryModel) { //防止请求过程中切换按钮
            self.arrLiveRoomInfoModel = succModel.arrSuccModel;
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

-(NSMutableArray<SongLiveCategoryModel *> *)arrSongLiveCategoryModel
{
    if (!_arrSongLiveCategoryModel) {
        _arrSongLiveCategoryModel = [[NSMutableArray alloc]init];
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"songLiveListCategory" ofType:@"plist"];
        NSArray * arrLiveListCategoryDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];//从plist文件中取出数据
        _arrSongLiveCategoryModel = [CommonModel modelsOfClass:[SongLiveCategoryModel class] fromDictArray:arrLiveListCategoryDic];
    }
    return _arrSongLiveCategoryModel;
}

-(SongLiveCategoryModel *)selectedSongCategoryModel
{
    if (!_selectedSongCategoryModel) {
        _selectedSongCategoryModel = self.arrSongLiveCategoryModel[0];
    }
    return _selectedSongCategoryModel;
}
@end
