//
//  PLLobbyLocationVerticalCollectionHeaderView.m
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyLocationVerticalCollectionHeaderView.h"
#import "PLLobbyHorizonCollectionViewCell.h"
#import "PLRefreshControl.h"
#import "UIImage+Extension.h"

static CGFloat const kMarginForChildWithParentEdge = 10.f;
static CGFloat const kTableViewCellSeparatorHeight = .5f;


@interface PLLobbyLocationVerticalCollectionHeaderView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) LiveLocationCategoryManager * liveLocationCategoryManager;
@property (nonatomic,strong) UIControl * backTapControl; //用来点击响应的Control
@property (nonatomic,strong) UIImageView * imgViewLocal;
@property (nonatomic,strong) UILabel * lblSelectedProvinceName;
@property (nonatomic,strong) UIImageView * imgViewLocalMenuArrow;
@property (nonatomic,strong) UIView * viewSeparatorLine; //tableViewProvince与backTapControl的分隔线
@property (nonatomic,strong) UITableView * tableViewProvince; //省份列表tableView

@end

@implementation PLLobbyLocationVerticalCollectionHeaderView
{
    CGFloat _estimatedHeaderViewHeight; //初始高度
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _estimatedHeaderViewHeight = self.height;
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    
    self.backTapControl.frame = self.bounds;
    [self addSubview:self.backTapControl];
    
    self.imgViewLocal.originX = kMarginForChildWithParentEdge;
    self.imgViewLocal.centerY = self.centerY;
    [self addSubview:self.imgViewLocal];
    
    self.lblSelectedProvinceName.originX = self.imgViewLocal.rightX + kMarginForChildWithParentEdge;
    self.lblSelectedProvinceName.centerY = self.centerY;
    [self addSubview:self.lblSelectedProvinceName];
    
    self.imgViewLocalMenuArrow.originX = self.width - self.imgViewLocalMenuArrow.width - kMarginForChildWithParentEdge;
    self.imgViewLocalMenuArrow.centerY = self.centerY;
    [self addSubview:self.imgViewLocalMenuArrow];
    
    self.viewSeparatorLine.originY = _estimatedHeaderViewHeight;
    [self addSubview:self.viewSeparatorLine];
}



#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.liveLocationCategoryManager.arrProvnceNumModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellid = @"tableViewProvinceCellID";
    PLProvinceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[PLProvinceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    ProvinceNumModel * pNumModel = self.liveLocationCategoryManager.arrProvnceNumModel[indexPath.row];
    [cell reloadWithProvinceNumModel:pNumModel andLocalProvinceNumModel:self.liveLocationCategoryManager.localProvinceNumModel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.liveLocationCategoryManager.localProvinceNumModel = self.liveLocationCategoryManager.arrProvnceNumModel[indexPath.row];
    [self.tableViewProvince reloadData];
    [self.liveLocationCategoryManager reloadLiveRoomInfoListWithPid:self.liveLocationCategoryManager.localProvinceNumModel.pid];
    [self hideProvinceTableview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

#pragma mark - click method

-(void)backTapControlOnClick:(UIControl *)backTapControl
{
    BOOL isRefresh = NO;
    if ([self.delegate respondsToSelector:@selector(isRefreshOfRefreshControl)]) {
        isRefresh = [self.delegate isRefreshOfRefreshControl];
    }
    if(self.liveLocationCategoryManager.arrProvnceNumModel.count > 0 && !isRefresh){
        backTapControl.selected = !backTapControl.selected;
        if (backTapControl.selected) {
            [self showProvinceTableView];
        }else{
            [self hideProvinceTableview];
        }
    }
}

#pragma mark - uitl 

-(void)showProvinceTableView
{
    self.tableViewProvince.origin = CGPointMake(0, _estimatedHeaderViewHeight + self.viewSeparatorLine.height);
    [self addSubview:self.tableViewProvince];
    
    self.superview.height = SCREEN_HEIGHT - (kNavigationBarHeight + kStatusBarHeight + kTabbarHeight);
    [UIView animateWithDuration:.25f animations:^{
        self.height = self.superview.height;
        self.imgViewLocalMenuArrow.transform = CGAffineTransformMakeRotation(0);
    }];
    self.backTapControl.selected = YES;
    
    [self.tableViewProvince reloadData];
    if ([self.delegate respondsToSelector:@selector(provinceTableShowStatusChangeTo:)]) {
        [self.delegate provinceTableShowStatusChangeTo:YES];
    }
}

-(void)hideProvinceTableview
{
    [UIView animateWithDuration:.25f animations:^{
        self.height = _estimatedHeaderViewHeight;
        self.imgViewLocalMenuArrow.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.superview.height = self.height;
    }];
    self.backTapControl.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(provinceTableShowStatusChangeTo:)]) {
        [self.delegate provinceTableShowStatusChangeTo:NO];
    }
}


#pragma mark - setter

-(void)reloadWithLiveLocationCategoryManager:(LiveLocationCategoryManager *)liveLocationCategoryManager
{
    self.liveLocationCategoryManager = liveLocationCategoryManager;
    self.lblSelectedProvinceName.text = liveLocationCategoryManager.localProvinceNumModel.ptitle.length > 0 ? liveLocationCategoryManager.localProvinceNumModel.ptitle : @"正在定位...";
}

#pragma mark - getter

-(UIControl *)backTapControl
{
    if (!_backTapControl) {
        _backTapControl = [[UIControl alloc]initWithFrame:self.bounds];
        [_backTapControl addTarget:self action:@selector(backTapControlOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTapControl;
}

-(UIImageView *)imgViewLocal
{
    if (!_imgViewLocal) {
        _imgViewLocal = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 13, 17)];
        [_imgViewLocal setImage:[UIImage imageNamed:@"live_list_icon_local"]];
    }
    return _imgViewLocal;
}

-(UILabel *)lblSelectedProvinceName
{
    if (!_lblSelectedProvinceName) {
        _lblSelectedProvinceName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, _estimatedHeaderViewHeight)];
        _lblSelectedProvinceName.backgroundColor = [UIColor clearColor];
        _lblSelectedProvinceName.font = [UIFont systemFontOfSize:14];
        _lblSelectedProvinceName.textColor = [UIColor colorWithRed:0.85f green:0.26f blue:0.21f alpha:1.00f];
        _lblSelectedProvinceName.text = @"正在定位...";
    }
    return _lblSelectedProvinceName;
}

