//
//  PLLobbyVerticalCollectionFooterView.m
//  PomegranateLive
//
//  Created by CKK on 17/2/24.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyVerticalCollectionFooterView.h"

@implementation PLLobbyVerticalCollectionFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lblFailConnect.center = self.center;
        [self addSubview:self.lblFailConnect];
    }
    return self;
}

-(UILabel *)lblFailConnect
{
    if (!_lblFailConnect) {
        _lblFailConnect = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
        _lblFailConnect.textColor = [UIColor colorWithRed:0.57f green:0.57f blue:0.57f alpha:1.00f];
        _lblFailConnect.text = @"请下拉刷新试试";
        _lblFailConnect.textAlignment = NSTextAlignmentCenter;
        _lblFailConnect.font = [UIFont systemFontOfSize:14];
    }
    return _lblFailConnect;
}

@end
