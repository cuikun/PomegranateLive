//
//  LiveLocationCategoryManager.h
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "LiveCategoryManager.h"
#import "LiveListLoactionModel.h"


@interface LiveLocationCategoryManager : LiveCategoryManager

@property (nonatomic,strong) NSMutableArray<ProvinceNumModel *> * arrProvnceNumModel;
@property (nonatomic,strong) ProvinceNumModel * localProvinceNumModel;

/**
 *  更新省份刷新
 */
-(void)reloadLiveRoomInfoListWithPid:(NSString *)pid;


@end
