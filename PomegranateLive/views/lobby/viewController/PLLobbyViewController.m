//
//  PLLobbyViewController.m
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyViewController.h"
#import "PLLobbyNavigationView.h"
#import "LiveCategoryManager.h"
#import "LiveLocationCategoryManager.h"
#import "LiveSongCategoryManager.h"
#import "PLLobbyHorizonCollectionViewCell.h"
#import "PLLobbyLocationHorizonCollectionViewCell.h"
#import "PLLobbySongHorizonCollectionViewCell.h"
#import "PLLiveListMenuView.h"
static NSString * const lobbyHorizonCollectionViewCellID = @"lobbyHorizonCollectionViewCellID";
static NSString * const lobbyLocationHorizonCollectionViewCellID = @"lobbyLocationHorizonCollectionViewCellID";
static NSString * const lobbySongHorizonCollectionViewCellID = @"lobbySongHorizonCollectionViewCellID";
static CGFloat const kMarginForLobbyHorizonCells = 10.f;

@interface PLLobbyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PLLiveCategoryListBarDelegate,PLLobbyHorizonCollectionViewCellDelegate,PLLiveListMenuViewDelegate>

//自定义navigationView
@property (nonatomic,strong) PLLobbyNavigationView * lobbyNavigationView;
//分类管理器数组
@property (nonatomic,strong) NSMutableArray<LiveCategoryManager *> * arrLivecategoryManager;


//横向滚动collectionView
@property (nonatomic,strong) UICollectionView * lobbyHorizonCollectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * lobbyHorizonCollectionViewFlowLayout;

//navigationView右侧按钮点击弹出View
@property (nonatomic,strong) PLLiveListMenuView * liveListMenuView;

@end

@implementation PLLobbyViewController
{
    BOOL _isLobbyHorizonCollectionViewScroll;
    NSInteger _selectedItemIndex;
}

#pragma - life cycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self UIConfig];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - views Init

-(void)UIConfig
{
    self.lobbyHorizonCollectionView.origin = CGPointMake(0, 0);
    [self.view addSubview:self.lobbyHorizonCollectionView];
    
    self.lobbyNavigationView.origin = CGPointMake(0, 0);
    [self.view addSubview:self.lobbyNavigationView];
    
    PLLobbyHorizonCollectionViewCell *cell = [self.lobbyHorizonCollectionView dequeueReusableCellWithReuseIdentifier:lobbyHorizonCollectionViewCellID forIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    cell.delegate = self;
    cell.liveCategoryManager = self.arrLivecategoryManager[0];
    [cell.liveCategoryManager checkUpdateWhenCategotyItemSelected]; //请求首页数据
    
    [_lobbyHorizonCollectionView dequeueReusableCellWithReuseIdentifier:lobbyLocationHorizonCollectionViewCellID forIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];// 用于预加载
    PLLobbySongHorizonCollectionViewCell * songCell = [_lobbyHorizonCollectionView dequeueReusableCellWithReuseIdentifier:lobbySongHorizonCollectionViewCellID forIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];// 用于预加载
    LiveSongCategoryManager * songCategoryManager = [self songCategoryManager];
    if (songCategoryManager) {
        [songCell initHeaderViewWithLiveSongCategoryManager:songCategoryManager]; //预加载好声音headerview
    }
}

#pragma mark - uitl

- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}

-(LiveSongCategoryManager *)songCategoryManager
{
    LiveSongCategoryManager * songCategoryManager;
    for (LiveCategoryManager * categoryManager in self.arrLivecategoryManager) {
        if ([categoryManager isKindOfClass:[LiveSongCategoryManager class]]) {
            songCategoryManager = (id)categoryManager;
        }
    }
    return songCategoryManager;
}

#pragma mark - click method

-(void)btnRightBarButtonItemOnClick:(UIButton *)button
{
    if (_isLobbyHorizonCollectionViewScroll) {
        return;
    }
    button.selected = YES;
    self.liveListMenuView.selectedCategoryItemIndex = _selectedItemIndex;
    [self.liveListMenuView liveListMenuViewShowInView:self.navigationController.view];
}

-(void)btnLeftbarButtonItemOnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (!button.selected) {
        [self showTabBar];
    }else{
        [self hideTabBar];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrLivecategoryManager.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCategoryManager * liveCategoryManager = self.arrLivecategoryManager[indexPath.row];
    
    NSString * cellid = lobbyHorizonCollectionViewCellID;
    if ([liveCategoryManager.liveCategoryModel.categoryTypeCode isEqualToString:@"location"]) { //附近
        cellid = lobbyLocationHorizonCollectionViewCellID;
    }else if([liveCategoryManager.liveCategoryModel.categoryTypeCode isEqualToString:@"u0"]){//好声音
        cellid = lobbySongHorizonCollectionViewCellID;
    }
    PLLobbyHorizonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    cell.delegate = self;
    cell.liveCategoryManager = liveCategoryManager;
    
    return cell;
}

#pragma mark - PLLobbyHorizonCollectionViewCellDelegate
/**
 *  collectionViewCell 点击回调
 *
 *  @param liveRoomInfoModel liveRoomInfoModel
 */
-(void)lobbyVerticalCollectionViewSelectItemModel:(LiveRoomInfoModel *)liveRoomInfoModel
{
    NSString * userName = liveRoomInfoModel.username.length > 0 ? liveRoomInfoModel.username:liveRoomInfoModel.alias;
    UIAlertView * itemSelectAlerView = [[UIAlertView alloc]initWithTitle:@"用户名" message:userName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [itemSelectAlerView show];
}

#pragma mark - PLLiveCategoryListBarDelegate

/**
 *  将要选中一个分类回调
 *
 *  @param itemIndex 选中Item的index
 */
-(void)liveCategoryListBarShouldSelectItemAtIndex:(NSInteger)itemIndex
{
    _selectedItemIndex = itemIndex;
}
/**
 *  点击选中一个分类回调
 *
 *  @param itemIndex 选中Item的index
 */
-(void)liveCategoryListBarDidSelectItemAtIndex:(NSInteger)itemIndex
{
    _selectedItemIndex = itemIndex;
    [self.lobbyHorizonCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
#pragma mark - PLLiveListMenuViewDelegate

-(void)closeMenuView
{
    self.lobbyNavigationView.btnRightBarButtonItem.selected = NO;
}

/**
 *  menu 选中回调
 *
 *  @param itemIndex 选中的分栏index
 */
-(void)liveListMenuViewDidSelectItemIndex:(NSInteger)itemIndex
{
    [self.lobbyHorizonCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - scrollview delegate

/**
 *  横向滚动collectionView 滚动时，分类列表的指示下划线跟随滚动
 *
 *  @param scrollView 横向滚动collectionView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isLobbyHorizonCollectionViewScroll = YES;
    [self.lobbyNavigationView.liveCategoryListBar indicatorMoveFollowScrollview:scrollView];
}
/**
 *  横线滚动结束选中一个 分类Item
 *
 *  @param scrollView 横向滚动collectionView
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isLobbyHorizonCollectionViewScroll = NO;
    _selectedItemIndex = (scrollView.contentOffset.x + scrollView.width * 0.5) / scrollView.width;
    [self.lobbyNavigationView.liveCategoryListBar listBarSelectItemAtIndex:_selectedItemIndex];
    [self.arrLivecategoryManager[_selectedItemIndex] checkUpdateWhenCategotyItemSelected];
}

/**
 *  正好drag到srollview刚停止的地方
 *
 *  @param scrollView 横向滚动collectionView
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    [self scrollViewDidEndDecelerating:scrollView];

}

#pragma mark - getter

-(PLLobbyNavigationView *)lobbyNavigationView
{
    if (!_lobbyNavigationView) {
        _lobbyNavigationView = [[PLLobbyNavigationView alloc]initWithMainDataSource:self.arrLivecategoryManager];
        _lobbyNavigationView.liveCategoryListBar.listBardelegate = self;
        [_lobbyNavigationView.btnRightBarButtonItem addTarget:self action:@selector(btnRightBarButtonItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lobbyNavigationView.btnLeftbarButtonItem addTarget:self action:@selector(btnLeftbarButtonItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lobbyNavigationView;
}

-(NSMutableArray *)arrLivecategoryManager
{
    if (!_arrLivecategoryManager) {
        _arrLivecategoryManager = [[NSMutableArray alloc]init];
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"lobbyLiveListCategory" ofType:@"plist"];
        NSArray * arrLiveListCategoryDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];//从plist文件中取出数据装填到manager数组中
        if (arrLiveListCategoryDic.count > 0) {
            for (NSDictionary * dicLiveListCategory in arrLiveListCategoryDic) {
                LiveCategoryModel * liveCategoryModel = [[LiveCategoryModel alloc]initWithDictionary:dicLiveListCategory];
                Class categoryManagerClass = [LiveCategoryManager class];
                if ([liveCategoryModel.categoryTypeCode isEqualToString:@"location"]) { //附近
                    categoryManagerClass = [LiveLocationCategoryManager class];
                }else if([liveCategoryModel.categoryTypeCode isEqualToString:@"u0"]){//好声音
                    categoryManagerClass = [LiveSongCategoryManager class];
                }
                LiveCategoryManager * liveCategoryManager = [[categoryManagerClass alloc]init];
                liveCategoryManager.liveCategoryModel = liveCategoryModel;
                [_arrLivecategoryManager addObject:liveCategoryManager];
            }
        }
    }
    return _arrLivecategoryManager;
}

-(UICollectionView *)lobbyHorizonCollectionView
{
    if (!_lobbyHorizonCollectionView) {
        _lobbyHorizonCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + kMarginForLobbyHorizonCells, SCREEN_HEIGHT) collectionViewLayout:self.lobbyHorizonCollectionViewFlowLayout];
        _lobbyHorizonCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, kMarginForLobbyHorizonCells);
        _lobbyHorizonCollectionView.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.95f alpha:1.00f];
        _lobbyHorizonCollectionView.pagingEnabled = YES;
        _lobbyHorizonCollectionView.showsHorizontalScrollIndicator = NO;
        _lobbyHorizonCollectionView.showsVerticalScrollIndicator = NO;
        _lobbyHorizonCollectionView.dataSource = self;
        _lobbyHorizonCollectionView.delegate = self;
        //注册cell
        [_lobbyHorizonCollectionView registerClass:[PLLobbyHorizonCollectionViewCell class] forCellWithReuseIdentifier:lobbyHorizonCollectionViewCellID];
        [_lobbyHorizonCollectionView registerClass:[PLLobbyLocationHorizonCollectionViewCell class] forCellWithReuseIdentifier:lobbyLocationHorizonCollectionViewCellID];
        [_lobbyHorizonCollectionView registerClass:[PLLobbySongHorizonCollectionViewCell class] forCellWithReuseIdentifier:lobbySongHorizonCollectionViewCellID];
    }
    return _lobbyHorizonCollectionView;
}

-(UICollectionViewFlowLayout *)lobbyHorizonCollectionViewFlowLayout
{
    if (!_lobbyHorizonCollectionViewFlowLayout) {
        _lobbyHorizonCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _lobbyHorizonCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _lobbyHorizonCollectionViewFlowLayout.minimumInteritemSpacing = .1f;
        _lobbyHorizonCollectionViewFlowLayout.minimumLineSpacing = kMarginForLobbyHorizonCells;
        _lobbyHorizonCollectionViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _lobbyHorizonCollectionViewFlowLayout;
}

-(PLLiveListMenuView *)liveListMenuView
{
    if (!_liveListMenuView) {
        _liveListMenuView = [[PLLiveListMenuView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _liveListMenuView.arrLivecategoryManager = self.arrLivecategoryManager;
        _liveListMenuView.delegate = self;
    }
    return _liveListMenuView;
}

@end
