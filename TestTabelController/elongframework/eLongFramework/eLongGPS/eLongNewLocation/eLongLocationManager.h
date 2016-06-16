//
//  eLongLocationManager.h
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongLocationRequestDefines.h"

@interface eLongLocationManager : NSObject
/**
 *  单例
 *
 *  @return eLongLocationManager
 */
+ (instancetype)sharedInstance;
/**
 *  定位服务状态
 *
 *  @return 定位服务状态
 */
+ (eLongLocationServicesState)locationServicesState;
/**
 *  请求位置信息(异步)
 *
 *  @param desiredAccuracy 精准度
 *  @param timeout         超时时间
 *  @param block           回调
 *
 *  @return 请求位置对象的ID
 */
- (eLongLocationRequestID)requestLocationWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                    timeout:(NSTimeInterval)timeout
                                                      block:(eLongLocationRequestBlock)block;
/**
 *  请求位置信息(异步)
 *
 *  @param desiredAccuracy      精准度
 *  @param timeout              超时时间
 *  @param delayUntilAuthorized 用户允许使用位置信息之后开始计时
 *  @param block                回调
 *
 *  @return 请求位置对象的ID
 */
- (eLongLocationRequestID)requestLocationWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                    timeout:(NSTimeInterval)timeout
                                       delayUntilAuthorized:(BOOL)delayUntilAuthorized
                                                      block:(eLongLocationRequestBlock)block;
/**
 *  订阅位置信息
    每次定位信息发生变化便会执行回调block，不限定定位信息的精准度；
    如果发生错误，block返回的定位状态不是成功，便会自动取消订阅；
 *
 *  @param block 回调
 *
 *  @return 请求位置对象的ID
 */
- (eLongLocationRequestID)subscribeToLocationUpdatesWithBlock:(eLongLocationRequestBlock)block;
/**
 *  订阅位置信息
    每次定位信息发生变化并且符合限定的定位信息精准度，便会执行回调block；
    如果发生错误，block返回的定位状态不是成功，便会自动取消订阅；
 *
 *  @param desiredAccuracy 精准度
 *  @param block           回调
 *
 *  @return 请求位置对象的ID
 */
- (eLongLocationRequestID)subscribeToLocationUpdatesWithDesiredAccuracy:(eLongLocationAccuracy)desiredAccuracy
                                                                 block:(eLongLocationRequestBlock)block;
/**
 *  订阅持续更新的位置信息
    如果发生错误，block返回的定位状态不是成功，便会自动取消订阅；
 *
 *  @param block 回调
 *
 *  @return 请求位置对象的ID
 */
- (eLongLocationRequestID)subscribeToSignificantLocationChangesWithBlock:(eLongLocationRequestBlock)block;
/**
 *  强制终止某个请求位置对象，并执行block回调
 *
 *  @param requestID 请求位置对象的ID
 */
- (void)forceCompleteLocationRequest:(eLongLocationRequestID)requestID;
/**
 *  取消某个请求位置对象，不执行block回调
 *
 *  @param requestID 请求位置对象的ID
 */
- (void)cancelLocationRequest:(eLongLocationRequestID)requestID;

@end
