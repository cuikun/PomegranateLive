//
//  PLLobbyLocationVerticalCollectionHeaderView.h
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"
#import "LiveLocationCategoryManager.h"

@protocol PLLobbyLocationVerticalCollectionHeaderViewDelegate <NSObject>

-(void)provinceTableShowStatusChangeTo:(BOOL)isShow;
-(BOOL)isRefreshOfRefreshControl;

@end

@interface PLLobbyLocationVerticalCollectionHeaderView : UIView

@property (nonatomic,weak) id<PLLobbyLocationVerticalCollectionHeaderViewDelegate> delegate;

-(void)reloadWithLiveLocationCategoryManager:(LiveLocationCategoryManager *)liveLocationCategoryManager;

@end

@interface PLProvinceTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel * lblProvinceName;
@property (nonatomic,strong) UIImageView * imgViewSelect;
@property (nonatomic,strong) UIView * viewLine;

-(void)reloadWithProvinceNumModel:(ProvinceNumModel *)provinceNumModel andLocalProvinceNumModel:(ProvinceNumModel *)localProvinceNumModel;



@end
