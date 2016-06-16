//
//  elongUrlComponents.m
//  BaiduSearchDemo
//
//  Created by ksy on 16/1/31.
//  Copyright © 2016年 ksy. All rights reserved.
//

#import "elongUrlComponents.h"
#import "eLongRoutes.h"
#import "eLongBus.h"

#define KelongUrlParams        @"params"
#define KelongUrlMv            @"mv"
#define KelongUrlCallbackf     @"callbackf"
#define KelongUrlParamArray [NSArray arrayWithObjects:KelongUrlParams,  KelongUrlMv,KelongUrlCallbackf,nil]

#define KiosService             @"iosService"
#define KelongServiceArray [NSArray arrayWithObjects:@"BackViewController",nil]
@implementation elongUrlComponents
+ (BOOL)canRouteURL:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    //版本兼容判断
    if (![self mvIsSupport:url]) {
        return NO;
    }
    //服务判断
    if ([url.host isEqualToString:KiosService]) {
        return NO;
    }
    
    NSURL *roteUrl = [self getRouteURL:url];
    //能否路由
   return  [eLongRoutes canRouteURL:roteUrl withParameters:nil];
}

+ (BOOL)mvIsSupport:(NSURL *)url
{
    NSDictionary *dic = [self getParamsfromUrl:[self decoding:url.absoluteString]  bykeys:KelongUrlParamArray];
    //含有MV判断
    if ([[dic allKeys] containsObject:KelongUrlMv]) {
        NSString *mv = [dic objectForKey:KelongUrlMv];
        NSString *currentMv = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        if ([mv compare:currentMv options:NSNumericSearch] == NSOrderedDescending) {
            return NO;
        }
    }
    return YES;
}

+ (NSURL *)getRouteURL:(NSURL *)url
{
    NSMutableString *routeString = [NSMutableString string];
    if (url.host) {
        [routeString appendString:url.host];
    }
    for (NSString *path in url.pathComponents) {
        [routeString appendString:path];
    }
    return routeString?[NSURL URLWithString:routeString]:nil;
}

+ (BOOL)routeURL:(NSURL *)url
{
    if ([self canRouteURL:url]) {
        NSURL *routeUrl = [self getRouteURL:url];
        NSDictionary *dic = [self getParamsfromUrl:[self decoding:url.absoluteString]  bykeys:KelongUrlParamArray];
        NSDictionary *optionDic = nil;
        if ([[dic allKeys] containsObject:KelongUrlParams] ) {
            id optionValue = [dic objectForKey:KelongUrlParams];
            if ([optionValue isKindOfClass:[NSString class]]) {
                NSError *error = nil;
                optionValue =  [NSJSONSerialization JSONObjectWithData:[optionValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                if (!error) {
                    if ([optionValue isKindOfClass:[NSDictionary class]]) {
                        optionDic = (NSDictionary *)optionValue;
                    }
                }
            }else if ([optionValue isKindOfClass:[NSDictionary class]]) {
                optionDic = (NSDictionary *)optionValue;
            }
        }
        return [self routeURL:routeUrl withParameters:optionDic];
    }
    return NO;
}


+ (NSMutableDictionary*)getParamsfromUrl:(NSString *)url bykeys:(NSArray *)array
{
    NSArray *queryElements = [[[url componentsSeparatedByString:@"?"] lastObject] componentsSeparatedByString:@"&"];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:@"="];
        if (keyVal.count > 0) {
            NSString * key = [keyVal objectAtIndex:0];
            if(key != nil && [array containsObject:key]){
                [params setObject:(keyVal.count == 2) ? [keyVal lastObject] : @"" forKey:key];
            }
        }
    }
    return params;
}

+ (BOOL)routeURL:(NSURL *)url withParameters:(NSDictionary *)parameters
{
    if (!url) {
        return NO;
    }
    //之前的 路由hotel/searchHotelList
    if([url.absoluteString isEqualToString:@"hotel/searchHotelList"]){
        if (!parameters) {
            parameters = [[NSDictionary alloc] init];
        }
        [eLongServices callService:@"HotelList", @"", @"",@"",parameters, nil];
        return YES;
    }else{
        return  [eLongRoutes routeURL:url withParameters:parameters];
        
    }
}

+ (NSString *)decoding:(NSString *)string
{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)string,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}

