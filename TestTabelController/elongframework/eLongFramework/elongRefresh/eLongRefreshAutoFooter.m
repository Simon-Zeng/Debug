//
//  elongRefreshFooter.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefreshAutoFooter.h"

@implementation eLongRefreshAutoFooter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        self.scrollView.insetBottom += self.height;
        
        // 重新调整frame
        [self scrollViewContentSizeDidChange:nil];
    } else { // 被移除了
        self.scrollView.insetBottom -= self.height;
    }
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.appearencePercentTriggerAutoRefresh = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.top = _scrollView.contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != refreshStateIdle || !self.automaticallyRefresh || self.top == 0) return;
    
    if (_scrollView.insetTop + _scrollView.contentH > _scrollView.height) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.offsetY > _scrollView.contentH - _scrollView.height + self.height * self.appearencePercentTriggerAutoRefresh + _scrollView.insetBottom - self.height) {
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != refreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.insetTop + _scrollView.contentH <= _scrollView.height) {  // 不够一个屏幕
            if (_scrollView.offsetY > - _scrollView.insetTop) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.offsetY > _scrollView.contentH + _scrollView.insetBottom - _scrollView.height) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(refreshState)state
{
    refreshCheckState
    
    if (state == refreshStateRefreshing) {
        // 这里延迟是防止惯性导致连续上拉
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = refreshStateIdle;
        _scrollView.insetBottom -= self.height;
    } else if (lastHidden && !hidden) {
        _scrollView.insetBottom += self.height;
        
        [self scrollViewContentSizeDidChange:nil];
    }
}

@end
