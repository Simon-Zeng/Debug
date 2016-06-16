//
//  eLongAnalyticsEventBase.h
//  eLongAnalytics
//
//  手动打点时使用此类
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongAnalyticsEventBase : NSObject

/**
 *  页面名称
 */
@property (nonatomic, copy) NSString *pt;

/**
 *  模块名称
 */
@property (nonatomic, copy) NSString *ch;

/**
 *  MVT实验id
 */
@property (nonatomic, copy) NSString *expId;

/**
 *  MVT实验名称
 */
@property (nonatomic, copy) NSString *expName;

/**
 *  MVT实验值
 */
@property (nonatomic, copy) NSString *expValue;

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
