//
//  UIResponder+ViewController.m
//  ElongClient
//
//  Created by nieyun on 14-9-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UIResponder+ViewController.h"

@implementation UIResponder (ViewController)
- (UIViewController  *)getViewController
{
    UIResponder  *next = nil;
    
    if ([self  isKindOfClass:[UIViewController  class]])
    {
        return (UIViewController *)self;
    }else
    {
        next = self.nextResponder;
        return  [next  getViewController];
    }
}
@end
