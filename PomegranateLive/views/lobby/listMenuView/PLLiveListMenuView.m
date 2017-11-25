//
//  PLLiveListMenuView.m
//  PomegranateLive
//
//  Created by CKK on 17/2/25.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLiveListMenuView.h"

static NSString * const kLiveListMenuCollectionViewCellID = @"liveListMenuCollectionViewCellID";
static NSString * const kLiveListMenuCollectionHeaderViewID = @"liveListMenuCollectionHeaderViewID";
static NSString * const kLiveListMenuCollectionViewSectionTitle_0 = @"按表演类型分类";
static NSString * const kLiveListMenuCollectionViewSectionTitle_1 = @"按主播等级分类";
static CGFloat const kLiveListMenuCollectionViewHeight = 465.f;

@interface PLLiveListMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) LiveSongCategoryManager * songCategoryManager;
@property (nonatomic,strong) UIView * liveListMenuCollectionViewAnimationBackView;
@property (nonatomic,strong) UICollectionView * liveListMenuCollectionView;
@property (nonatomic,strong) PLVerticalCollectionFlowLayout * liveListMenuCollectionViewFlowLayout;

@property (nonatomic,strong) NSIndexPath * indexPathSelected;

@end

@implementation PLLiveListMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        [self addTarget:self action:@selector(liveListMenuViewOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    [self addSubview:self.liveListMenuCollectionViewAnimationBackView];
    [self.liveListMenuCollectionViewAnimationBackView addSubview:self.liveListMenuCollectionView];
}

#pragma mark - click method

-(void)liveListMenuViewOnClick:(UIControl *)control
{
    [self liveListMenuViewClose];
}

#pragma mark - uitl

-(void)liveListMenuViewShowInView:(UIView *)superView
{
    [superView addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    self.liveListMenuCollectionViewAnimationBackView.height = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        self.liveListMenuCollectionViewAnimationBackView.height = kLiveListMenuCollectionViewHeight;
    }];
}
/**
 *  menuView 关闭
 */
-(void)liveListMenuViewClose
{
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.liveListMenuCollectionViewAnimationBackView.height = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if ([self.delegate respondsToSelector:@selector(closeMenuView)]) {
        [self.delegate closeMenuView];
    }
}

- (void)didMoveToWindow
{
    self.indexPathSelected = [self selectedIndexPath];
    [self.liveListMenuCollectionView reloadData];
}

-(NSIndexPath *)selectedIndexPath
{
    NSIndexPath * indexPath;
    //选中的是好声音
    if ([self.arrLivecategoryManager[self.selectedCategoryItemIndex] isKindOfClass:[LiveSongCategoryManager class]] ) {
        NSInteger songCategoryIndex = [self indexOfSelectSongCategory];
        if (songCategoryIndex < 0) {
            indexPath = [NSIndexPath indexPathForItem:self.selectedCategoryItemIndex inSection:0];
        }else{
            indexPath = [NSIndexPath indexPathForItem:songCategoryIndex inSection:1];
        }
    }else{
        indexPath = [NSIndexPath indexPathForItem:self.selectedCategoryItemIndex inSection:0];
        
    }
    
    return indexPath;
}


