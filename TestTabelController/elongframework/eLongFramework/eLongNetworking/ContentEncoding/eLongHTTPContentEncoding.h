//
//  eLongHTTPContentEncoding.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongHTTPContentEncoding : NSObject
/**
 *  数据解码为字符串
 *
 *  @param data 原始数据
 *
 *  @return 解码后的字符串
 */
- (NSString *) decoding:(NSData *)data; 

/**
 *  数据解码为数据
 *
 *  @param data 原始数据
 *
 *  @return 解码后的数据
 */
- (NSData *) decodingData:(NSData *)data;

@end