-(UIImageView *)imgViewLocalMenuArrow
{
    if (!_imgViewLocalMenuArrow) {
        _imgViewLocalMenuArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 11)];
        [_imgViewLocalMenuArrow setImage:[UIImage imageNamed:@"live_list_icon_local_menu_arrow"]];
        _imgViewLocalMenuArrow.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _imgViewLocalMenuArrow;
}

-(UIView *)viewSeparatorLine
{
    if (!_viewSeparatorLine) {
        _viewSeparatorLine = [[UIView alloc]initWithFrame:CGRectMake(kMarginForChildWithParentEdge, 0, SCREEN_WIDTH - 2*kMarginForChildWithParentEdge, kTableViewCellSeparatorHeight)];
        _viewSeparatorLine.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    }
    return _viewSeparatorLine;
}


-(UITableView *)tableViewProvince
{
    if (!_tableViewProvince) {
        _tableViewProvince = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (_estimatedHeaderViewHeight + kTableViewCellSeparatorHeight) - (kNavigationBarHeight + kStatusBarHeight + kTabbarHeight))];
        _tableViewProvince.tableFooterView = [[UIView alloc]init];
        _tableViewProvince.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _tableViewProvince.delegate = self;
        _tableViewProvince.dataSource = self;
        _tableViewProvince.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    }
    return _tableViewProvince;
}

@end

@implementation  PLProvinceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self UIConfig];
    }
    return self;
}

-(void)UIConfig
{
    self.height = 48;
    self.width = SCREEN_WIDTH;
    
    self.lblProvinceName.originX = kMarginForChildWithParentEdge;
    self.lblProvinceName.centerY = self.centerY;
    [self addSubview:self.lblProvinceName];
    
    self.imgViewSelect.rightX = SCREEN_WIDTH - kMarginForChildWithParentEdge;
    self.imgViewSelect.centerY = self.centerY;
    [self addSubview:self.imgViewSelect];
    
    self.viewLine.originX = kMarginForChildWithParentEdge;
    self.viewLine.bottomY = self.height;
    [self addSubview:self.viewLine];
}

-(void)reloadWithProvinceNumModel:(ProvinceNumModel *)provinceNumModel andLocalProvinceNumModel:(ProvinceNumModel *)localProvinceNumModel
{
    self.lblProvinceName.text = provinceNumModel.ptitle;
    if ([localProvinceNumModel.pid isEqualToString:provinceNumModel.pid]) {
        [self.imgViewSelect setImage:[UIImage imageNamed:@"live_list_icon_menu_cell_selected"]];
    }else{
        [self.imgViewSelect setImage:[UIImage imageNamed:@"live_list_icon_menu_cell_normal"]];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - getter

-(UILabel *)lblProvinceName
{
    if (!_lblProvinceName) {
        _lblProvinceName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, self.height)];
        _lblProvinceName.textColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        _lblProvinceName.font = [UIFont systemFontOfSize:13];
        _lblProvinceName.backgroundColor = [UIColor clearColor];
    }
    return _lblProvinceName;
}

-(UIImageView *)imgViewSelect
{
    if (!_imgViewSelect) {
        _imgViewSelect = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_imgViewSelect setImage:[UIImage imageNamed:@"live_list_icon_menu_cell_normal"]];
    }
    return _imgViewSelect;
}

-(UIView *)viewLine
{
    if (!_viewLine) {
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2*kMarginForChildWithParentEdge, kTableViewCellSeparatorHeight)];
        _viewLine.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    }
    return _viewLine;
}
@end
