//
//  CustomRootViewController.m
//  ElongClient
//
//  Created by 张馨允 on 15/1/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "CustomRootViewController.h"
#import "eLongDefine.h"
#import "eLongBus.h"

@interface CustomRootViewController()<UIGestureRecognizerDelegate>

@end

@implementation CustomRootViewController

- (void)dealloc
{
    [eLongBus bus].navigationController = nil;
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (IOSVersion_7) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            Class groupClass = NSClassFromString(@"GrouponSearchViewController");
            if (self.navC.viewControllers.count == 1 && ![[self.navC.viewControllers lastObject] isKindOfClass:groupClass]) {
                return YES;
            }
            return NO;
        }
//    }
    return YES;
}

@end
