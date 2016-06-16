//
//  UIApplication+openURL.m
//  MyElong
//
//  Created by yangfan on 15/6/17.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "UIApplication+openURL.h"
#import "eLongCONST.h"
#import "eLongDebugManager.h"

@implementation UIApplication (openURL)

- (BOOL)newOpenURL:(NSURL*)url {
    if ([eLongDebugManager businessLineInstance].enabled) {
        if (![[eLongDebugManager businessLineInstance] isEnabled:eLongDebugBLBooking]) {
            // 如果monkey打开，不做处理，直接跳出
            return NO;
        }
    }
    return [self openURL:url];
}

@end
