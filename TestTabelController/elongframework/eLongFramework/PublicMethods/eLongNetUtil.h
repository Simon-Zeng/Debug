//
//  eLongNetUtil.h
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongNetUtil : NSObject

//==================原Public Methods=======================
// 处理压缩数据
//+ (NSDictionary *)unCompressData:(NSData *)data httpUtil:(HttpUtil *)httpUtil;

+ (NSDictionary *)unCompressData:(NSData *)data;

// 拼装请求Url(GET)
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service andParam:(NSString *)param;

// 拼装请求Url(POST)
+ (NSString *)composeNetSearchUrl:(NSString *)business forService:(NSString *)service;

// .net服务请求串拼接
+ (NSString *)requesString:(NSString *)actionName andIsCompress:(BOOL)iscompress andParam:(NSString *)param;

//==================原Public Methods=======================

//==================原Utils=======================
+(BOOL)checkJsonIsError:(NSDictionary *)root;
+(BOOL)checkJsonIsErrorNoAlert:(NSDictionary *)root;
+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate;			// 用于普通请求，超时时间较短
+ (void)orderRequest:(NSString *)url req:(NSString *)req delegate:(id)delegate;		// 用于订单的请求，超时时间较长
+(void)request:(NSString *)url req:(NSString *)req delegate:(id)delegate disablePop:(BOOL)disablePop disableClosePop:(BOOL)disableClosePop disableWait:(BOOL)disableWait;
//+ (void)request:(NSString *)url req:(NSString *)req policy:(CachePolicy)policy delegate:(id)delegate;

//==================原Utils=======================

// 用于非视图类显示loading框
+ (void)showLoadingView;

// 用于非视图类隐藏loading框
+ (void)dismissLoadingView;

@end
