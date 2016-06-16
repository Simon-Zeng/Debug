//
//  eLongLocationRequest.h
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongLocationRequestDefines.h"
/**
 *  定位请求的类型
 */
typedef NS_ENUM(NSInteger, eLongLocationRequestType) {
    /**
     *  一次请求
     */
    eLongLocationRequestTypeSingle,
    /**
     *  订阅
     */
    eLongLocationRequestTypeSubscription,
    /**
     *  订阅持续的位置变化信息
     */
    eLongLocationRequestTypeSignificantChanges
};

@class eLongLocationRequest;

@protocol eLongLocationRequestDelegate

- (void)locationRequestDidTimeout:(eLongLocationRequest *)locationRequest;

@end

@interface eLongLocationRequest : NSObject
/**
 *  代理方法
 */
@property (nonatomic, weak) id<eLongLocationRequestDelegate> delegate;
/**
 *  请求位置对象ID
 */
@property (nonatomic, readonly) eLongLocationRequestID requestID;
/**
 *  类型
 */
@property (nonatomic, readonly) eLongLocationRequestType type;
/**
 *  是否持续更新
 */
@property (nonatomic, readonly) BOOL isRecurring;
/**
 *  精准度
 */
@property (nonatomic, assign) eLongLocationAccuracy desiredAccuracy;
/**
 *  超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeout;
/**
 *  活跃时间(从设置超时时间开始)
 */
@property (nonatomic, readonly) NSTimeInterval timeAlive;
/**
 *  是否超时
 */
@property (nonatomic, readonly) BOOL hasTimedOut;
/**
 *  请求完成之后的回调
 */
@property (nonatomic, copy) eLongLocationRequestBlock block;
/**
 *  唯一初始化方法
 *
 *  @param type 请求类型
 *
 *  @return eLongLocationRequest
 */
- (instancetype)initWithType:(eLongLocationRequestType)type;
/**
 *  完成
 */
- (void)complete;
/**
 *  强制超时处理
 */
- (void)forceTimeout;
/**
 *  取消请求
 */
- (void)cancel;
/**
 *  开始计时
 */
- (void)startTimeoutTimerIfNeeded;
/**
 *  订阅持续更新请求时，对应的更新时间间隔
 *
 *  @return 更新时间间隔
 */
- (NSTimeInterval)updateTimeStaleThreshold;
/**
 *  订阅持续更新请求时，对应的更新距离间隔
 *
 *  @return 更新距离间隔
 */
- (CLLocationAccuracy)horizontalAccuracyThreshold;

@end

