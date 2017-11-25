//
//  PLLiveCategoryListBar.m
//  PomegranateLive
//
//  Created by CKK on 17/2/21.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLiveCategoryListBar.h"
#import "LiveCategoryManager.h"

static NSString * const liveCategoryListBarCellID = @"liveCategoryListBarCellID";
static CGFloat const kviewIndicatorHeight = 1.5f;
static CGFloat const kMarginForIndicatorWithCellEdge = 20.f; //指示线之间与cell边距
static CGFloat const kIndicatorAndListbarBottomInterval = 8.f;
static NSInteger const kFontSizeOfSelectedItemTitle = 15;
static NSInteger const kFontSizeOfNormalItemTitle = 14;

@interface PLLiveCategoryListBar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray<LiveCategoryManager *> * arrLiveCategoryManager;
@property (nonatomic,strong) UICollectionViewFlowLayout * mainCollectionViewFlowLayout;
@property (nonatomic,strong) UIView * viewIndicator;

@property (nonatomic) NSInteger seletedIndex;

@end

@implementation PLLiveCategoryListBar

- (instancetype)initWithFrame:(CGRect)frame andMainDataSource:(NSMutableArray<LiveCategoryManager *> *)arrLiveCategoryManager
{
    self = [super initWithFrame:frame collectionViewLayout:self.mainCollectionViewFlowLayout];
    if (self) {
        self.arrLiveCategoryManager = arrLiveCategoryManager;
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    self.backgroundColor = [UIColor clearColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[PLLiveCategoryListBarCell class] forCellWithReuseIdentifier:liveCategoryListBarCellID];
    [self addSubview:self.viewIndicator];
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrLiveCategoryManager.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PLLiveCategoryListBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:liveCategoryListBarCellID forIndexPath:indexPath];
    LiveCategoryManager * liveCategoryManager = self.arrLiveCategoryManager[indexPath.row];
    [cell reloadDataWithCategoryName:liveCategoryManager.liveCategoryModel.categoryName isSelected:(self.seletedIndex == indexPath.row)];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = [self indicatorWidthForItemAtIndex:indexPath.row] + 2 * kMarginForIndicatorWithCellEdge;
    return CGSizeMake(cellWidth, self.height);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([self.listBardelegate respondsToSelector:@selector(liveCategoryListBarShouldSelectItemAtIndex:)]) {
        [self.listBardelegate liveCategoryListBarShouldSelectItemAtIndex:indexPath.row];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.listBardelegate respondsToSelector:@selector(liveCategoryListBarDidSelectItemAtIndex:)]) {
        [self.listBardelegate liveCategoryListBarDidSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark -uitl

-(void)listBarSelectItemAtIndex:(NSInteger)index
{
    self.seletedIndex = index;
    [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self reloadData];
}

-(CGFloat)indicatorWidthForItemAtIndex:(NSInteger)index
{
    NSInteger itemIndex = index < self.arrLiveCategoryManager.count ? index:self.arrLiveCategoryManager.count - 1;
    LiveCategoryManager * liveCategoryManager = self.arrLiveCategoryManager[itemIndex];
    NSDictionary *attrs=@{NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeOfSelectedItemTitle]};
    CGSize  size = [liveCategoryManager.liveCategoryModel.categoryName sizeWithAttributes:attrs];
    return size.width;
}

-(CGFloat)indicatorOriginXForItemAtIndex:(NSInteger)index
{
    NSInteger itemIndex = index < self.arrLiveCategoryManager.count ? index:self.arrLiveCategoryManager.count - 1;
    CGFloat cellOrginX = 0;
    for (int i = 0; i < itemIndex; i ++) {
        cellOrginX += [self indicatorWidthForItemAtIndex:i] + 2 * kMarginForIndicatorWithCellEdge;
    }
    CGFloat indicatorOriginX = cellOrginX + kMarginForIndicatorWithCellEdge;
    return indicatorOriginX;
}

-(void)indicatorMoveFollowScrollview:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.width;
    int itemIndex = scrollView.contentOffset.x < 0 ? 0 : scrollView.contentOffset.x / pageWidth;
    CGFloat rate = ((int)scrollView.contentOffset.x % (int)pageWidth) / pageWidth;
    
    CGFloat leftIndicatorWidth = [self indicatorWidthForItemAtIndex:itemIndex];
    CGFloat rightIndicatorWidth = [self indicatorWidthForItemAtIndex:itemIndex + 1];
    CGFloat indicatorWidth = leftIndicatorWidth + (rightIndicatorWidth -leftIndicatorWidth) * rate;
    indicatorWidth = scrollView.contentOffset.x < 0 ? leftIndicatorWidth : indicatorWidth;
    self.viewIndicator.bounds = CGRectMake(0, 0, indicatorWidth, kviewIndicatorHeight);
    
    CGFloat leftIndicatorOriginX = [self indicatorOriginXForItemAtIndex:itemIndex];
    CGFloat rightIndicatorOriginX = [self indicatorOriginXForItemAtIndex:itemIndex + 1];
    CGFloat indicatorOriginX = leftIndicatorOriginX + (rightIndicatorOriginX - leftIndicatorOriginX) * rate;
    indicatorOriginX = scrollView.contentOffset.x < 0 ? leftIndicatorOriginX : indicatorOriginX;
    self.viewIndicator.origin = CGPointMake(indicatorOriginX, self.viewIndicator.origin.y);

}

