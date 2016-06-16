//
//  eLongTokenReq.m
//  eLongLogin
//
//  Created by zhaoyingze on 15/7/29.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongTokenReq.h"
#import "JsonKit.h"
#import "eLongUserDefault.h"
#import "eLongSettingManager.h"
#import "eLongAccountManager.h"
#import "eLongDefine.h"
#import "eLongTokenConfig.h"

static eLongTokenReq *request = nil;

@implementation eLongTokenReq

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_SESSIONTOKENEXPIRED object:nil];
    
}


+ (id)shared
{
    @synchronized(request)
    {
        if (!request)
        {
            request = [[eLongTokenReq alloc] init];
        }
    }
    
    return request;
}


+ (NSString *)javaAppConfigWithAppKey:(NSString *)appKey {
    
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setObject:appKey forKey:APP_KEY];
    
    return [content JSONString];
}

- (id)init
{
    if (self = [super init]) {
        
        
    }
    
    return self;
}


- (NSString *)accessToken
{
    return [self sessionToken];
}


- (NSString *)refreshToken
{
    return @"";
}

// 获取sessionToken
- (NSString *)sessionToken
{
    NSString *sessionToken = [eLongUserDefault objectForKey:SESSION_TOKEN];
    
    if (STRINGHASVALUE(sessionToken))
    {
        return sessionToken;
    }
    
    return @"";
}

// 保存sessionToken
- (void)saveSessionToken:(NSString *)newSessionToken
{
    if (STRINGHASVALUE(newSessionToken))
    {
        [eLongUserDefault setObject:newSessionToken forKey:SESSION_TOKEN];
        
        // 新网络框架赋值
        [eLongNetworkRequest sharedInstance].sessionToken = newSessionToken;
    }
}

// 删除sessionToken
- (void)deleteSessionToken
{
    // 新网络框架赋值
    [eLongNetworkRequest sharedInstance].sessionToken = nil;
    
    // 删除sessionToken
    [eLongUserDefault removeObjectForKey:SESSION_TOKEN];
    
    // 取消自动登录状态
    [[eLongSettingManager instanse] setAutoLogin:NO];
    [[eLongSettingManager instanse] clearPwd];
    
    //清空个人中心，我的钱包按钮上的数据
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_USERCASHINFOUPDATE object:nil];
}

// 发token过期通知
- (void)postTokenExpiredNoti
{
    // 发token过期通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SESSIONTOKENEXPIRED object:nil];
    
}

- (NSString *)getCashAccountHtml5LinkFromString:(NSString *)url
{
    if (STRINGHASVALUE(url))
    {
        url = [url stringByReplacingOccurrencesOfString:@"{0}" withString:@"1"];
        url = [self replaceCommonParameterFromString:url];
    }
    
    return url;
}


- (NSString *)getOrderHtml5LinkFromString:(NSString *)url OrderNumber:(NSString *)order
{
    if (STRINGHASVALUE(url))
    {
        url = [url stringByReplacingOccurrencesOfString:@"{0}" withString:order];
        url = [self replaceCommonParameterFromString:url];
    }
    
    return url;
}


- (NSString *)replaceCommonParameterFromString:(NSString *)url
{
    if (url)
    {
        url = [url stringByReplacingOccurrencesOfString:@"{1}" withString:[self accessToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{2}" withString:[self refreshToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{3}" withString:(STRINGHASVALUE([[eLongAccountManager userInstance] cardNo]))?[[eLongAccountManager userInstance] cardNo]:@""];
        url = [url stringByReplacingOccurrencesOfString:@"{4}" withString:[eLongNetworkRequest sharedInstance].channelID];
        url = [url stringByReplacingOccurrencesOfString:@"{5}" withString:@"1"];
        url = [url stringByReplacingOccurrencesOfString:@"{6}" withString:[NSString stringWithFormat:@"%@", APP_VERSION]];
        url = [url stringByReplacingOccurrencesOfString:@"{7}" withString:@"1"];
        url = [url stringByReplacingOccurrencesOfString:@"{8}" withString:[self sessionToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{9}" withString:[NSString stringWithFormat:@"%@", APP_VERSION]];
        url = [url stringByReplacingOccurrencesOfString:@"{10}" withString:[eLongNetworkRequest sharedInstance].clientType];
    }
    
    return url;
}

- (void)setToken:(NSDictionary *)tokenInfo
{
    if (STRINGHASVALUE([tokenInfo objectForKey:SESSION_TOKEN])) {
        
        [self saveSessionToken:[tokenInfo objectForKey:SESSION_TOKEN]];
    }
}

- (void)clearAllToken
{
    // 新网络框架赋值
    [eLongNetworkRequest sharedInstance].sessionToken = nil;
    
    // 删除sessionToken
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSION_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
