//
//  PLLobbySongVerticalCollectionHeaderView.h
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveSongCategoryManager.h"

@interface PLLobbySongVerticalCollectionHeaderView : UIView

@property (nonatomic,strong) NSMutableDictionary * dicLiveSongCategoryButton;
@property (nonatomic,strong) LiveSongCategoryManager * liveSongCategoryManager;

-(instancetype)initWithFrame:(CGRect)frame andLiveSongCategoryManager:(LiveSongCategoryManager *)liveSongCategoryManager;

@end
