//
//  PLLobbyHorizonCollectionViewCell.m
//  PomegranateLive
//
//  Created by CKK on 17/2/22.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyHorizonCollectionViewCell.h"
#import "PLLobbyVerticalCollectionViewCell.h"
#import "LiveRoomInfoModel.h"
#import "PLRefreshControl.h"
#import "PLLobbyVerticalCollectionFooterView.h"

static CGFloat const lobbyVerticalCollectionViewCellInterval = 1.f;
static NSString * const lobbyVerticalCollectionFooterViewID = @"lobbyVerticalCollectionFooterViewID";

@interface PLLobbyHorizonCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LiveCategoryManagerDelegate>

@property (nonatomic) CGFloat footerViewHeight;
@property (nonatomic,strong) NSMutableArray<LiveRoomInfoModel *> * arrLiveRoomInfoModel;

@end

@implementation PLLobbyHorizonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.viewLobbyVerticalBack];
        [self addSubview:self.lobbyVerticalCollectionView];
    }
    return self;
}

#pragma mark - uitl

-(CGFloat)footerViewHeightForRequestFail
{
    return SCREEN_HEIGHT - kStatusBarHeight - kNavigationBarHeight - kTabbarHeight + 1;
}

#pragma mark - refresh method

-(void)updateDataSource
{
    [self.liveCategoryManager reloadLiveRoomInfoList];
}

#pragma mark - LiveCategoryManagerDelegate

-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager startRequestWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (liveCategoryManager != self.liveCategoryManager) {
        return;
    }
    self.footerViewHeight = 0;
    self.arrLiveRoomInfoModel = arrLiveRoomInfoModel;
    [self.lobbyVerticalCollectionView reloadData];
    if (arrLiveRoomInfoModel.count > 0) {
        [self.viewLobbyVerticalBack.refreshControl startRefresh];
        [self.viewLobbyVerticalBack.backViewCenterRefreshIndicatorView stopAnimating];
    }else{
        self.viewLobbyVerticalBack.refreshControl.hidden = YES;
        [self.viewLobbyVerticalBack.backViewCenterRefreshIndicatorView startAnimating];
        [self.liveCategoryManager reloadLiveRoomInfoList];
    }
}

-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager reloadLiveRoomInfoListUIWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (liveCategoryManager != self.liveCategoryManager) {
        return;
    }
    self.footerViewHeight = 0;
    [self.viewLobbyVerticalBack.refreshControl endRefresh];
    self.arrLiveRoomInfoModel = arrLiveRoomInfoModel;
    [self.lobbyVerticalCollectionView reloadData];
    
    if (arrLiveRoomInfoModel.count > 0) {
        [self.viewLobbyVerticalBack.backViewCenterRefreshIndicatorView stopAnimating];
    }else{
        self.viewLobbyVerticalBack.refreshControl.hidden = YES;
        [self.viewLobbyVerticalBack.backViewCenterRefreshIndicatorView startAnimating];
    }
}

-(void)liveCategoryManager:(LiveCategoryManager *)liveCategoryManager requestFailedWithDataSource:(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (liveCategoryManager != self.liveCategoryManager) {
        return;
    }
    [self.viewLobbyVerticalBack.refreshControl endRefresh];
    [self.viewLobbyVerticalBack.backViewCenterRefreshIndicatorView stopAnimating];
    if (self.arrLiveRoomInfoModel.count == 0) {
        self.footerViewHeight = [self footerViewHeightForRequestFail];
        [self.lobbyVerticalCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrLiveRoomInfoModel.count%2 == 0 ? self.arrLiveRoomInfoModel.count : self.arrLiveRoomInfoModel.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLLobbyVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lobbyVerticalCollectionViewCellID forIndexPath:indexPath];
    LiveRoomInfoModel * liveRoomInfoModel = self.arrLiveRoomInfoModel[indexPath.row];
    [cell reloadDataWithRoomInfoModel:liveRoomInfoModel];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellwidth = (SCREEN_WIDTH - lobbyVerticalCollectionViewCellInterval)/2;
    return CGSizeMake( cellwidth , cellwidth + lobbyVerticalCollectionViewCellInterval);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, self.footerViewHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionFooter)
    {
        PLLobbyVerticalCollectionFooterView * footerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:lobbyVerticalCollectionFooterViewID forIndexPath:indexPath];
        footerRV.lblFailConnect.centerY = footerRV.centerY;
        footerRV.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
        return footerRV;
    }else{
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveRoomInfoModel * liveRoomInfoModel = self.arrLiveRoomInfoModel[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(lobbyVerticalCollectionViewSelectItemModel:)]) {
        [self.delegate lobbyVerticalCollectionViewSelectItemModel:liveRoomInfoModel];
    }
}
#pragma mark - setter