-(NSInteger)indexOfSelectSongCategory
{
    NSInteger itemIndex = 0;
    for (int i = 0; i < self.songCategoryManager.arrSongLiveCategoryModel.count; i ++) {
        SongLiveCategoryModel * songcategoryModel = self.songCategoryManager.arrSongLiveCategoryModel[i];
        if ([self.songCategoryManager.selectedSongCategoryModel.categoryTypeCode isEqualToString:songcategoryModel.categoryTypeCode]) {
            itemIndex = i;
        }
    }
    return itemIndex - 1;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = self.songCategoryManager.arrSongLiveCategoryModel.count - 1;
    return count > 0 ? 2 : 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.arrLivecategoryManager.count;
    }else if(section == 1){
        NSInteger count = self.songCategoryManager.arrSongLiveCategoryModel.count - 1;
        return  count > 0 ? count : 0;
    }else{
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLLiveListMenuCollectionViewCell * menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:kLiveListMenuCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.section == 0) {
        menuCell.liveCategoryModel = [self.arrLivecategoryManager[indexPath.row] liveCategoryModel];
    }else if(indexPath.section == 1){
        menuCell.liveCategoryModel = self.songCategoryManager.arrSongLiveCategoryModel[indexPath.row + 1];
    }
    if ([indexPath compare:self.indexPathSelected] == NSOrderedSame || (self.indexPathSelected.section == 1 && indexPath.section == 0 && indexPath.row == [self.arrLivecategoryManager indexOfObject:self.songCategoryManager])) {
        menuCell.isSelected = YES;
        menuCell.viewCustomContent.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    }else{
        menuCell.isSelected = NO;
        menuCell.viewCustomContent.backgroundColor = [UIColor whiteColor];
    }
    
    return menuCell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        PLLiveListMenuCollectionHeaderView *headerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kLiveListMenuCollectionHeaderViewID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerRV.lblSectionTitle.text = kLiveListMenuCollectionViewSectionTitle_0;
        }else if (indexPath.section == 1){
            headerRV.lblSectionTitle.text = kLiveListMenuCollectionViewSectionTitle_1;
        }
        return headerRV;
    }else{
        return nil;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 44);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    if ([self.delegate respondsToSelector:@selector(liveListMenuViewDidSelectItemIndex:)]) {
        if (indexPath.section == 0) {
            [self.delegate liveListMenuViewDidSelectItemIndex:indexPath.row];
            if (indexPath.row == [self.arrLivecategoryManager indexOfObject:self.songCategoryManager]) {
                SongLiveCategoryModel * selectLiveCategoryModel = self.songCategoryManager.arrSongLiveCategoryModel[0];
                [self.songCategoryManager selectSongCategoryWithSongLiveCategoryModel:selectLiveCategoryModel];
            }
        }else{
            [self.delegate liveListMenuViewDidSelectItemIndex:[self.arrLivecategoryManager indexOfObject:self.songCategoryManager]];
            SongLiveCategoryModel * selectLiveCategoryModel = self.songCategoryManager.arrSongLiveCategoryModel[indexPath.row + 1];
            [self.songCategoryManager selectSongCategoryWithSongLiveCategoryModel:selectLiveCategoryModel];
        }
    }
    self.indexPathSelected = indexPath;
    [collectionView reloadData];
    [self liveListMenuViewClose];
}

#pragma mark - getter

-(UICollectionView *)liveListMenuCollectionView
{
    if (!_liveListMenuCollectionView) {
        _liveListMenuCollectionView = [[UICollectionView alloc]initWithFrame:self.liveListMenuCollectionViewAnimationBackView.bounds collectionViewLayout:self.liveListMenuCollectionViewFlowLayout];
        _liveListMenuCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 7, 0);
        _liveListMenuCollectionView.backgroundColor = [UIColor whiteColor];
        _liveListMenuCollectionView.delegate = self;
        _liveListMenuCollectionView.dataSource = self;
        [_liveListMenuCollectionView registerClass:[PLLiveListMenuCollectionViewCell class] forCellWithReuseIdentifier:kLiveListMenuCollectionViewCellID];
        [_liveListMenuCollectionView registerClass:[PLLiveListMenuCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLiveListMenuCollectionHeaderViewID];
    }
    return _liveListMenuCollectionView;
}

-(UIView *)liveListMenuCollectionViewAnimationBackView
{
    if (!_liveListMenuCollectionViewAnimationBackView) {
        _liveListMenuCollectionViewAnimationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight + kStatusBarHeight, SCREEN_WIDTH, kLiveListMenuCollectionViewHeight)];
        _liveListMenuCollectionViewAnimationBackView.clipsToBounds = YES;
    }
    return _liveListMenuCollectionViewAnimationBackView;
}

-(PLVerticalCollectionFlowLayout *)liveListMenuCollectionViewFlowLayout
{
    if (!_liveListMenuCollectionViewFlowLayout) {
        if (@available(iOS 9.0, *)){
            _liveListMenuCollectionViewFlowLayout = (id)[[UICollectionViewFlowLayout alloc]init];
            _liveListMenuCollectionViewFlowLayout.sectionHeadersPinToVisibleBounds = YES;
        }else{
            _liveListMenuCollectionViewFlowLayout = [[PLVerticalCollectionFlowLayout alloc]init];
        }
        _liveListMenuCollectionViewFlowLayout.minimumLineSpacing = .1f;
        _liveListMenuCollectionViewFlowLayout.minimumInteritemSpacing = .1f;
        _liveListMenuCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _liveListMenuCollectionViewFlowLayout.naviHeight = 0;
        _liveListMenuCollectionViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4 - .1f, SCREEN_WIDTH/4 - .1f);
    }
    return _liveListMenuCollectionViewFlowLayout;
}

