//
//  eLongNetworkRequest.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongNetworkRequest.h"
#import "eLongNetworkSerialization.h"
#import "eLongHTTPURLEncoding.h"
#import "eLongHTTPAESEncoding.h"
#import <CommonCrypto/CommonDigest.h>
#import "eLongDebugManager.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <UIKit/UIKit.h>
#import "eLongLocation.h"
#import "eLongAnalyticsGlobalModel.h"
#import "eLongConfiguration.h"
#import "eLongNetworkDynamicCommunication.h"
#import "eLongDefine.h"
#import "NSString+eLongExtension.h"

@interface eLongNetworkRequest ()

@property (nonatomic,strong) CTTelephonyNetworkInfo *networkInfo;

@property (nonatomic, assign) BOOL isDynamicCommunication;

@end

@implementation eLongNetworkRequest
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

-(CTTelephonyNetworkInfo *)networkInfo{
    if (_networkInfo == nil) {
        _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    
    return _networkInfo;
}
/**
 *  拼接GET请求的URL参数
 *
 *  @param dict 字典参数
 *
 *  @return "&"分割的URL字符串
 */
- (NSString *) paramsUrl:(NSDictionary *)dict{
    NSMutableString *paramsString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < dict.allKeys.count; i++) {
        NSString *key = [dict.allKeys objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        if (i == dict.allKeys.count - 1) {
            // 最后一位
            [paramsString appendFormat:@"%@=%@",key,value];
        }else{
            // 其他位置
            [paramsString appendFormat:@"%@=%@&",key,value];
        }
    }
    return paramsString;
}

/**
 *  GUID
 *
 *  @return GUID
 */
- (NSString *) randomId{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *guid = (__bridge NSString *)string;
    NSString *guidCopy = [guid copy];
    CFRelease(string);
    return guidCopy;
}

/**
 *  MD5
 *
 *  @return MD5
 */
- (NSString *)md5:(NSString *)string{
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

/**
 *  .net POST请求的Body构造
 *
 *  @return Body
 */
- (NSString *) postBody:(NSDictionary *)params{
    // header
    NSMutableDictionary *header = [[NSMutableDictionary alloc] init];
    [header setValue:self.channelID forKey:@"ChannelId"];
    [header setValue:self.deviceID forKey:@"DeviceId"];
    [header setValue:self.authCode forKey:@"AuthCode"];
    [header setValue:self.clientType forKey:@"ClientType"];
    [header setValue:self.version forKey:@"Version"];
    [header setValue:self.osVersion forKey:@"OsVersion"];
    [header setValue:self.guid forKey:@"Guid"];
    [header setValue:self.sessionToken forKey:@"SessionToken"];
    [header setValue:self.checkCode forKey:@"CheckCode"];
    [header setValue:self.userTraceId forKey:@"UserTraceId"];
    [header setValue:self.phoneBrand forKey:@"PhoneBrand"];
    [header setValue:self.phoneModel forKey:@"PhoneModel"];
    [header setValue:[NSString stringWithFormat:@"%f", [eLongLocation sharedInstance].coordinate.longitude] forKey:@"Longitude"];
    [header setValue:[NSString stringWithFormat:@"%f", [eLongLocation sharedInstance].coordinate.latitude] forKey:@"Latitude"];
    [header setValue:[[NSBundle mainBundle] bundleIdentifier] forKey:@"AppName"];
    [header setValue:[self getNetWorkStates] forKey:@"Network"];
    [header setValue:self.networkInfo.subscriberCellularProvider.carrierName forKey:@"Carrier"];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *dimension = [NSString stringWithFormat:@"%.f*%.f",SCREEN_WIDTH * scale,SCREEN_HEIGHT * scale];
    [header setValue:dimension forKey:@"dimension"];

  
    
    // 新增头部信息longitude和latitude
    
    // 新增mvt、if、of、chid字段
    eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
    eLongConfiguration *configuration = [eLongConfiguration sharedInstance];
    [header setValue:globalModel.ch forKey:@"Channel"];
    [header setValue:globalModel.chid forKey:@"ChId"];
    [header setValue:globalModel.aif forKey:@"InnerFrom"];
    [header setValue:globalModel.of forKey:@"OuterFrom"];
    [header setValue:[configuration getJSONStringOfMVTConfigList] forKey:@"MvtConfig"];
    
    // body
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] initWithDictionary:params];
    [bodyDict setValue:header forKey:@"Header"];
    
    return [self urlEncoding:[eLongNetworkSerialization jsonStringWithObject:bodyDict]];
}

