//
//  eLongUserDefault.h
//  ElongClient
//
//  Created by top on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongUserDefault : NSObject

/**
 *  读取存储值
 *
 *  @param defaultName 值对应的key
 *
 *  @return 值
 */
+ (id)objectForKey:(NSString *)defaultName;

/**
 *  存入值
 *
 *  @param value       值
 *  @param defaultName 值对应的key
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/**
 *  删除某值
 *
 *  @param defaultName 值对应的key
 */
+ (void)removeObjectForKey:(NSString *)defaultName;

/**
 *  删除所有的值
 */
+ (void)removeAllObjects;

/**
 *  是否key对应的值存在
 *
 *  @param key 值对应的对象
 *
 *  @return 是否存在
 */
+ (BOOL)hasObjectForKey:(id)key;

@end
