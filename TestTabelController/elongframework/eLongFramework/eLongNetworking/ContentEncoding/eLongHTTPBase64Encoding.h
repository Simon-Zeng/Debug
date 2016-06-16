//
//  eLongHTTPBase64Encoding.h
//  eLongNetworking
//
//  Created by Dawn on 14-12-1.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPContentEncoding.h"

@interface eLongHTTPBase64Encoding : NSObject

/**
 *  数据编码为数据
 *
 *  @param data 原始数据
 *
 *  @return 编码后的字符串
 */
- (NSString *) encodingData:(NSData *)data;

/**
 *  字符串编码为数据
 *
 *  @param string 原始字符串
 *
 *  @return 编码后的数据
 */
- (NSData *) encoding:(NSString *)string;
@end
