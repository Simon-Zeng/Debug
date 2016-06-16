//
//  eLongNetworkCache.h
//  eLongNetworking
//
//  Created by Dawn on 14-12-4.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  网络缓存模块，实现网络请求数据的缓存和读取，涉及缓存的过期和不同的缓存策略
 */
@interface eLongNetworkCache : NSObject
/**
 *  单例
 *
 *  @return 
 */
+ (instancetype) shareInstance;
/**
 *  读取缓存数据
 *
 *  @param request request
 *
 *  @return 缓存数据，无压缩，无加密
 */
- (NSData *) cacheForRequest:(NSURLRequest *)request;
/**
 *  缓存数据
 *
 *  @param data 无压缩，无加密的数据
 */
- (void) cacheData:(NSData *)data forRequest:(NSURLRequest *)request;
@end
