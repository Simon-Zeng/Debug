//
//  eLongHTTPContentEncoding.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPContentEncoding.h"

@implementation eLongHTTPContentEncoding

/**
 *  子类必须重写此方法才可以使用
 *
 *  @param data
 *
 *  @return
 */
- (NSString *) decoding:(NSData *)data{
    return nil;
}

/**
 *  子类必须重写此方法才可使用
 *
 *  @param data
 *
 *  @return
 */
- (NSData *) decodingData:(NSData *)data{
    return nil;
}
@end
