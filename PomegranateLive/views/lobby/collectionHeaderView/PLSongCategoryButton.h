//
//  PLSongCategoryButton.h
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveCategoryModel.h"
#import "LiveRoomInfoModel.h"
#import "CommonAFNManager.h"

@class SongLiveCategoryModel;

@interface PLSongCategoryButton : UIButton

@property (nonatomic,strong) SongLiveCategoryModel * liveCategoryModel;

@end

typedef void (^SongRequestCompletionSuccHandler)(RequestCompletionSuccModel * succModel,id obj);

@interface SongLiveCategoryModel : LiveCategoryModel

//自有属性
@property (nonatomic,strong) NSString * categoryImageName;
@property (nonatomic,strong) NSString * categoryImageNameH;


//更新属性

@property (nonatomic,strong) NSDate * updateTime;
@property (nonatomic,strong) NSMutableArray<LiveRoomInfoModel *> * arrLiveRoomInfoModel;

-(void)requestWithParameterObject:(id) parameterObject andSuccHandler:(SongRequestCompletionSuccHandler)succHandler failHandler:(RequestCompletionFailHandler) failHandler;



@end
