//
//  eLongHTTPRequest.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//
//  完成网络请求的发起和请求数据的回调处理


#import <Foundation/Foundation.h>
#import "eLongHTTPRequestDelegate.h"
#import "eLongHTTPRequestOperation.h"

@interface eLongHTTPRequest : NSObject<eLongHTTPRequestOperationDelegate>
/**
 *  网络请求回调
 */
@property (nonatomic,weak) id<eLongHTTPRequestDelegate> delegate;
/**
 *  实例网络请求初始化方法
 *
 *  @param request NSURLRequest
 *
 *  @return eLongHTTPRequest实例
 */
- (eLongHTTPRequest *)initWithRequest:(NSURLRequest *)request;

/**
 *  实例网络请求初始化方法,block
 *
 *  @param request NSURLRequest
 *  @param success success block (eLongHTTPRequestOperation 实例,JSON对象)
 *  @param failure failure block (eLongHTTPRequestOperation 实例,error对象)
 *
 *  @return eLongHTTPRequest实例
 */
- (eLongHTTPRequest *)initWithRequest:(NSURLRequest *)request
                              success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  eLongHTTPRequest的单例网络请求
 *
 *  @param request         NSURLRequest
 *  @param contentEncoding 网络请求下行数据压缩格式
 *  @param delegate        delegate
 *
 *  @return eLongHTTPRequestOperation实例
 */
+ (eLongHTTPRequestOperation *)startRequest:(NSURLRequest *)request
                                    delegate:(id<eLongHTTPRequestDelegate>)delegate;
/**
 *  eLongHTTPRequest的单例网络请求
 *
 *  @param request         NSURLRequest
 *  @param contentEncoding 网络请求下行数据压缩格式
 *  @param success         success block (eLongHTTPRequestOperation 实例,JSON对象)
 *  @param failure         failure block (eLongHTTPRequestOperation 实例,error对象)
 *
 *  @return eLongHTTPRequestOperation实例
 */
+ (eLongHTTPRequestOperation *)startRequest:(NSURLRequest *)request
                                     success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  开始网络请求
 */
- (void)start;
/**
 *  取消当前网络请求
 */
- (void)cancel;
@end

