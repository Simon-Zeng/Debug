//
//  NetworkSerialization.h
//  TestTabelController
//
//  Created by wzg on 16/6/30.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkSerialization : NSObject
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
/**
 *  解析Object-C对象返回NSString
 *
 *  @param data NSData
 *
 *  @return JSON字符串
 */
+ (NSString *)jsonStringWithData:(NSData *)data;


@end
