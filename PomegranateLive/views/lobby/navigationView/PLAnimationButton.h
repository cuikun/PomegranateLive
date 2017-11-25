//
//  PLAnimationButton.h
//  动画button
//
//  Created by CKK on 17/2/27.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , EnumPLAnimationButtonStyle)
{
    EnumPLAnimationButtonStyleLine,
    EnumPLAnimationButtonStyleX
};

@interface PLAnimationButton : UIControl

@property (nonatomic) EnumPLAnimationButtonStyle animationButtonStyle;

@end