+ (BOOL)needCallBack:(NSURL *)url;
{
    NSDictionary *dic = [self getParamsfromUrl:[self decoding:url.absoluteString]  bykeys:KelongUrlParamArray];
    if ([[dic allKeys] containsObject:KelongUrlCallbackf]) {
        NSString *backType = [dic objectForKey:KelongUrlCallbackf];
        if (backType && backType.length > 0) {
            return YES;
        }
    }
    return NO;
}

+ (void)callBack:(NSURL *)url success:(void (^)(NSDictionary *dic))success
         failure:(void (^)(NSError *error))failure
{
    NSDictionary *dic = [self getParamsfromUrl:[self decoding:url.absoluteString]  bykeys:KelongUrlParamArray];
    if ([[dic allKeys] containsObject:KelongUrlCallbackf]) {
        NSString *backType = [dic objectForKey:KelongUrlCallbackf];
        if (backType && backType.length > 0) {
            //调用服务
//           backType
                success(dic);
        }
    }
    failure([NSError errorWithDomain:@"不支持回调" code:110 userInfo:nil]);
}


+ (BOOL)needService:(NSURL *)url
{
    if ([url.host isEqualToString:KiosService]) {
        if (![self mvIsSupport:url]) {
            return NO;
        }
        
        NSMutableString *routeString = [NSMutableString string];
        for (NSString *path in url.pathComponents) {
            [routeString appendString:path];
        }
        if ([routeString hasPrefix:@"/"]) {
            [routeString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if ([KelongServiceArray containsObject:routeString]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)callService:(NSURL *)url
{
    if ([url.host isEqualToString:KiosService]) {
        NSMutableString *routeString = [NSMutableString string];
        for (NSString *path in url.pathComponents) {
            [routeString appendString:path];
        }
        if ([routeString hasPrefix:@"/"]) {
            [routeString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        if ([KelongServiceArray containsObject:routeString]) {
           NSUInteger index = [KelongServiceArray indexOfObject:routeString];
            switch (index) {
                case 0:{
                     NSDictionary *dic = [self getParamsfromUrl:[self decoding:url.absoluteString]  bykeys:KelongUrlParamArray];
                    if ([[dic allKeys] containsObject:KelongUrlParams]) {
                        NSDictionary *params = nil;
                        id optionValue = [dic objectForKey:KelongUrlParams];
                        if ([optionValue isKindOfClass:[NSString class]]) {
                            NSError *error = nil;
                            optionValue =  [NSJSONSerialization JSONObjectWithData:[optionValue dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                            if (!error) {
                                if ([optionValue isKindOfClass:[NSDictionary class]]) {
                                    params = (NSDictionary *)optionValue;
                                }
                            }
                        }
                        if ([[params allKeys] containsObject:@"type"]) {
                            NSString *type = [params objectForKey:@"type"];
                            if ([type isEqualToString: @"PopOrDismssViewController"] ) {
                                if ([eLongBus bus].navigationController && [eLongBus bus].navigationController.viewControllers.count && [eLongBus bus].rootViewController.viewControllers.count > 1/*非首页一级页面*/) {
                                    if ([eLongBus bus].navigationController.viewControllers.count > 1) {
                                        if ([[eLongBus bus].navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                                              [[eLongBus bus].navigationController popViewControllerAnimated:YES];
                                            return YES;
                                        }else if ([[eLongBus bus].navigationController.topViewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)] ){
                                            [[eLongBus bus].navigationController.topViewController dismissViewControllerAnimated:YES completion:^{
                                                
                                            }];
                                            return YES;
                                        }
                                    }
                                }else{
                                    //返回首页
                                    [[eLongBus bus].rootViewController popToRootViewControllerAnimated:YES];
                                    [[eLongBus bus].navigationController popToRootViewControllerAnimated:NO];
                                    [eLongBus bus].navigationController = nil;
                                    return YES;
                                }
                            }else if ([type isEqualToString: @"BackHomeViewController"] ){
                                //返回首页
                                [[eLongBus bus].rootViewController popToRootViewControllerAnimated:YES];
                                [[eLongBus bus].navigationController popToRootViewControllerAnimated:NO];
                                [eLongBus bus].navigationController = nil;
                                return YES;

                            }
                        }
                    }

                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    return NO;
}

@end