-(void)setLiveCategoryManager:(LiveCategoryManager *)liveCategoryManager
{
    _liveCategoryManager = liveCategoryManager;
    _liveCategoryManager.delegate = self;
    [liveCategoryManager reloadSelectedCategoryItem];
}

#pragma mark - getter

-(UICollectionView *)lobbyVerticalCollectionView
{
    if (!_lobbyVerticalCollectionView) {
        _lobbyVerticalCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT) collectionViewLayout:self.lobbyVerticalCollectionViewFlowLayout];
        _lobbyVerticalCollectionView.backgroundColor = [UIColor clearColor];
        _lobbyVerticalCollectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight + kStatusBarHeight, 0, kTabbarHeight, 0);
        _lobbyVerticalCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavigationBarHeight + kStatusBarHeight, 0, kTabbarHeight, 0);
        _lobbyVerticalCollectionView.showsHorizontalScrollIndicator = NO;
        _lobbyVerticalCollectionView.showsVerticalScrollIndicator = YES;
        _lobbyVerticalCollectionView.dataSource = self;
        _lobbyVerticalCollectionView.delegate = self;
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionViewCell class] forCellWithReuseIdentifier:lobbyVerticalCollectionViewCellID];
        [_lobbyVerticalCollectionView registerClass:[PLLobbyVerticalCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:lobbyVerticalCollectionFooterViewID];
    }
    return _lobbyVerticalCollectionView;
}

-(UICollectionViewFlowLayout *)lobbyVerticalCollectionViewFlowLayout
{
    if (!_lobbyVerticalCollectionViewFlowLayout) {
        _lobbyVerticalCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _lobbyVerticalCollectionViewFlowLayout.minimumLineSpacing = .1f;
        _lobbyVerticalCollectionViewFlowLayout.minimumInteritemSpacing = .1f;
        _lobbyVerticalCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _lobbyVerticalCollectionViewFlowLayout;
}

-(NSMutableArray<LiveRoomInfoModel *> *)arrLiveRoomInfoModel
{
    if (!_arrLiveRoomInfoModel) {
        _arrLiveRoomInfoModel = [[NSMutableArray alloc]init];
    }
    return _arrLiveRoomInfoModel;
}

-(PLLobbyVerticalCollectionBackgroundView *)viewLobbyVerticalBack
{
    if (!_viewLobbyVerticalBack) {
        _viewLobbyVerticalBack = [[PLLobbyVerticalCollectionBackgroundView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _viewLobbyVerticalBack.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
        _viewLobbyVerticalBack.lobbyVerticalCollectionView = self.lobbyVerticalCollectionView;
        [_viewLobbyVerticalBack.refreshControl addTarget:self action:@selector(updateDataSource) forControlEvents:UIControlEventValueChanged];
    }
    return _viewLobbyVerticalBack;
}

-(CGFloat)footerViewHeight
{
    if (!_footerViewHeight) {
        _footerViewHeight = 0;
    }
    return _footerViewHeight;
}

@end

@implementation PLLobbyVerticalCollectionBackgroundView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.refreshControl];
        self.backViewCenterRefreshIndicatorView.center = self.center;
        [self addSubview:self.backViewCenterRefreshIndicatorView];
        [self.backViewCenterRefreshIndicatorView startAnimating];
    }
    return self;
}

#pragma mark - setter

-(void)setLobbyVerticalCollectionView:(UICollectionView *)lobbyVerticalCollectionView
{
    if (_lobbyVerticalCollectionView != lobbyVerticalCollectionView) {
        _lobbyVerticalCollectionView = lobbyVerticalCollectionView;
        self.refreshControl.currentScrollView = lobbyVerticalCollectionView;
    }
}

#pragma mark - getter

-(PLRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[PLRefreshControl alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _refreshControl.hidden = YES;
    }
    return _refreshControl;
}

-(UIActivityIndicatorView *)backViewCenterRefreshIndicatorView{
    
    if (!_backViewCenterRefreshIndicatorView) {
        _backViewCenterRefreshIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _backViewCenterRefreshIndicatorView;
}



@end
