//
//  UIView+TipMessage.h
//  MyElong
//
//  Created by yangfan on 15/6/17.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TipMessage)

// 生成一个透明的view
+ (id)clearViewWithFrame:(CGRect)rect;

// 隐藏提示框
- (void)removeTipMessage;

// 在view中间显示提示框
- (void)showTipMessage:(NSString *)tips;

// 加入loading动画
- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style;
- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style AtPoint:(CGPoint)activityCenter;

- (void)startUniformLoading;            // 黑底圆角的loading框

// 结束loading动画
- (void)endLoading;
- (void)endUniformLoading;

//将试图转换为Image
- (UIImage *) imageByRenderingViewWithSize:(CGSize) size;

// 显示页面实时提醒的方法
- (void)alertMessage:(NSString *)tipString;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect;
- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point;
- (void)removeAlert;

@end
