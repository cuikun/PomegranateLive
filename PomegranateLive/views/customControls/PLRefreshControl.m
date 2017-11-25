//
//  PLRefreshControl.m
//  PomegranateLive
//
//  Created by CKK on 17/2/28.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLRefreshControl.h"

static CGFloat const kRefreshControlHeight = 44;
static CGFloat const kMarginForLblstateWithCenter = 30;

@interface PLRefreshControl ()<UIScrollViewDelegate>

//刷新的图标
@property (strong, nonatomic)  UIImageView * imgViewRefresh;
//状态文字
@property (nonatomic, strong) UILabel * lblState;
//进度指示器
@property (nonatomic, strong) UIActivityIndicatorView *refreshIndicatorView;


@end

@implementation PLRefreshControl
{
    CGFloat insetTop; //currentScrollView的原来的inset
    BOOL isInEndAnimation; //是否正在执行结束动画
    BOOL isStartRefresh; //是否为自动刷新
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}


-(void)startRefresh
{
    self.hidden = NO;
    isStartRefresh = YES;
    [self setRefreshState:EnumRefreshStateBeginRefresh];
}

-(void)endRefresh
{
    if (self.refreshState == EnumRefreshStateBeginRefresh) {
        [self setRefreshState:EnumRefreshStateEndRefresh];
    }
}


-(void)setUpUI
{
    [self addSubview:self.lblState];
    [self addSubview:self.imgViewRefresh];
    [self addSubview:self.refreshIndicatorView];
    
    self.lblState.centerX = self.centerX + kMarginForLblstateWithCenter;
    self.lblState.centerY = 20;
    
    self.imgViewRefresh.rightX = self.lblState.originX;
    self.imgViewRefresh.centerY = 20;
    
    self.refreshIndicatorView.rightX = self.lblState.originX;
    self.refreshIndicatorView.centerY = 20;
}



-(void)setRefreshState:(EnumRefreshState)refreshState{
    _refreshState = refreshState;
    
    switch (refreshState){
        case EnumRefreshStateBeginPullDown:
        {
            self.hidden = NO;
            self.lblState.text = @"下拉刷新";
            self.lblState.centerX = self.centerX + kMarginForLblstateWithCenter;
            //隐藏圆圈,x显示箭头
            [self.refreshIndicatorView stopAnimating];
            self.imgViewRefresh.hidden = NO;
            //调换箭头的方向
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.imgViewRefresh.transform = CGAffineTransformIdentity;
                }];
            });
            break;
        }
        case EnumRefreshStateWillRefresh:
        {
            self.lblState.text = @"释放更新";
            self.lblState.centerX = self.centerX + kMarginForLblstateWithCenter;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    self.imgViewRefresh.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            });
            break;
        }
        case EnumRefreshStateBeginRefresh:
        {
            //更改文字内容
            self.lblState.text = @"加载中...";
            self.lblState.centerX = self.centerX + kMarginForLblstateWithCenter;
            //显示圆圈,隐藏箭头
            [self.refreshIndicatorView startAnimating];
            self.imgViewRefresh.hidden = YES;
            //修改状态
            UIEdgeInsets inset = self.currentScrollView.contentInset;
            inset.top = kRefreshControlHeight + insetTop;
            if (isStartRefresh) { // 是否为自动刷新 ，解决collectionView 自动刷新带动画的问题
                self.currentScrollView.contentInset = inset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:.25f animations:^{
                        self.currentScrollView.contentOffset = CGPointMake(0, -inset.top);
                    }];
                });
                [self sendActionsForControlEvents:UIControlEventValueChanged];//通知外界刷新数据
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:.25f animations:^{
                        self.currentScrollView.contentInset = inset;
                        [self.currentScrollView setContentOffset:CGPointMake(0, -inset.top) animated:YES];
                    } completion:^(BOOL finished) {
                        [self sendActionsForControlEvents:UIControlEventValueChanged];//通知外界刷新数据
                    }];
                });
            }
            isStartRefresh = NO;
            break;
        }
        case EnumRefreshStateEndRefresh:
        {
            //更改文字内容
            self.lblState.text = @"加载完成";
            self.lblState.centerX = self.centerX;
            //隐藏圆圈,隐藏箭头
            [self.refreshIndicatorView stopAnimating];
            self.imgViewRefresh.hidden = YES;
            self.imgViewRefresh.transform = CGAffineTransformIdentity;
            UIEdgeInsets inset = self.currentScrollView.contentInset;
            inset.top = insetTop;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:.25f animations:^{
                    isInEndAnimation = YES;
                    self.currentScrollView.contentInset = inset;
                } completion:^(BOOL finished) {
                    isInEndAnimation = NO;
                }];
            });
            break;
        }
        default:
            break;
    }
}

#pragma mark- KVO监听
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    //判断当前的父控件是否存在
    if (!self.currentScrollView || self.refreshState == EnumRefreshStateBeginRefresh) {
        return;
    }
    UIScrollView* scrollView = self.currentScrollView;
    //获取scrollView的滚动状态
    //判断拖拽的位移
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //解决拉到不需要刷新的位置松手，refreshControl无法隐藏的问题
    if (self.currentScrollView.contentInset.top == insetTop && offsetY >= -insetTop && !isInEndAnimation) {
        self.hidden = YES;
    }
    //向上拖动的时候不处理
    if (offsetY>-scrollView.contentInset.top) {
        return;
    }
    //正在拖拽
    if (scrollView.dragging){
        //当拖拽位移小于自身高度加默认位移高度时候说明是下拉刷新的状态
        if (offsetY > -(kRefreshControlHeight + scrollView.contentInset.top)) {
            //设置下拉状态
            self.refreshState = EnumRefreshStateBeginPullDown;
        }else if (self.refreshState == EnumRefreshStateBeginPullDown) {
            //设置松手刷新状态
            self.refreshState = EnumRefreshStateWillRefresh;
        }
    }
    else{//松手
        //判断是否满足条件进入刷新状态
        if (offsetY <= -(kRefreshControlHeight + scrollView.contentInset.top) && self.refreshState == EnumRefreshStateWillRefresh) {
            //设置正在刷新状态
            self.refreshState = EnumRefreshStateBeginRefresh;
        }
    }
}

#pragma mark - setter

-(void)setCurrentScrollView:(UIScrollView *)currentScrollView
{
    if (_currentScrollView != currentScrollView) {
        _currentScrollView = currentScrollView;
        insetTop = currentScrollView.contentInset.top;
        [_currentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil]; ///使用KVO监听到父控件的滚动,从而判断显示的状态
    }
}

#pragma mark - getter

-(UIImageView *)imgViewRefresh{
    
    if (!_imgViewRefresh) {
        _imgViewRefresh = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableview_pull_refresh"]];
    }
    
    return _imgViewRefresh;
}

-(UILabel *)lblState{
    
    if (!_lblState) {
        _lblState = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _lblState.textColor = [UIColor grayColor];
        _lblState.font = [UIFont systemFontOfSize:13];
        _lblState.textAlignment = NSTextAlignmentCenter;
        _lblState.text = @"下拉刷新";
    }
    return _lblState;
}

-(UIActivityIndicatorView *)refreshIndicatorView{
    
    if (!_refreshIndicatorView) {
        _refreshIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _refreshIndicatorView;
}

- (void)dealloc
{
    @try {
        [_currentScrollView removeObserver:self forKeyPath:@"contentOffset"];
    } @catch (NSException *exception) {
        DEBUG_LOG(@"%@",exception);
    } @finally {
    }
}
@end
