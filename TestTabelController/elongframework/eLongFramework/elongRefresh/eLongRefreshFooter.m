//
//  elongRefreshFooter.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefreshFooter.h"

@implementation eLongRefreshFooter

#pragma mark - 构造方法

+ (instancetype)footerWithRefreshingBlock:(refreshComponentRefreshingBlock)refreshingBlock
{
    eLongRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    eLongRefreshFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.height = refreshFooterHeight;
}

#pragma mark - 公共方法
- (void)noticeNoMoreData
{
    self.state = refreshStateNoMoreData;
}

- (void)resetNoMoreData
{
    self.state = refreshStateIdle;
}

@end
