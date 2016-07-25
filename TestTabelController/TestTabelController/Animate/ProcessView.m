//
//  ProcessView.m
//  TestTabelController
//
//  Created by wzg on 16/7/20.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ProcessView.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define LRRadianToDegrees(radian) (radian*180.0)/(M_PI)

@implementation ProcessView
- (void)drawRect:(CGRect)rect
{
    CGFloat circelRadius = 100;
    CGFloat lineWidth = 5;
    size_t colorsCount = 2;
    CGFloat colors[12] = {
        0.01f, 0.99f, 0.01f, 1.0f,
        0.01f, 0.99f, 0.99f, 1.0f,
        0.99f, 0.99f, 0.01f, 1.0f
    };
    CGFloat locations[3] = {
        0.0f,
        0.5f,
        1.0f
    };
    CGPoint beginP = CGPointMake(0, 0);
    CGPoint endP = CGPointMake(320.f, 460.f);
    //圆路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)
                                                        radius:(circelRadius - lineWidth) / 2
                                                    startAngle:degreesToRadians(-90)
                                                      endAngle:degreesToRadians(270)
                                                     clockwise:YES];
    path.lineWidth = 2;
    path.lineCapStyle = kCGLineCapRound;
    [path addClip];
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, colorsCount);
    
//    CG_EXTERN CGGradientRef __nullable CGGradientCreateWithColorComponents(
//                                                                           CGColorSpaceRef __nullable space, const CGFloat * __nullable components,
//                                                                           const CGFloat * __nullable locations, size_t count)
    //渐变

    CGContextAddPath(context, path.CGPath);
//    [[UIColor grayColor] set];
//    CGContextSetLineWidth(context, 10);
//    CGContextDrawPath(context, kCGPathStroke);
//        CGContextDrawLinearGradient(context, gradient, beginP, endP, 0);
    CGContextDrawRadialGradient(context, gradient, self.center, degreesToRadians(-90), CGPointMake(50, 50),degreesToRadians(270), 0);
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
}
@end
