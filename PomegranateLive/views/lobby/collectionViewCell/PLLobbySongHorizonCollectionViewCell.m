//
//  PLLobbySongHorizonCollectionViewCell.m
//  PomegranateLive
//
//  Created by CKK on 17/2/23.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbySongHorizonCollectionViewCell.h"
#import "PLLobbySongVerticalCollectionHeaderView.h"
#import "PLLobbyVerticalCollectionHeaderView.h"
#import "PLLobbyVerticalCollectionFooterView.h"
#import "PLLobbyVerticalCollectionViewCell.h"
#import "LiveLocationCategoryManager.h"

static NSString * const lobbySongVerticalCollectionHeaderViewID = @"lobbySongVerticalCollectionHeaderViewID";
static NSString * const lobbySongVerticalCollectionFooterViewID = @"lobbySongVerticalCollectionFooterViewID";
static CGFloat const lobbySongVerticalCollectionHeaderViewHeight = 81.5f;

@interface PLLobbySongHorizonCollectionViewCell ()

@property (nonatomic,strong) PLLobbySongVerticalCollectionHeaderView *headerRV;

@end

@implementation PLLobbySongHorizonCollectionViewCell

-(void)initHeaderViewWithLiveSongCategoryManager:(LiveSongCategoryManager *)liveSongCategoryManager
{
    self.liveCategoryManager = liveSongCategoryManager;
    [self headerRV];
}

#pragma mark - uitl

-(CGFloat)footerViewHeightForRequestFail
{
    return SCREEN_HEIGHT - kStatusBarHeight - kNavigationBarHeight - kTabbarHeight - lobbySongVerticalCollectionHeaderViewHeight + 1;
}

#pragma mark - UICollectionView delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, lobbySongVerticalCollectionHeaderViewHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PLLobbyVerticalCollectionHeaderView * headerBackRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lobbySongVerticalCollectionHeaderViewID forIndexPath:indexPath];
        [headerBackRV addSubview:self.headerRV];
        return headerBackRV;
    }else if(kind == UICollectionElementKindSectionFooter)
    {
        PLLobbyVerticalCollectionFooterView * footerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lobbySongVerticalCollectionFooterViewID forIndexPath:indexPath];
        footerRV.lblFailConnect.centerY = [self footerViewHeightForRequestFail]/2 -  lobbySongVerticalCollectionHeaderViewHeight/2;
        footerRV.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
        return footerRV;
    }else{
        return nil;
    }
}

#pragma mark - getter

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
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:lobbySongVerticalCollectionHeaderViewID];
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:lobbySongVerticalCollectionFooterViewID];
    }
    return _lobbyVerticalCollectionView;
}

-(PLLobbySongVerticalCollectionHeaderView *)headerRV
{
    if (!_headerRV) {
        _headerRV = [[PLLobbySongVerticalCollectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lobbySongVerticalCollectionHeaderViewHeight) andLiveSongCategoryManager:(LiveSongCategoryManager *)self.liveCategoryManager];
    }
    return _headerRV;
}


@end
