//
//  eLongDevice.m
//  eLongFramework
//
//  Created by zhaoyingze on 15/10/29.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongDevice.h"
#import "eLongDefine.h"
#import "eLongUserDefault.h"
#import "eLongHTTPRequest.h"
#import "eLongFileIOUtils.h"
#import "eLongNetworkRequest.h"
#import <libkern/OSAtomic.h>
#import "eLongNetUtil.h"

#define kTouchIdFlag @"touchid"

@implementation eLongDevice

+ (BOOL)isSupportTouchID
{
    if (!IOSVersion_8) {
        
        return NO;
    }
    
    // 初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    // 错误对象
    NSError* error = nil;
    
    // 判断设备支持状态
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

+ (void)hasSetTouchIdForPayment:(NSString *)cardNo callback:(void (^)(BOOL))callback
{
    if (!STRINGHASVALUE(cardNo)) {
        
        callback(NO);
        
        return;
    }
    
    [eLongNetUtil showLoadingView];
    
    [eLongDevice getTouchIdSwitchStatus:cardNo type:[NSNumber numberWithInt:1] success:^(id responseObject) {
        
        [eLongNetUtil dismissLoadingView];
        
        if ([eLongNetUtil checkJsonIsErrorNoAlert:responseObject]) {
            
            callback(NO);
        }
        else {
            
            NSInteger flag = [[responseObject safeObjectForKey:@"isActive"] integerValue];
            
            if (flag == 0 || flag == 1) {
                
                callback(YES);
            }
            else {
                
                callback(NO);
            }
        }
        
    } failure:^(NSString *errorDesc) {
        
        [eLongNetUtil dismissLoadingView];
        
        callback(NO);
    }];
}

+ (void)getStatusOfTouchIdForPayment:(NSString *)cardNo callback:(void (^)(BOOL))callback
{
    if (!STRINGHASVALUE(cardNo)) {
        
        callback(NO);
    }
    
    [eLongNetUtil showLoadingView];
    
    [eLongDevice getTouchIdSwitchStatus:cardNo type:[NSNumber numberWithInt:1] success:^(id responseObject) {
        
        [eLongNetUtil dismissLoadingView];
        
        if ([eLongNetUtil checkJsonIsErrorNoAlert:responseObject]) {
            
            callback(NO);
        }
        else {
            
            NSInteger flag = [[responseObject safeObjectForKey:@"isActive"] integerValue];
            
            if (flag == 1) {
                
                callback(YES);
            }
            else {
                
                callback(NO);
            }
        }
        
    } failure:^(NSString *errorDesc) {
        
        [eLongNetUtil dismissLoadingView];
        
        callback(NO);
        
    }];
}

+ (void)setStatusOfTouchIdForPayment:(BOOL)status cardNo:(NSString *)cardNo callback:(void (^)(BOOL, BOOL))callback
{
    if (!STRINGHASVALUE(cardNo)) {
        
        callback(NO,NO);
    }
    
    __block BOOL success = NO;
    __block BOOL isOpen = NO;
    
    [eLongNetUtil showLoadingView];
    
    [eLongDevice setTouchIdSwitchStatus:cardNo type:[NSNumber numberWithInt:1] status:[NSNumber numberWithInteger:status] success:^(id responseObject) {
        
        [eLongNetUtil dismissLoadingView];
        
        if (![eLongNetUtil checkJsonIsErrorNoAlert:responseObject]) {
            
            success = [[responseObject safeObjectForKey:@"isSuccess"] boolValue];
            isOpen = [[responseObject safeObjectForKey:@"isActive"] boolValue];
        }
        
        callback(success,isOpen);
        
    } failure:^(NSString *errorDesc) {
        
        [eLongNetUtil dismissLoadingView];
        
        callback(NO,NO);
    }];
}

+ (void)getTouchIdSwitchStatus:(NSString *)cardNo
                          type:(NSNumber *)type
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSString *errorDesc))failure
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    
    [content safeSetObject:cardNo forKey:@"cardNo"];
    [content safeSetObject:type forKey:@"classify"];
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/getUserFingerprintInfo"
                                                                       params:content
                                                                       method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            
            failure(error.localizedDescription);
        }
    }];
}

+ (void)setTouchIdSwitchStatus:(NSString *)cardNo
                          type:(NSNumber *)type
                        status:(NSNumber *)status
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSString *errorDesc))failure
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    
    [content safeSetObject:cardNo forKey:@"cardNo"];
    [content safeSetObject:type forKey:@"classify"];
    [content safeSetObject:status forKey:@"isActive"];
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/userFingerprintInfo"
                                                                       params:content
                                                                       method:eLongNetworkRequestMethodPOST];
    
    [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
        
    } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            
            failure(error.localizedDescription);
        }
    }];
}

@end
