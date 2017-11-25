//
//  PLLobbyVerticalCollectionViewCell.m
//  PomegranateLive
//
//  Created by CKK on 17/2/22.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLLobbyVerticalCollectionViewCell.h"

static CGFloat const kcontrolMarginToParent = 5.f;

@interface PLLobbyVerticalCollectionViewCell()

@property (nonatomic,strong) UIImageView * imgViewBack;
@property (nonatomic,strong) UILabel * lblmobileMark;
@property (nonatomic,strong) UIImageView * imgViewLabelBack;
@property (nonatomic,strong) UILabel * lblUserName;
@property (nonatomic,strong) UILabel * lblUserNumber;

@end

@implementation PLLobbyVerticalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self UIConfig];
    }
    return self;
}
-(void)UIConfig
{
    [self addSubview:self.imgViewBack];
    self.lblmobileMark.origin = CGPointMake(self.width - self.lblmobileMark.width - kcontrolMarginToParent, kcontrolMarginToParent);
    [self.imgViewBack addSubview:self.lblmobileMark];
    
    self.imgViewLabelBack.origin = CGPointMake(0, self.imgViewBack.height - self.imgViewLabelBack.height);
    [self.imgViewBack addSubview:self.imgViewLabelBack];
    
    [self.imgViewLabelBack addSubview:self.lblUserName];
    self.lblUserNumber.originX = self.lblUserName.rightX;
    [self.imgViewLabelBack addSubview:self.lblUserNumber];
}

-(void)reloadDataWithRoomInfoModel:(LiveRoomInfoModel *)roomInfoModel
{
    //观看人数
    self.lblUserNumber.text = [NSString stringWithFormat:@"%@人",roomInfoModel.count];
    CGSize eSize = [self.lblUserNumber sizeThatFits:CGSizeMake(MAXFLOAT, self.lblUserNumber.height)];
    self.lblUserNumber.width = eSize.width;
    self.lblUserNumber.rightX = self.width - kcontrolMarginToParent;
    
    //主播名字
    self.lblUserName.text = roomInfoModel.username.length > 0 ? roomInfoModel.username : roomInfoModel.alias;
    self.lblUserName.width = self.lblUserNumber.originX - self.lblUserName.originX;
    
    //特色名称
    NSString * tagname = @"";
    if ([roomInfoModel.recordtype integerValue] > 1) {
        tagname = @"手机直播";
    }else if(roomInfoModel.tagname.length > 0){
        tagname = roomInfoModel.tagname;
    }
    self.lblmobileMark.text = tagname;
    
    self.lblmobileMark.hidden = (tagname.length == 0);
    if (!self.lblmobileMark.hidden) {
        CGSize size = [self.lblmobileMark sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.lblmobileMark.size = CGSizeMake(size.width + 6, size.height + 6);
        self.lblmobileMark.origin = CGPointMake(self.width - self.lblmobileMark.width - kcontrolMarginToParent, kcontrolMarginToParent);
    }
    
    //海报
    NSString * pospic = [roomInfoModel.pospic mutableCopy];
    if (pospic.length > 0) {
        pospic = [pospic stringByReplacingOccurrencesOfString:@"_s" withString:@"_b"];
    }else{
        pospic = roomInfoModel.pic;
    }
    [self.imgViewBack sd_setImageWithURL:[NSURL URLWithString:pospic] placeholderImage:[self backImage]];
}

-(UIImage *)backImage
{
    NSString * imageName = @"";
    switch ((int)(SCREEN_WIDTH * [UIScreen mainScreen].scale)) {
        case 640:
            imageName = @"live_list_placeholder_640";
            break;
        case 750:
            imageName = @"live_list_placeholder_750";
            break;
        case 1242:
            imageName = @"live_list_placeholder_750";
            break;
        default:
            imageName = @"live_list_placeholder_640";
            break;
    }
    return [UIImage imageNamed:imageName];
}

#pragma mark - getter

-(UIImageView *)imgViewBack
{
    if (!_imgViewBack) {
        _imgViewBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        [_imgViewBack setImage:[self backImage]];
        _imgViewBack.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewBack.clipsToBounds = YES;
    }
    return _imgViewBack;
}

-(UILabel *)lblmobileMark
{
    if (!_lblmobileMark) {
        _lblmobileMark = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblmobileMark.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        _lblmobileMark.layer.borderColor = [UIColor whiteColor].CGColor;
        _lblmobileMark.layer.borderWidth = .5f;
        _lblmobileMark.layer.cornerRadius = 3.f;
        _lblmobileMark.font = [UIFont systemFontOfSize:12];
        _lblmobileMark.textAlignment = NSTextAlignmentCenter;
        _lblmobileMark.textColor = [UIColor whiteColor];
    }
    return _lblmobileMark;
}

-(UIImageView *)imgViewLabelBack
{
    if (!_imgViewLabelBack) {
        _imgViewLabelBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 41)];
        [_imgViewLabelBack setImage:[UIImage imageNamed:@"live_lobby_image_anchor_shadow"]];
    }
    return _imgViewLabelBack;
}

-(UILabel *)lblUserName
{
    if (!_lblUserName) {
        _lblUserName = [[UILabel alloc]initWithFrame:CGRectMake(kcontrolMarginToParent, 15, (self.width-2 * kcontrolMarginToParent)/4*3, 20)];
        _lblUserName.backgroundColor = [UIColor clearColor];
        _lblUserName.font = [UIFont systemFontOfSize:12];
        _lblUserName.textAlignment = NSTextAlignmentLeft;
        _lblUserName.textColor = [UIColor whiteColor];
    }
    return _lblUserName;
}

-(UILabel *)lblUserNumber
{
    if (!_lblUserNumber) {
        _lblUserNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, (self.width-2 * kcontrolMarginToParent)/4, 20)];
        _lblUserNumber.backgroundColor = [UIColor clearColor];
        _lblUserNumber.font = [UIFont systemFontOfSize:12];
        _lblUserNumber.textAlignment = NSTextAlignmentRight;
        _lblUserNumber.textColor = [UIColor whiteColor];
    }
    return _lblUserNumber;
}

@end
