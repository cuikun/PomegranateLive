//
//  PLLobbySongHorizonCollectionViewCell.h
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyHorizonCollectionViewCell.h"

@class LiveSongCategoryManager;

@interface PLLobbySongHorizonCollectionViewCell : PLLobbyHorizonCollectionViewCell

-(void)initHeaderViewWithLiveSongCategoryManager:(LiveSongCategoryManager *)liveSongCategoryManager;

@end
