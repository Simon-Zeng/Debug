//
//  eLongRobotForbidStrategy.h
//  eLongFramework
//
//  Created by Dean on 15/6/29.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  该页面主要是用来验证验证码（比如防止暴力抓取）
 */

@interface eLongRobotForbidStrategy : UIView
/**
 *  显示验证码验证页
 *
 *  @param url 验证码URL
 */
- (void)showCheckCodeViewWithURL:(NSString *)url;
@end
