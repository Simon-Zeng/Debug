//
//  elongRefreshAutoStateFooter.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRefreshAutoStateFooter.h"

@interface eLongRefreshAutoStateFooter(){
    /** 显示刷新状态的label */
    UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@end

@implementation eLongRefreshAutoStateFooter

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel= [[UILabel alloc] init];
        _stateLabel.font = refreshLabelFont;
        _stateLabel.textColor = refreshLabelTextColor;
        _stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(refreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == refreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:refreshAutoFooterIdleText forState:refreshStateIdle];
    [self setTitle:refreshAutoFooterRefreshingText forState:refreshStateRefreshing];
    [self setTitle:refreshAutoFooterNoMoreDataText forState:refreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(refreshState)state
{
    refreshCheckState
    
    if (self.isRefreshingTitleHidden && state == refreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}


@end
