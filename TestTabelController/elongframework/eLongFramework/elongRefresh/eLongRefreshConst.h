//
//  elongRefreshConst.h
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//  refresh中得一些宏定义，key

#import <UIKit/UIKit.h>
#import <objc/message.h>

#define iOS(version) ([[UIDevice currentDevice].systemVersion doubleValue] >= version)

// 过期提醒
#define MJDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

// RGB颜色
#define refreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define refreshLabelTextColor refreshColor(90, 90, 90)

// 字体大小
#define refreshLabelFont [UIFont boldSystemFontOfSize:14]

#define FITSCALE       (SCREEN_WIDTH/320.0)
#define SCREEN_WIDTH			([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT			([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_35_INCH  (SCREEN_HEIGHT == 480)
#define SCREEN_4_INCH   (SCREEN_HEIGHT == 568)      // 4寸Retina iPhone5
#define SCREEN_47_INCH  (SCREEN_HEIGHT == 667)      // 4.7       iPhone6
#define SCREEN_55_INCH  (SCREEN_HEIGHT == 736)      // 5.5       iPhone6+

// 常量
UIKIT_EXTERN const CGFloat refreshHeaderHeight;
UIKIT_EXTERN const CGFloat refreshFooterHeight;
UIKIT_EXTERN const CGFloat refreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat refreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const refreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const refreshKeyPathContentSize;
UIKIT_EXTERN NSString *const refreshKeyPathContentInset;
UIKIT_EXTERN NSString *const refreshKeyPathPanState;

UIKIT_EXTERN NSString *const refreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const refreshHeaderIdleText;
UIKIT_EXTERN NSString *const refreshHeaderPullingText;
UIKIT_EXTERN NSString *const refreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const refreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const refreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const refreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const refreshBackFooterIdleText;
UIKIT_EXTERN NSString *const refreshBackFooterPullingText;
UIKIT_EXTERN NSString *const refreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const refreshBackFooterNoMoreDataText;

// 状态检查
#define refreshCheckState \
refreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
