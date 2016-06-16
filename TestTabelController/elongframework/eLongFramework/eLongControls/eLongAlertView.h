//
//  eLongAlertView.h
//  eLongFramework
//
//  Created by Kirn on 15/5/12.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongAlertView : NSObject
+ (void) showAlertQuiet:(NSString *)title;
/** 静默弹框 */
+ (void)showDefaultAlertQuiet:(NSString *)title;
/**
 *  静默弹框
 *
 *  @param canReplace 多于17字是否由系统弹框代替
 *  @param duration   持续时间
 */
+ (void) showAlertQuiet:(NSString *)title
   canReplacedByUIAlert:(BOOL)canReplace
          totalDuration:(NSTimeInterval)duration;
+ (void) showAlertTitle:(NSString *)title Message:(NSString *)message;

+ (void)showTip:(NSString *)tip;
+ (void)showTip:(NSString *)tip duration:(float)duration;
@end
