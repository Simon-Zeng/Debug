//
//  DebugActionView.m
//  TestTabelController
//
//  Created by wzg on 16/6/29.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugActionView.h"

@implementation DebugActionView
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat screenWidth = ([[UIScreen mainScreen] bounds].size.width);
        CGFloat screenHeight = ([[UIScreen mainScreen] bounds].size.height);
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight - 40 - 20)];
        [self addSubview:_contentView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, screenHeight - 40, screenWidth, 40);
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)closeBtnClick:(id)sender{
    [self removeFromSuperview];
}

- (void) showOverWindow {
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *keyWindow = [app keyWindow];
    if (keyWindow) {
        [keyWindow addSubview:self];
    }
}
@end
