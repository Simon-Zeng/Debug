//
//  eLongTokenReq.h
//  eLongLogin
//
//  Created by zhaoyingze on 15/7/29.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongTokenReq : NSObject

@property (nonatomic,copy) NSString *checkCode; // 防机器人刷新验证码

+ (id)shared;

/**
 *  获取跳入H5的url连接
 *
 *  @param appKey appKey
 *
 *  @return appKey参数的json串
 */
+ (NSString *)javaAppConfigWithAppKey:(NSString *)appKey;

/**
 *  获取accessToken的字符串
 *
 *  @return accessToken的字符串
 */
- (NSString *)accessToken;

/**
 *  获取refreshToken，目前已废弃，返回空字符
 *
 *  @return 目前已废弃，返回空字符
 */
- (NSString *)refreshToken;

/**
 *  获取sessionToken
 *
 *  @return 获取sessionToken的字符串
 */
- (NSString *)sessionToken;

/**
 *  保存sessionToken
 *
 *  @param newSessionToken 新的sessionToken
 */
- (void)saveSessionToken:(NSString *)newSessionToken;

- (void)setToken:(NSDictionary *)tokenInfo;

/**
 *  删除sessionToken
 */
- (void)deleteSessionToken;

/**
 *  发token过期通知
 */
- (void)postTokenExpiredNoti;

/**
 *  从服务器返回的url替换参数得到实际的h5连接(现金账户有关部分)
 *
 *  @param url h5链接
 *
 *  @return 替换后的h5链接
 */
- (NSString *)getCashAccountHtml5LinkFromString:(NSString *)url;

/**
 *  从服务器返回的url替换参数得到实际的h5连接(订单有关部分)
 *
 *  @param url   h5链接
 *  @param order 订单
 *
 *  @return 替换后的h5链接
 */
- (NSString *)getOrderHtml5LinkFromString:(NSString *)url OrderNumber:(NSString *)order;

/**
 *  清空所有token
 */
- (void)clearAllToken;

@end
