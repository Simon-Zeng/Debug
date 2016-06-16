//
//  eLongDebugNetwork.h
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongDebugNetworkModel.h"
#import "eLongDebugObject.h"

@interface eLongDebugNetwork : eLongDebugObject
/**
 *  开始网络请求
 *
 *  @return 请求Model
 */
- (eLongDebugNetworkModel *) beginRequest;
/**
 *  结束网络请求
 *
 *  @param networkModel 请求Model
 */
- (void) endRequest:(eLongDebugNetworkModel *)networkModel;
/**
 *  清空过期的数据
 */
- (void) cleanRequest;
/**
 *  清空所有数据
 */
- (void) clearRequest;
/**
 *  所有的网络请求
 *
 *  @return 所有的请求Model
 */
- (NSArray *) requests;
/**
 *  时间限定范围内的网络请求
 *
 *  @param beginDate 开始时间
 *  @param endDate   结束时间
 *
 *  @return 所有符合条件的请求Model
 */
- (NSArray *) requestsBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
@end