#pragma mark - getter

-(UICollectionViewFlowLayout *)mainCollectionViewFlowLayout
{
    if (!_mainCollectionViewFlowLayout) {
        _mainCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _mainCollectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _mainCollectionViewFlowLayout.minimumInteritemSpacing = 0.01f;
        _mainCollectionViewFlowLayout.minimumLineSpacing = 0.01f;
    }
    return _mainCollectionViewFlowLayout;
}

-(UIView *)viewIndicator
{
    if (!_viewIndicator) {
        _viewIndicator = [[UIView alloc]init];
        _viewIndicator.backgroundColor = [UIColor whiteColor];
        _viewIndicator.bounds = CGRectMake(0, 0, [self indicatorWidthForItemAtIndex:0], kviewIndicatorHeight);
        _viewIndicator.origin = CGPointMake([self indicatorOriginXForItemAtIndex:0], self.height - kviewIndicatorHeight - kIndicatorAndListbarBottomInterval);
    }
    return _viewIndicator;
}

@end

@implementation PLLiveCategoryListBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lblCategoryName];
    }
    return self;
}

-(void)reloadDataWithCategoryName:(NSString *)categoryName isSelected:(BOOL)isSelected
{
    self.lblCategoryName.frame = self.bounds;
    self.lblCategoryName.text = categoryName;
    if (isSelected) {
        self.isSelected = YES;
        self.lblCategoryName.font = [UIFont systemFontOfSize:kFontSizeOfSelectedItemTitle];
        self.lblCategoryName.textColor = [UIColor whiteColor];
    }else{
        self.isSelected = NO;
        self.lblCategoryName.font = [UIFont systemFontOfSize:kFontSizeOfNormalItemTitle];
        self.lblCategoryName.textColor = [UIColor colorWithRed:0.94f green:0.69f blue:0.67f alpha:1.00f];
    }
}

-(UILabel *)lblCategoryName
{
    if (!_lblCategoryName) {
        _lblCategoryName = [[UILabel alloc]initWithFrame:self.bounds];
        _lblCategoryName.backgroundColor = [UIColor clearColor];
        _lblCategoryName.textAlignment = NSTextAlignmentCenter;
        _lblCategoryName.textColor = [UIColor colorWithRed:0.94f green:0.69f blue:0.67f alpha:1.00f];
        _lblCategoryName.font = [UIFont systemFontOfSize:kFontSizeOfNormalItemTitle];
    }
    return _lblCategoryName;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (self.isSelected) {
        return;
    }
    if (highlighted) {
        self.lblCategoryName.textColor = [UIColor whiteColor];
    }else{
        self.lblCategoryName.textColor = [UIColor colorWithRed:0.94f green:0.69f blue:0.67f alpha:1.00f];
    }
}

@end

