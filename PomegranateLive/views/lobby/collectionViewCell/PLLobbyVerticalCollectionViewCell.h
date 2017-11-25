//
//  PLLobbyVerticalCollectionViewCell.h
//  PomegranateLive
//
//  Created by CKK on 17/2/22.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveRoomInfoModel.h"

@interface PLLobbyVerticalCollectionViewCell : UICollectionViewCell

/**
 *  刷新cell内容
 *
 *  @param roomInfoModel roomInfoModel
 */
-(void)reloadDataWithRoomInfoModel:(LiveRoomInfoModel *)roomInfoModel;

@end