/**
 *  URL编码
 *
 *  @param url 原始URL
 *
 *  @return 编码后的URL
 */
- (NSString *) urlEncoding:(NSString *)url{
    eLongHTTPURLEncoding *urlEncoding = [[eLongHTTPURLEncoding alloc] init];
    return [urlEncoding encoding:url];
}

/**
 *  AES加密
 *
 *  @param plainSourceStringToEncrypt 加密前数据
 *  @param customKey                  AES key
 *
 *  @return 加密后数据
 */
- (NSString *)encryptString:(NSString *)plainSourceStringToEncrypt byKey:(NSString *)customKey{
    if (self.isDynamicCommunication) {
        customKey = [[eLongNetworkDynamicCommunication sharedInstance] fetchAesKey];
    }
    eLongHTTPAESEncoding *aesEncoding = [[eLongHTTPAESEncoding alloc] init];
    return [aesEncoding encryptString:plainSourceStringToEncrypt byKey:customKey];
}

- (NSURLRequest *) dotNetRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding{
    return [self dotNetRequest:target params:params method:method encoding:encoding cache:eLongNetworkCacheNone cacheTimeInterval:0];
}

- (NSURLRequest *) dotNetRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval{
    // request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // target url
    NSMutableString *targetUrl = [[NSMutableString alloc] init];
    if (method == eLongNetworkRequestMethodGET) {
        NSString *url = [target copy];
        NSRange range0 = [url rangeOfString:@"?"];
        NSRange range1 = [url rangeOfString:@"&"];
        if (range0.length) {
            // 包含"?"
            if (range0.location == url.length - 1) {
                // 包含"?"，且"?"就在结尾处
                [targetUrl appendFormat:@"%@%@&%@&randomId=%@",url,[self paramsUrl:params],(encoding ? @"compress=true" : @"compress=false"),[self randomId]];
            }else{
                if (range1.length) {
                    // 包含"&"
                    if (range1.location == url.length - 1) {
                        // 包含"&"，且"&"就在结尾处
                        [targetUrl appendFormat:@"%@%@&%@&randomId=%@",url,[self paramsUrl:params],(encoding ? @"compress=true" : @"compress=false"),[self randomId]];
                    }else{
                        // 包含"&"，且"&"不在结尾处
                        [targetUrl appendFormat:@"%@&%@&%@&randomId=%@",url,[self paramsUrl:params],(encoding ? @"compress=true" : @"compress=false"),[self randomId]];
                    }
                }
            }
        }else{
            // 不包含"?"
            [targetUrl appendFormat:@"%@?%@&%@&randomId=%@",url,[self paramsUrl:params],(encoding?@"compress=true":@"compress=false"),[self randomId]];
        }
        
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置压缩方式，告诉网络请求模块是否要进行解压缩
        [request setValue:(encoding ? @"lzss" : @"none") forHTTPHeaderField:@"compress"];
        // 设置请求方法为GET
        [request setHTTPMethod:@"GET"];
        // 设置缓存策略
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        // 设置超时时间
        request.timeoutInterval = 15.0f;
        return request;
    }else if(method == eLongNetworkRequestMethodPOST){
        if (!self.server || !self.server.length) {
            return nil;
        }
        // 分割target
        NSArray *targetArray = [target componentsSeparatedByString:@"?"];
        if (targetArray.count == 2) {
            if ([[self.server substringFromIndex:self.server.length - 1] isEqualToString:@"/"]) {
                // 以"/"结尾
                [targetUrl appendFormat:@"%@%@?randomId=%@",self.server,[targetArray objectAtIndex:0],[self randomId]];
            }else{
                [targetUrl appendFormat:@"%@/%@?randomId=%@",self.server,[targetArray objectAtIndex:0],[self randomId]];
            }
            NSString *body = [NSString stringWithFormat:@"%@&%@&req=%@",[targetArray objectAtIndex:1],(encoding?@"compress=true":@"compress=false"),[self postBody:params]];
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            // 设置post body
            [request setHTTPBody:data];
        }else{
            [targetUrl appendFormat:@"%@/%@?randomId=%@",self.server,target,[self randomId]];
            NSString *body = [NSString stringWithFormat:@"%@&req=%@",(encoding?@"compress=true":@"compress=false"),[self postBody:params]];
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            // 设置post body
            [request setHTTPBody:data];
            
        }
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置压缩方式，告诉网络请求模块是否需要进行解压缩
        [request setValue:(encoding ? @"lzss" : @"none") forHTTPHeaderField:@"compress"];
        // 设置请求方法为POST
        [request setHTTPMethod:@"POST"];
        // 设置缓存策略
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        // 设置超时时间
        request.timeoutInterval = 30.0f;
        return request;
    }
    
    // 设置缓存策略，网络请求模块使用后记得删除
    [request setValue:[NSString stringWithFormat:@"%d",(int)cache] forHTTPHeaderField:@"_eLongNetworkCache"];
    [request setValue:[NSString stringWithFormat:@"%f",cacheTimeInterval] forHTTPHeaderField:@"_eLongNetworkCacheTimeInterval"];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",target,[eLongNetworkSerialization jsonStringWithObject:params]];
    [request setValue:[self md5:cacheKey] forHTTPHeaderField:@"_eLongNetworkCacheKey"];
    return nil;
}