-(LiveSongCategoryManager *)songCategoryManager
{
    if (!_songCategoryManager) {
        for (LiveCategoryManager * liveCategoryManager in self.arrLivecategoryManager) {
            if ([liveCategoryManager isKindOfClass:[LiveSongCategoryManager class]]) {
                _songCategoryManager = (LiveSongCategoryManager *)liveCategoryManager;
            }
        }
    }
    return _songCategoryManager;
}

@end


static CGFloat const kMarginForContentViewWithCellEdge = 12.f;

@interface PLLiveListMenuCollectionViewCell ()

@property (nonatomic,strong) UIImageView * imgViewMenuIcon;
@property (nonatomic,strong) UILabel * lblMenuTitle;

@end
@implementation PLLiveListMenuCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.viewCustomContent];
        
        self.imgViewMenuIcon.centerX = self.viewCustomContent.width/2;
        self.imgViewMenuIcon.originY = 5;
        [self.viewCustomContent addSubview:self.imgViewMenuIcon];
        
        self.lblMenuTitle.originY = self.imgViewMenuIcon.bottomY;
        self.lblMenuTitle.centerX = self.viewCustomContent.width/2;
        [self.viewCustomContent addSubview:self.lblMenuTitle];
    }
    return self;
}

-(void)setLiveCategoryModel:(LiveCategoryModel *)liveCategoryModel
{
    if (_liveCategoryModel != liveCategoryModel) {
        liveCategoryModel = liveCategoryModel;
        [self.imgViewMenuIcon setImage:[UIImage imageNamed:liveCategoryModel.menuImageName]];
        self.lblMenuTitle.text = liveCategoryModel.categoryName;
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.isSelected) {
        return;
    }
    if (highlighted) {
    self.viewCustomContent.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
    }else{
        self.viewCustomContent.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - getter

-(UIView *)viewCustomContent
{
    if (!_viewCustomContent) {
        _viewCustomContent = [[UIView alloc]initWithFrame:CGRectMake(kMarginForContentViewWithCellEdge, kMarginForContentViewWithCellEdge, self.width - 2 * kMarginForContentViewWithCellEdge, self.height - 2 * kMarginForContentViewWithCellEdge)];
        _viewCustomContent.layer.cornerRadius = 3;
        _viewCustomContent.clipsToBounds = YES;
    }
    return _viewCustomContent;
}

-(UIImageView *)imgViewMenuIcon
{
    if (!_imgViewMenuIcon) {
        _imgViewMenuIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _imgViewMenuIcon.backgroundColor = [UIColor clearColor];
    }
    return _imgViewMenuIcon;
}

-(UILabel *)lblMenuTitle
{
    if(!_lblMenuTitle){
        _lblMenuTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
        _lblMenuTitle.textColor = [UIColor colorWithRed:0.39f green:0.39f blue:0.39f alpha:1.00f];
        _lblMenuTitle.font = [UIFont systemFontOfSize:13];
        _lblMenuTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lblMenuTitle;
}

@end

static CGFloat const kMarginForSectionTitleWithCellEdge = 10.f;

@implementation PLLiveListMenuCollectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.viewLine];
        [self addSubview:self.lblSectionTitle];
    }
    return self;
}

#pragma mark - getter

-(UIView *)viewLine
{
    if (!_viewLine) {
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - .5f, SCREEN_WIDTH, .5f)];
        _viewLine.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    }
    return _viewLine;
}

-(UILabel *)lblSectionTitle
{
    if (!_lblSectionTitle) {
        _lblSectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(kMarginForSectionTitleWithCellEdge, 0, SCREEN_WIDTH - 2 * kMarginForSectionTitleWithCellEdge, self.height)];
        _lblSectionTitle.textColor = [UIColor colorWithRed:0.57f green:0.57f blue:0.57f alpha:1.00f];
        _lblSectionTitle.font = [UIFont systemFontOfSize:14];

    }
    return _lblSectionTitle;
}

@end
