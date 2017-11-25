//
//  PLLobbyLocationHorizonCollectionViewCell.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyLocationHorizonCollectionViewCell.h"
#import "PLVerticalCollectionFlowLayout.h"
#import "PLLobbyLocationVerticalCollectionHeaderView.h"
#import "PLLobbyVerticalCollectionHeaderView.h"
#import "PLLobbyVerticalCollectionFooterView.h"
#import "PLLobbyVerticalCollectionViewCell.h"
#import "PLRefreshControl.h"

static NSString * const lobbyLocationVerticalCollectionHeaderViewID = @"lobbyLocationVerticalCollectionHeaderViewID";
static NSString * const lobbyLocationVerticalCollectionFooterViewID = @"lobbyLocationVerticalCollectionFooterViewID";
static CGFloat const lobbyLocationVerticalCollectionHeaderViewHeight = 48;

@interface PLLobbyLocationHorizonCollectionViewCell ()<PLLobbyLocationVerticalCollectionHeaderViewDelegate>

@property (nonatomic,strong) PLLobbyLocationVerticalCollectionHeaderView *headerRV;

@end

@implementation PLLobbyLocationHorizonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headerRV]; // 用于预加载
    }
    return self;
}

#pragma mark - uitl

-(CGFloat)footerViewHeightForRequestFail
{
    return SCREEN_HEIGHT - kStatusBarHeight - kNavigationBarHeight - kTabbarHeight - lobbyLocationVerticalCollectionHeaderViewHeight + 1;
}

#pragma mark - PLLobbyLocationVerticalCollectionHeaderViewDelegate
/*
 *通知省份菜单是否展示
*/
-(void)provinceTableShowStatusChangeTo:(BOOL)isShow
{
    if (isShow) {
        self.lobbyVerticalCollectionView.scrollEnabled = NO;
    }else{
        self.lobbyVerticalCollectionView.scrollEnabled = YES;
    }
}
/*
 *获取列表是否在刷新
 */
-(BOOL)isRefreshOfRefreshControl
{
    return self.viewLobbyVerticalBack.refreshControl.refreshState == EnumRefreshStateBeginRefresh;
}

#pragma mark - UICollectionView delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, lobbyLocationVerticalCollectionHeaderViewHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PLLobbyVerticalCollectionHeaderView * headerBackRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lobbyLocationVerticalCollectionHeaderViewID forIndexPath:indexPath];
        [self.headerRV reloadWithLiveLocationCategoryManager:(LiveLocationCategoryManager *)self.liveCategoryManager];
        [headerBackRV addSubview:self.headerRV];
        return headerBackRV;
    }else if(kind == UICollectionElementKindSectionFooter)
    {
        PLLobbyVerticalCollectionFooterView * footerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lobbyLocationVerticalCollectionFooterViewID forIndexPath:indexPath];
        footerRV.lblFailConnect.centerY = [self footerViewHeightForRequestFail]/2 -  lobbyLocationVerticalCollectionHeaderViewHeight/2;
        footerRV.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
        return footerRV;
    }else{
        return nil;
    }
}

#pragma mark - getter

-(UICollectionViewFlowLayout *)lobbyVerticalCollectionViewFlowLayout
{
    if (!_lobbyVerticalCollectionViewFlowLayout) {
        _lobbyVerticalCollectionViewFlowLayout = [[PLVerticalCollectionFlowLayout alloc]init]; //设置flowLayout的类型PLVerticalCollectionFlowLayout
        _lobbyVerticalCollectionViewFlowLayout.minimumLineSpacing = .1f;
        _lobbyVerticalCollectionViewFlowLayout.minimumInteritemSpacing = .1f;
        _lobbyVerticalCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _lobbyVerticalCollectionViewFlowLayout;
}

-(UICollectionView *)lobbyVerticalCollectionView
{
    if (!_lobbyVerticalCollectionView) {
        _lobbyVerticalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT) collectionViewLayout:self.lobbyVerticalCollectionViewFlowLayout];
        if (@available(iOS 11.0, *)){
            _lobbyVerticalCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _lobbyVerticalCollectionView.backgroundColor = [UIColor clearColor];
        _lobbyVerticalCollectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight + kStatusBarHeight, 0, kTabbarHeight, 0);
        _lobbyVerticalCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavigationBarHeight + kStatusBarHeight, 0, kTabbarHeight, 0);
        _lobbyVerticalCollectionView.showsHorizontalScrollIndicator = NO;
        _lobbyVerticalCollectionView.showsVerticalScrollIndicator = YES;
        _lobbyVerticalCollectionView.dataSource = self;
        _lobbyVerticalCollectionView.delegate = self;
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionViewCell class] forCellWithReuseIdentifier:lobbyVerticalCollectionViewCellID];
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:lobbyLocationVerticalCollectionHeaderViewID];
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:lobbyLocationVerticalCollectionFooterViewID];
    }
    return _lobbyVerticalCollectionView;
}

-(PLLobbyLocationVerticalCollectionHeaderView *)headerRV
{
    if (!_headerRV) {
        _headerRV = [[PLLobbyLocationVerticalCollectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lobbyLocationVerticalCollectionHeaderViewHeight)];
        _headerRV.delegate = self;
    }
    return _headerRV;
}


@end
