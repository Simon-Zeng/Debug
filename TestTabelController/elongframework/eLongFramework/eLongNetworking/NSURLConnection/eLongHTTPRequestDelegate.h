//
//  eLongHTTPRequestDelegate.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//
@class eLongHTTPRequest;

@protocol eLongHTTPRequestDelegate <NSObject>
@optional
/**
 *  网络请求成功回传数据
 *
 *  @param request eLongHTTPReqeust
 *  @param data    网络请求下行解码数据
 */
- (void)eLongHTTPRequest:(eLongHTTPRequest *)request successWithData:(NSData *)data;
/**
 *  网络请求成功回传数据
 *
 *  @param request eLongHTTPRequest
 *  @param json    网络请求下行JSON数据
 */
- (void)eLongHTTPRequest:(eLongHTTPRequest *)request successWithJSON:(id)json;
/**
 *  网络请求失败
 *
 *  @param request eLongHTTPRequest
 *  @param error   报错信息
 */
- (void)eLongHTTPRequest:(eLongHTTPRequest *)request failureWithError:(NSError *)error;
/**
 *  网络请求被取消
 *
 *  @param request eLongHTTPRequest
 */
- (void)eLongHTTPRequestCanceled:(eLongHTTPRequest *)request;
/**
 *  网络请求数据发送进度
 *
 *  @param request eLongHTTPRequest
 *  @param process request数据发送进度
 */
- (void)eLongHTTPRequest:(eLongHTTPRequest *)request receviedRequestProcess:(float)process;
/**
 *  网络请求数据接收进度
 *
 *  @param request eLongHTTPRequest
 *  @param process response数据接收进度
 */
- (void)eLongHTTPRequest:(eLongHTTPRequest *)request receviedResponseProcess:(float)process;

@end
