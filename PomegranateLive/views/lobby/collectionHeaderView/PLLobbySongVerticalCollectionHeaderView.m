//
//  PLLobbySongVerticalCollectionHeaderView.m
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbySongVerticalCollectionHeaderView.h"
#import "PLSongCategoryButton.h"

static CGFloat const kSongCategoryButtonBorderWidth = .5f;
static CGFloat const kMarginOfLineWithParentEdge = 10.f;
#define SONG_CATEGORY_BUTTON_WIDTH ((SCREEN_WIDTH - 2 * kSongCategoryButtonBorderWidth)/3)
#define SONG_CATEGORY_BUTTON_HEIGHT ((self.height - 3 * kSongCategoryButtonBorderWidth)/2)

@interface PLLobbySongVerticalCollectionHeaderView ()<LiveSongCategoryManagerDelegate>

@property (nonatomic,strong) NSMutableArray<PLSongCategoryButton *> * arrSongCategoryButton;

@end

@implementation PLLobbySongVerticalCollectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame andLiveSongCategoryManager:(LiveSongCategoryManager *)liveSongCategoryManager
{
    self = [super initWithFrame:frame];
    if (self) {
        self.liveSongCategoryManager = liveSongCategoryManager;
        liveSongCategoryManager.songDelegate = self;
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    self.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
    
    for (int i = 0; i < self.liveSongCategoryManager.arrSongLiveCategoryModel.count; i ++) {
        NSInteger XIndex = i%3;
        NSInteger YIndex = i/3.f;
        //按钮对象装到数组和字典中
        PLSongCategoryButton * songCategoryButton = [[PLSongCategoryButton alloc]init];
        songCategoryButton.liveCategoryModel = self.liveSongCategoryManager.arrSongLiveCategoryModel[i];
        [self.arrSongCategoryButton addObject:songCategoryButton];
        [self.dicLiveSongCategoryButton setObject:songCategoryButton forKey:songCategoryButton.liveCategoryModel.categoryTypeCode];
        
        //按钮Frame设置
        songCategoryButton.originX = XIndex * (SONG_CATEGORY_BUTTON_WIDTH + kSongCategoryButtonBorderWidth);
        songCategoryButton.originY = YIndex * (SONG_CATEGORY_BUTTON_HEIGHT + kSongCategoryButtonBorderWidth) + kSongCategoryButtonBorderWidth;
        songCategoryButton.size = CGSizeMake(SONG_CATEGORY_BUTTON_WIDTH, SONG_CATEGORY_BUTTON_HEIGHT);

        songCategoryButton.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
        [self addSubview:songCategoryButton];
        
        [songCategoryButton addTarget:self action:@selector(songCategoryButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.liveSongCategoryManager.selectedSongCategoryModel.categoryTypeCode isEqualToString:songCategoryButton.liveCategoryModel.categoryTypeCode]) {
            songCategoryButton.selected = YES;
        }
    }
    
    //处理划线左右细节
    int i = 1;
    UIView * viewLeftShawLine = [[UIView alloc]initWithFrame:CGRectMake(0, i * (SONG_CATEGORY_BUTTON_HEIGHT + kSongCategoryButtonBorderWidth), kMarginOfLineWithParentEdge, kSongCategoryButtonBorderWidth)];
    viewLeftShawLine.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self addSubview:viewLeftShawLine];
    
    UIView * viewRightShawLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - kMarginOfLineWithParentEdge, i * (SONG_CATEGORY_BUTTON_HEIGHT + kSongCategoryButtonBorderWidth), kMarginOfLineWithParentEdge, kSongCategoryButtonBorderWidth)];
    viewRightShawLine.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self addSubview:viewRightShawLine];
}

#pragma mark - LiveSongCategoryManagerDelegate

-(void)selectSoncategoryButtonWithSongLiveCategoryModel:(SongLiveCategoryModel *)liveCategoryModel
{
    PLSongCategoryButton * songCategoryButton = self.dicLiveSongCategoryButton[liveCategoryModel.categoryTypeCode];
    [self selectSongCatgoryButton:songCategoryButton];
}

#pragma mark - click method

-(void)songCategoryButtonOnClick:(PLSongCategoryButton *)songCategoryButton
{
    [self selectSongCatgoryButton:songCategoryButton];
    [self.liveSongCategoryManager reloadLiveRoomInfoListWithLiveCategoryModel:songCategoryButton.liveCategoryModel];
}

#pragma mark - uitl

/**
 * 选中一个按钮
 */
-(void)selectSongCatgoryButton:(PLSongCategoryButton *)songCategoryButton
{
    for (PLSongCategoryButton * cateButton in self.arrSongCategoryButton) {
        cateButton.selected = NO;
    }
    songCategoryButton.selected = YES;
}

#pragma mark - getter

-(NSMutableArray<PLSongCategoryButton *> *)arrSongCategoryButton
{
    if (!_arrSongCategoryButton) {
        _arrSongCategoryButton = [[NSMutableArray alloc]init];
    }
    return _arrSongCategoryButton;
}

-(NSMutableDictionary *)dicLiveSongCategoryButton
{
    if (!_dicLiveSongCategoryButton) {
        _dicLiveSongCategoryButton = [[NSMutableDictionary alloc]init];
    }
    return _dicLiveSongCategoryButton;
}

@end
