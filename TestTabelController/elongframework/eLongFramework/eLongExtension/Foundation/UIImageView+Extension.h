//
//  UIImageView.h
//  Pods
//
//  Created by chenggong on 15/5/27.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

// 返回白底圆角的view
+ (UIImageView *)roundCornerViewWithFrame:(CGRect)rect;

// 返回华丽丽而又忧郁的灰色分割线
+ (UIImageView *)graySeparatorWithFrame:(CGRect)rect;

// 分割竖线
+ (UIImageView *)graySplitWithFrame:(CGRect)rect;

// 细分割线
+ (UIImageView *)dashedHalfLineWithFrame:(CGRect)rect;

// 返回低调的纵向分割线
+ (UIImageView *)verticalSeparatorWithFrame:(CGRect)rect;

// 返回清新的纵向分割线
+ (UIImageView *)bottomSeparatorWithFrame:(CGRect)rect;

// 分割线
+ (UIImageView *)separatorWithFrame:(CGRect)rect;

@end