- (NSURLRequest *) dotNewNetRequest:(NSString *)target params:(NSString *)params method:(eLongNetworkRequestMethod)method encoding:(BOOL)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval{
    // request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // target url
    NSMutableString *targetUrl = [[NSMutableString alloc] init];
    if (method == eLongNetworkRequestMethodGET) {
        NSString *url = [target copy];
        NSRange range0 = [url rangeOfString:@"?"];
        NSRange range1 = [url rangeOfString:@"&"];
        if (range0.length) {
            // 包含"?"
            if (range0.location == url.length - 1) {
                // 包含"?"，且"?"就在结尾处
                [targetUrl appendFormat:@"%@%@&randomId=%@",url,params,[self randomId]];
            }else{
                if (range1.length) {
                    // 包含"&"
                    if (range1.location == url.length - 1) {
                        // 包含"&"，且"&"就在结尾处
                        [targetUrl appendFormat:@"%@%@&randomId=%@",url,params,[self randomId]];
                    }else{
                        // 包含"&"，且"&"不在结尾处
                        [targetUrl appendFormat:@"%@&%@&randomId=%@",url,params,[self randomId]];
                    }
                }
            }
        }else{
            // 不包含"?"
            [targetUrl appendFormat:@"%@?%@&randomId=%@",url,params,[self randomId]];
        }
        
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置压缩方式，告诉网络请求模块是否要进行解压缩
        [request setValue:(encoding ? @"lzss" : @"none") forHTTPHeaderField:@"compress"];
        // 设置请求方法为GET
        [request setHTTPMethod:@"GET"];
        // 设置缓存策略
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        // 设置超时时间
        request.timeoutInterval = 15.0f;
        return request;
    }else if(method == eLongNetworkRequestMethodPOST){
        if (!self.server || !self.server.length) {
            return nil;
        }
        // 分割target
        NSArray *targetArray = [target componentsSeparatedByString:@"?"];
        if (targetArray.count == 2) {
            if ([[self.server substringFromIndex:self.server.length - 1] isEqualToString:@"/"]) {
                // 以"/"结尾
                [targetUrl appendFormat:@"%@%@?randomId=%@",self.server,[targetArray objectAtIndex:0],[self randomId]];
            }else{
                [targetUrl appendFormat:@"%@/%@?randomId=%@",self.server,[targetArray objectAtIndex:0],[self randomId]];
            }
            NSString *body = [NSString stringWithFormat:@"%@&%@&req=%@",[targetArray objectAtIndex:1],(encoding?@"compress=true":@"compress=false"),params];
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            // 设置post body
            [request setHTTPBody:data];
        }else{
            [targetUrl appendFormat:@"%@?randomId=%@",target,[self randomId]];
            NSString *body = [NSString stringWithFormat:@"%@",params];
            NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
            // 设置post body
            [request setHTTPBody:data];
        }
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置压缩方式，告诉网络请求模块是否需要进行解压缩
        [request setValue:(encoding ? @"lzss" : @"none") forHTTPHeaderField:@"compress"];
        // 设置请求方法为POST
        [request setHTTPMethod:@"POST"];
        // 设置缓存策略
        request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        // 设置超时时间
        request.timeoutInterval = 30.0f;
        return request;
    }
    
    // 设置缓存策略，网络请求模块使用后记得删除
    [request setValue:[NSString stringWithFormat:@"%d",(int)cache] forHTTPHeaderField:@"_eLongNetworkCache"];
    [request setValue:[NSString stringWithFormat:@"%f",cacheTimeInterval] forHTTPHeaderField:@"_eLongNetworkCacheTimeInterval"];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",target,[eLongNetworkSerialization jsonStringWithObject:params]];
    [request setValue:[self md5:cacheKey] forHTTPHeaderField:@"_eLongNetworkCacheKey"];
    return nil;
}


