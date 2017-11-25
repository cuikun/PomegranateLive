//
//  PLLiveCategoryListBar.h
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PomegranateLive.h"

@class LiveCategoryManager;

@protocol PLLiveCategoryListBarDelegate <NSObject>


/**
 *  将要选中一个分类
 *
 *  @param itemIndex 分类index
 */
-(void)liveCategoryListBarShouldSelectItemAtIndex:(NSInteger)itemIndex;

/**
 *  点击选中一个分类
 *
 *  @param itemIndex 分类index
 */
-(void)liveCategoryListBarDidSelectItemAtIndex:(NSInteger)itemIndex;

@end

@interface PLLiveCategoryListBar : UICollectionView

@property (nonatomic,weak) id<PLLiveCategoryListBarDelegate> listBardelegate;

/**
 *  初始化
 *
 *  @param frame          frame
 *  @param arrLiveCategoryManager 数据源,LiveCategoryManager
 *
 *  @return PLLiveCategoryListBar对象
 */
- (instancetype)initWithFrame:(CGRect)frame andMainDataSource:(NSMutableArray<LiveCategoryManager *> *)arrLiveCategoryManager;

/**
 *  viewIndicator 跟随scorllview 滑动而滑动
 *
 *  @param scrollView 要跟随的scorllview
 */
-(void)indicatorMoveFollowScrollview:(UIScrollView *)scrollView;

/**
 *  选中一个Item
 *
 *  @param index itemIndex
 */
-(void)listBarSelectItemAtIndex:(NSInteger)index;

@end

@interface PLLiveCategoryListBarCell : UICollectionViewCell

-(void)reloadDataWithCategoryName:(NSString *)categoryName isSelected:(BOOL)isSelected;

@property (nonatomic,strong) UILabel * lblCategoryName;
@property (nonatomic) BOOL isSelected;

@end
