//
//  PLAnimationButton.m
//  动画button
//
//  Created by CKK on 17/2/27.
//  Copyright © 2017年 六间房. All rights reserved.
//

#import "PLAnimationButton.h"

static CGFloat const kMarginForLineWithButtonEdge = 12.f; //线和button边的距离
static CGFloat const kLineHeight = 1.5f; //线宽
static CGFloat const kIntervalForLines = 7.f; //三条线之间的间距
static NSTimeInterval const kAnimationTimeInterval = .5f; //动画时长

@implementation PLAnimationButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if (self.selected == selected) {
        return;
    }
    [super setSelected:selected];
    [UIView animateWithDuration:kAnimationTimeInterval/2 animations:^{
        CALayer *layer = self.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform = CATransform3DMakeRotation(M_PI_2,1,0,0);
        layer.transform = rotationAndPerspectiveTransform;
    } completion:^(BOOL finished) {
        self.animationButtonStyle = (self.animationButtonStyle + 1)%2;
        [self setNeedsDisplay];
        [UIView animateWithDuration:kAnimationTimeInterval/2 animations:^{
            CALayer *layer = self.layer;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform = CATransform3DMakeRotation(M_PI,1,0,0);
            layer.transform = rotationAndPerspectiveTransform;
        }];
    }];
}

- (void)drawRect:(CGRect)rect {
    if (self.animationButtonStyle == EnumPLAnimationButtonStyleX) {
        [self drawXStyleInRect:rect];
    }else{
        [self drawLinesStyleInRect:rect];
    }
}

/**
 *  绘制三条线
 *
 *  @param rect 绘制区域
 */
-(void)drawLinesStyleInRect:(CGRect)rect
{
    NSInteger lineNum = 3;
    CGFloat startPointY = (rect.size.height - (lineNum - 1) * kIntervalForLines)/2.f;
    for (int i = 0; i < lineNum; i ++) {
        CGPoint startPoint = CGPointMake(kMarginForLineWithButtonEdge , startPointY + kIntervalForLines * i);
        CGPoint endPoint = CGPointMake(rect.size.width -  kMarginForLineWithButtonEdge, startPointY + kIntervalForLines * i);
        [self drawLineWtihStartPoint:startPoint andEndPoint:endPoint];
    }
}

/**
 *  绘制❌
 *
 *  @param rect 绘制区域
 */
-(void)drawXStyleInRect:(CGRect)rect
{
    CGPoint topLeftPoint = CGPointMake(kMarginForLineWithButtonEdge, kMarginForLineWithButtonEdge);
    CGPoint topRightPoint = CGPointMake( rect.size.width - kMarginForLineWithButtonEdge,kMarginForLineWithButtonEdge);
    CGPoint bottomLeftPoint = CGPointMake(kMarginForLineWithButtonEdge, rect.size.height - kMarginForLineWithButtonEdge);
    CGPoint bottomRightPoint = CGPointMake(rect.size.width - kMarginForLineWithButtonEdge, rect.size.height - kMarginForLineWithButtonEdge);
    
    [self drawLineWtihStartPoint:topLeftPoint andEndPoint:bottomRightPoint];
    [self drawLineWtihStartPoint:topRightPoint andEndPoint:bottomLeftPoint];
}

/**
 *  划线
 *
 *  @param startPoint 起始点
 *  @param endPoint   终点
 */
-(void)drawLineWtihStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint) endPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, kLineHeight);
    CGContextMoveToPoint(context,startPoint.x , startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

@end
