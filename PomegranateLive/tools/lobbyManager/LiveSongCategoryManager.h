//
//  LiveSongCategoryManager.h
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveCategoryManager.h"
#import "PomegranateLive.h"
#import "PLSongCategoryButton.h"

@protocol LiveSongCategoryManagerDelegate <NSObject>

-(void)selectSoncategoryButtonWithSongLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel;

@end

@interface LiveSongCategoryManager : LiveCategoryManager

@property (nonatomic,strong) SongLiveCategoryModel * selectedSongCategoryModel;
@property (nonatomic,strong) NSMutableArray<SongLiveCategoryModel *> * arrSongLiveCategoryModel;
@property (nonatomic,strong) id<LiveSongCategoryManagerDelegate> songDelegate;

/**
 *  更改唱歌分类刷新列表
 *
 *  @param type type
 */
-(void)reloadLiveRoomInfoListWithLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel;

/**
 *  选中对应分类的按钮
 *
 *  @param liveCategoryModel liveCategoryModel
 */
-(void)selectSongCategoryWithSongLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel;

@end
