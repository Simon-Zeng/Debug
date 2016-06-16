//
//  UIViewController+Shadow.m
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "UIViewController+Shadow.h"

@implementation UIViewController (Shadow)

- (void)addTopShadow {
    UIImageView *shaowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
    [shaowView setFrame:CGRectMake(0, 0, 320, 11)];
    
    [self.view addSubview:shaowView];
}

@end