- (NSURLRequest *)javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method{
    return [self javaRequest:target params:params method:method encoding:eLongNetworkEncodingGNUZip cache:eLongNetworkCacheNone cacheTimeInterval:0];
}

- (NSURLRequest *) javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(eLongNetworkContentEncoding)encoding{
    return [self javaRequest:target params:params method:method encoding:encoding cache:eLongNetworkCacheNone cacheTimeInterval:0];
}

- (NSURLRequest *)javaRequest:(NSString *)target params:(NSDictionary *)params method:(eLongNetworkRequestMethod)method encoding:(eLongNetworkContentEncoding)encoding cache:(eLongNetworkContentCache)cache cacheTimeInterval:(NSTimeInterval)cacheTimeInterval{
    if (!self.server || !self.server.length) {
        return nil;
    }
    // request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // target url
    NSMutableString *targetUrl = [[NSMutableString alloc] init];
    if ([[self.server substringFromIndex:self.server.length - 1] isEqualToString:@"/"]) {
        // 以"/"结尾
        [targetUrl appendFormat:@"%@%@",self.server,target];
    }else{
        [targetUrl appendFormat:@"%@/%@",self.server,target];
    }
    self.isDynamicCommunication = [[eLongNetworkDynamicCommunication sharedInstance] checkApiTitleEnabled:target];
    if (method == eLongNetworkRequestMethodPOST) {
        // post
        //[targetUrl appendFormat:@"?randomId=%@",[self randomId]];
        // post请求需要对参数也加密编码
        NSString *body = [self urlEncoding:[self encryptString:[eLongNetworkSerialization jsonStringWithObject:params] byKey:self.javaKey]];
        NSData *bodyData = [[NSString stringWithFormat:@"req=%@", body] dataUsingEncoding:NSUTF8StringEncoding];
        
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置post body
        [request setHTTPBody:bodyData];
        // 设置请求方法为POST
        [request setHTTPMethod:@"POST"];
        
    }else{
        // get、put、delete等
        // json->encrypt->urlencoding
        NSString *body = [self urlEncoding:[self encryptString:[eLongNetworkSerialization jsonStringWithObject:params] byKey:self.javaKey]];
        [targetUrl appendFormat:@"?req=%@&randomId=%@",body,[self randomId]];
        // 设置URL
        [request setURL:[NSURL URLWithString:targetUrl]];
        // 设置请求方法
        if (method == eLongNetworkRequestMethodPUT) {
            [request setHTTPMethod:@"PUT"];
        }else if(method == eLongNetworkRequestMethodGET){
            [request setHTTPMethod:@"GET"];
        }else if(method == eLongNetworkRequestMethodDELETE){
            [request setHTTPMethod:@"DELETE"];
        }
    }
    // 设置压缩方式，告诉网络请求模块是否需要进行解压缩
    if (encoding == eLongNetworkEncodingGNUZip) {
        [request setValue:@"gzip" forHTTPHeaderField:@"compress"];
    }else if(encoding == eLongNetworkEncodingLZSS){
        [request setValue:@"lzss" forHTTPHeaderField:@"compress"];
    }else{
        [request setValue:@"none" forHTTPHeaderField:@"compress"];
    }
    // 设置缓存策略
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    // 设置超时时间
    request.timeoutInterval = 30.0f;
    
    // 设置header
    [request setValue:self.channelID forHTTPHeaderField:@"channelid"];
    [request setValue:self.version forHTTPHeaderField:@"version"];
    [request setValue:self.deviceID forHTTPHeaderField:@"deviceid"];
    [request setValue:self.authCode forHTTPHeaderField:@"AuthCode"];
    [request setValue:self.clientType forHTTPHeaderField:@"ClientType"];
    [request setValue:self.osVersion forHTTPHeaderField:@"OsVersion"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.sessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:self.checkCode forHTTPHeaderField:@"CheckCode"];
    [request setValue:self.guid forHTTPHeaderField:@"Guid"];
    [request setValue:self.userTraceId forHTTPHeaderField:@"UserTraceId"];
    [request setValue:self.phoneBrand forHTTPHeaderField:@"PhoneBrand"];
    [request setValue:self.phoneModel forHTTPHeaderField:@"PhoneModel"];
    [request setValue:[NSString stringWithFormat:@"%f", [eLongLocation sharedInstance].coordinate.longitude] forHTTPHeaderField:@"Longitude"];
    [request setValue:[NSString stringWithFormat:@"%f", [eLongLocation sharedInstance].coordinate.latitude] forHTTPHeaderField:@"Latitude"];
    [request setValue:[[NSBundle mainBundle] bundleIdentifier] forHTTPHeaderField:@"AppName"];
    [request setValue:[self getNetWorkStates] forHTTPHeaderField:@"Network"];
    [request setValue:self.networkInfo.subscriberCellularProvider.carrierName forHTTPHeaderField:@"Carrier"];
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *dimension = [NSString stringWithFormat:@"%.f*%.f",SCREEN_WIDTH * scale,SCREEN_HEIGHT * scale];
    [request setValue:dimension forHTTPHeaderField:@"dimension"];
    if (self.isDynamicCommunication) {
        [request setValue:[[eLongNetworkDynamicCommunication sharedInstance] fetchSessionKey] forHTTPHeaderField:@"sessionkey"];
        /*暂时注掉
        NSString *aesKey = [[eLongNetworkDynamicCommunication sharedInstance] fetchAesKey];
        if (STRINGHASVALUE(aesKey)) {
            [request setValue:[NSString reverse:aesKey] forHTTPHeaderField:@"Browser"];
        }
        */
    }
    // 新增mvt、if、of、chid字段
    eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
    eLongConfiguration *configuration = [eLongConfiguration sharedInstance];
    [request setValue:globalModel.ch forHTTPHeaderField:@"Channel"];
    [request setValue:globalModel.chid forHTTPHeaderField:@"ChId"];
    [request setValue:globalModel.aif forHTTPHeaderField:@"InnerFrom"];
    [request setValue:globalModel.of forHTTPHeaderField:@"OuterFrom"];
    [request setValue:[configuration getJSONStringOfMVTConfigList] forHTTPHeaderField:@"MvtConfig"];
    
    // 设置缓存策略，网络请求模块使用后记得删除
    [request setValue:[NSString stringWithFormat:@"%d",(int)cache] forHTTPHeaderField:@"_eLongNetworkCache"];
    [request setValue:[NSString stringWithFormat:@"%f",cacheTimeInterval] forHTTPHeaderField:@"_eLongNetworkCacheTimeInterval"];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@",target,[eLongNetworkSerialization jsonStringWithObject:params]];
    [request setValue:[self md5:cacheKey] forHTTPHeaderField:@"_eLongNetworkCacheKey"];
    
    // 设置请求的原始参数
    if ([eLongDebugManager networkInstance].enabled) {
        [request setValue:[self urlEncoding:[eLongNetworkSerialization jsonStringWithObject:params]] forHTTPHeaderField:@"_eLongNetworkParams"];
    }
    return request;
}

- (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"None";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 4:
                    state = @"5G";
                    break;
                case 5:
                {
                    state = @"Wifi";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

@end
