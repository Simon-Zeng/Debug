//
//  PRTimer.h
//  TestTabelController
//
//  Created by wzg on 16/9/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRTimer : NSObject

- (void)start;
- (void)restart;

/// 计算上一次调用start/restart/elapse后到现在的时间间隔，会更新内部计数器
@property (readonly) NSTimeInterval elapse;
/// 获取设备从启动后经历的时间，不会更新内部计数器
@property (readonly) NSTimeInterval tick;
/// 计算上一次调用start/restart后到现在的时间间隔
@property (readonly) NSTimeInterval interval;
@end
