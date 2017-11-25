//
//  PLSongCategoryButton.m
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLSongCategoryButton.h"
#import "LiveListNewRequest.h"

static CGFloat const kMarginForImageAndTitle = 10.f;

@implementation PLSongCategoryButton

-(void)setLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel
{
    _liveCategoryModel = liveCategoryModel;
    
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self setImage:[UIImage imageNamed:liveCategoryModel.categoryImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:liveCategoryModel.categoryImageNameH] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:liveCategoryModel.categoryImageNameH] forState:UIControlStateSelected];
    
    [self setTitleColor:[UIColor colorWithRed:0.58f green:0.58f blue:0.58f alpha:1.00f] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:0.88f green:0.00f blue:0.57f alpha:1.00f] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRed:0.88f green:0.00f blue:0.57f alpha:1.00f] forState:UIControlStateSelected];
    
    [self setTitle:liveCategoryModel.categoryName forState:UIControlStateNormal];
    [self setTitle:liveCategoryModel.categoryName forState:UIControlStateHighlighted];
    [self setTitle:liveCategoryModel.categoryName forState:UIControlStateSelected];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, kMarginForImageAndTitle/2, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kMarginForImageAndTitle/2)];
}

@end

@implementation SongLiveCategoryModel


-(void)requestWithParameterObject:(id) parameterObject andSuccHandler:(SongRequestCompletionSuccHandler)succHandler failHandler:(RequestCompletionFailHandler) failHandler
{
    [LiveListNewRequest requestWithParameterObject:parameterObject andSuccHandler:^(RequestCompletionSuccModel *succModel) {
        self.arrLiveRoomInfoModel = succModel.arrSuccModel;
        succHandler(succModel,self);
    } failHandler:^(RequestCompletionFailModel *failModel) {
        failHandler(failModel);
    }];
    
}

-(NSDate *)updateTime
{
    if (!_updateTime) {
        _updateTime = [NSDate distantPast];
    }
    return _updateTime;
}

-(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (!_arrLiveRoomInfoModel) {
        _arrLiveRoomInfoModel = [[NSMutableArray alloc]init];
    }
    return _arrLiveRoomInfoModel;
}

@end
