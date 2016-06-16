//
//  eLongNetworkSerialization.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//
//  JSON解析模块，IOS5以上系统通过NSJSONSerialization解析，IOS5以下系统通过JSONKit解析

#import <Foundation/Foundation.h>

@interface eLongNetworkSerialization : NSObject
/**
 *  解析Object-C对象返回NSString
 *
 *  @param object oc对象,适用于nsarray，nsdictionary，string，自定义model类
 *
 *  @return JSON字符串
 */
+ (NSString *)jsonStringWithObject:(id)object;
/**
 *  解析Object-C对象返回NSData
 *
 *  @param object oc对象
 *
 *  @return JSON数据
 */
+ (NSData *)jsonDataWithObject:(id)object;
/**
 *  解析NSString返回Object-C对象
 *
 *  @param string NSString
 *
 *  @return Object-C对象
 */
+ (id) jsonObjectWithString:(NSString *)string;
/**
 *  解析NSData返回Object-对象
 *
 *  @param data NSData
 *
 *  @return Object-C对象
 */
+ (id) jsonObjectWithData:(NSData *)data;
@end
