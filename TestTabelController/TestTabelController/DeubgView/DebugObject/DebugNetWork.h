//
//  DebugNetWork.h
//  TestTabelController
//
//  Created by wzg on 16/6/28.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugObject.h"
#import "NetWork.h"

@interface DebugNetWork : DebugObject

/**
 *  开始网络请求
 *
 *  @return 请求Model
 */
- (NetWork *) beginRequest;
/**
 *  结束网络请求
 *
 *  @param networkModel 请求Model
 */
- (void) endRequest:(NetWork *)networkModel;
/**
 *  清空过期的数据(过期时长为半天)
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
/**
 *  设置网络请求的过滤名单,为了过滤日志分析和轮询类的请求
 *
 *  @param list 过滤名单
 */
- (NSArray *)setFilterList:(NSArray<NSString *> *)list;

@end
