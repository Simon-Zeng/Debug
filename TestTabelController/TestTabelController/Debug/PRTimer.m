//
//  PRTimer.m
//  TestTabelController
//
//  Created by wzg on 16/9/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PRTimer.h"

@interface PRTimer()
@property (nonatomic, assign) NSTimeInterval lastTick;
@property (nonatomic, assign) NSTimeInterval curTick;
@property (nonatomic, strong)NSProcessInfo *processInfo;
@end

@implementation PRTimer

- (void)start
{
    if (!_processInfo) {
        _processInfo = [NSProcessInfo processInfo];
        _lastTick = [_processInfo systemUptime];
    }
}

- (void)restart
{
    _lastTick = [_processInfo systemUptime];
}

- (NSTimeInterval)elapse
{
    _curTick = [_processInfo systemUptime];
    NSTimeInterval time = _curTick - _lastTick;
    _lastTick = _curTick;
    return time;
}

- (NSTimeInterval)interval
{
    _curTick = [_processInfo systemUptime];
    return _curTick - _lastTick;
}

- (NSTimeInterval)tick
{
    return [_processInfo systemUptime];
}

@end
