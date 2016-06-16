//
//  eLongKeyChain.h
//  ElongClient
//
//  Created by top on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongKeyChain : NSObject

/**
 *  域名
 */
@property (nonatomic, copy, readonly) NSString *defaultDomain;

/**
 *  单例
 *
 *  @return eLongKeyChain单例对象
 */
+ (instancetype)sharedInstance;

/**
 *  设置域名
 *
 *  @param domain 域名
 */
+ (void)setDefaultDomain:(NSString *)domain;

/**
 *  读值（domain默认为nil）
 *
 *  @param key 值对应的key
 *
 *  @return 值
 */
+ (NSString *)readValueForKey:(NSString *)key;

/**
 *  读值
 *
 *  @param key    值对应的key
 *  @param domain 值所在域名
 *
 *  @return 值
 */
+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

/**
 *  写值（domain默认为nil）
 *
 *  @param value 值
 *  @param key   值对应的key
 */
+ (void)writeValue:(NSString *)value forKey:(NSString *)key;

/**
 *  写值
 *
 *  @param value  值
 *  @param key    值对应的key
 *  @param domain 值所在域名
 */
+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

/**
 *  删除某值（domain默认为nil）
 *
 *  @param key 值对应的key
 */
+ (void)deleteValueForKey:(NSString *)key;

/**
 *  删除某值
 *
 *  @param key    值对应的key
 *  @param domain 值所在域名
 */
+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain;

/**
 *  获取GUID
 *
 *  @return GUID
 */
+ (NSString *)GUIDString;

/**
 *  获取mac地址
 *
 *  @return mac地址
 */
+ (NSString *)macAddress;


@end
