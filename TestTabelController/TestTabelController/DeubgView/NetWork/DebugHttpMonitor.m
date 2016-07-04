//
//  DebugHttpMonitor.m
//  TestTabelController
//
//  Created by 王智刚 on 16/7/3.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugHttpMonitor.h"
#import "DebugURLSessionConfiguration.h"
#import "debugn"

static NSString * const netMonitorEnable = @"netMonitorEnable";
#define UserDefaults [NSUserDefaults standardUserDefaults]
@interface DebugHttpMonitor()

@end

@implementation DebugHttpMonitor
#pragma mark - private Mehtod


#pragma mark - public Mehtod
+ (void)setNetMonitorEnable:(BOOL)enable
{
    [UserDefaults setBool:enable forKey:netMonitorEnable];
    [UserDefaults synchronize];
    DebugURLSessionConfiguration *configuration = [DebugURLSessionConfiguration defaultConfiguration];
    
    if (enable) {
        [NSURLProtocol registerClass:[self class]];
        if (!configuration.isSwizzle) {
            [configuration load];
        }
    }else{
        [NSURLProtocol unregisterClass:[self class]];
        if (configuration.isSwizzle) {
            [configuration unload];
        }
    }
}

+ (BOOL)isEnable
{
    return [[UserDefaults valueForKey:netMonitorEnable] boolValue];
}

#pragma mark - superClass
+ (void)load
{

}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    //避免陷入重复构建request的死循环
    if ([NSURLProtocol propertyForKey:@"DebugHttpMonitor" inRequest:request] ) {
        return NO;
    }
    return YES;
}

//构建一个request
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *aRequest = request.mutableCopy;
    [NSURLProtocol setProperty:@YES forKey:@"DebugHttpMonitor" inRequest:aRequest];
    return aRequest.copy;
}

- (void)startLoading
{

}

- (void)stopLoading
{

}
@end
