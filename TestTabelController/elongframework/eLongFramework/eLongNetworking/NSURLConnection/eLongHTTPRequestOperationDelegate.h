//
//  eLongHTTPRequestOperationDelegate.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

@class eLongHTTPRequestOperation;

@protocol eLongHTTPRequestOperationDelegate <NSObject>
@required
/**
 *  网络请求成功接收数据
 *
 *  @param operation eLongHTTPRequestOperation
 *  @param data      下行原始数据
 */
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedData:(NSData *)data;
/**
 *  网络请求失败，接收错误信息
 *
 *  @param operation eLongHTTPRequestOperation
 *  @param error     报错信息
 */
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedError:(NSError *)error;
/**
 *  网络请求状态返回
 *
 *  @param operation eLongHTTPRequestOperation
 *  @param code 网络请求状态码
 *              200 OK
 *              201 Created
 *              202 Accepted
 *              204 No Content
 *              301 Moved Permanently
 *              302 Moved Temporarily
 *              304 Not Modified
 *              400 Bad Request
 *              401 Unauthorized
 *              403 Forbidden
 *              404 Not Found
 *              500 Internal Server Error
 *              501 Not Implemented
 *              502 Bad Gateway
 *              503 Service Unavailable
 */
@optional
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedStatusCode:(NSInteger)code;
/**
 *  网络请求数据发送进度
 *
 *  @param operation eLongHTTPRequestOperation
 *  @param process   request数据发送进度
 */
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedRequestProcess:(float)process;
/**
 *  网络请求数据接收进度
 *
 *  @param operation eLongHTTPRequestOperation
 *  @param process   response数据接收进度
 */
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedResponseProcess:(float)process;
@end