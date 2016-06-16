//
//  elongProgressIndicator.h
//  MyElong
//
//  Created by yongxue on 16/1/7.
//  Copyright © 2016年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    ElongProgressIndicatorMaskTypeNone = 1, // allow user interactions while HUD is displayed
    ElongProgressIndicatorMaskTypeClear, // don't allow
    ElongProgressIndicatorMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    ElongProgressIndicatorMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger ElongProgressIndicatorMaskType;

@interface ElongProgressIndicator : UIView

@property (nonatomic, weak) UIView *overView;

// 显示loading
+ (ElongProgressIndicator *)showWithView:(UIView *)overlayView;

// 显示loading，屏蔽页面交互
+ (ElongProgressIndicator *)showClearWithView:(UIView *)overlayView;

// 显示loading，有文字描述
+ (ElongProgressIndicator *)showWithView:(UIView *)overlayView withStatus:(NSString *)status;

// 显示loading，有文字描述，屏蔽页面交互
+ (ElongProgressIndicator *)showClearWithView:(UIView *)overlayView withStatus:(NSString *)status;


- (void)showLoading;

- (void)showClearLoading;

- (void)dismiss;

@end
