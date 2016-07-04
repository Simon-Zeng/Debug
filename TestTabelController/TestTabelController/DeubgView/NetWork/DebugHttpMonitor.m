//
//  DebugHttpMonitor.m
//  TestTabelController
//
//  Created by 王智刚 on 16/7/3.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugHttpMonitor.h"
#import "DebugURLSessionConfiguration.h"
#import "NetWork.h"
#import "DebugNetWork.h"
#import "DebugManager.h"
#import "NetworkSerialization.h"

static NSString * const netMonitorEnable = @"netMonitorEnable";
static NSString * const netflowCount = @"netflowCount";
#define UserDefaults [NSUserDefaults standardUserDefaults]
@interface DebugHttpMonitor()<NSURLConnectionDataDelegate>
@property (nonatomic, strong)NetWork *netWorkModel;
@property (nonatomic, strong)NSURLConnection *connection;
@property (nonatomic, strong)NSURLResponse *response;
@property (nonatomic, strong)NSMutableData *data;

@end

@implementation DebugHttpMonitor
//@synthesize ne
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
    self.data = [NSMutableData data];
    
    //忽略废弃
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
#pragma clang diagnostic pop
    DebugNetWork *debugNet = [DebugManager networkInstance];
    debugNet.enable = YES;
    NetWork *net = [debugNet beginRequest];
    net.beginDate = [NSDate date];
    double randomNum = ((double)(arc4random()%100))/10000;
    //为所有model建立索引,为了检索
    net.netId = [NSNumber numberWithDouble:[net.beginDate timeIntervalSince1970] + randomNum];
    _netWorkModel = net;
    
    [self setupNetWorkWithRequest:self.request];
    
}


- (void)stopLoading
{
    _netWorkModel.endDate = [NSDate date];
    _netWorkModel.size = @(self.data.length);
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)_response;
    _netWorkModel.statusCode = [NSNumber numberWithInteger:httpResponse.statusCode];
    
    NSString *mimeType = self.response.MIMEType;
    if ([mimeType isEqualToString:@"application/json"]) {
        _netWorkModel.data = [NetworkSerialization jsonStringWithData:self.data.copy];
    } else if ([mimeType isEqualToString:@"text/javascript"]) {
        // try to parse json if it is jsonp request
        NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        // formalize string
        if ([jsonString hasSuffix:@")"]) {
            jsonString = [NSString stringWithFormat:@"%@;", jsonString];
        }
        if ([jsonString hasSuffix:@");"]) {
            NSRange range = [jsonString rangeOfString:@"("];
            if (range.location != NSNotFound) {
                range.location++;
                range.length = [jsonString length] - range.location - 2; // removes parens and trailing semicolon
                jsonString = [jsonString substringWithRange:range];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                _netWorkModel.data = [NetworkSerialization jsonStringWithData:jsonData];
            }
        }
        
    }else if ([mimeType isEqualToString:@"application/xml"] ||[mimeType isEqualToString:@"text/xml"]){
        NSString *xmlString = [[NSString alloc]initWithData:self.data encoding:NSUTF8StringEncoding];
        if (xmlString && xmlString.length>0) {
            _netWorkModel.data = xmlString;
        }
    }
    
    //总的流量消耗
    double flowCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"flowCount"] doubleValue];
    if (!flowCount) {
        flowCount=0.0;
    }
    flowCount=flowCount+self.response.expectedContentLength/(1024.0*1024.0);
    [[NSUserDefaults standardUserDefaults] setDouble:flowCount forKey:netflowCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DebugNetWork *debugNet = [DebugManager networkInstance];
    [debugNet endRequest:_netWorkModel];
    
}

#pragma mark - URLConnectionDelegate
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if (response != nil){
        self.response = response;
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!data) return;
    [self.data appendData:data];
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

#pragma mark - private Mehtod
- (void)setupNetWorkWithRequest:(NSURLRequest *)request
{
    if (!_netWorkModel) return;
    if (!request) return;
    //post请求得数据
    _netWorkModel.path = request.URL.absoluteString;
    _netWorkModel.body = [NetworkSerialization jsonStringWithData:request.HTTPBody];
    _netWorkModel.method = request.HTTPMethod;
    _netWorkModel.header = [NetworkSerialization jsonStringWithObject:request.allHTTPHeaderFields];
    _netWorkModel.type = [request.allHTTPHeaderFields valueForKey:@"Content-Type"];
}

@end
