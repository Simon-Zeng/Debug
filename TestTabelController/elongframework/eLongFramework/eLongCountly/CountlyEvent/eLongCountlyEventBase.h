//
//  eLongCountlyEventBase.h
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCountlyEventBase : NSObject

/**
 *  登录状态
 */
@property (nonatomic,copy) NSNumber *status;

/**
 *  模块名称
 */
@property (nonatomic,copy) NSString *ch;

/**
 *  发送事件
 *
 *  @param event 事件名称
 *  @param count 事件次数
 */
- (void)sendEvent:(NSString *)event count:(NSInteger)count;

/**
 *  发送事件（子类实现方法）
 *
 *  @param count 事件次数
 */
- (void)sendEventCount:(NSInteger)count;

@end
