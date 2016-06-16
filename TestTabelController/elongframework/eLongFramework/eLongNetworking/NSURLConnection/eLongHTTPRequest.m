//
//  eLongHTTPRequest.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPRequest.h"
#import "eLongHTTPRequestOperation.h"
#import "eLongHTTPLZSSEncoding.h"
#import "eLongHTTPGNUzipEncoding.h"
#import "eLongHTTPURLEncoding.h"
#import "eLongNetworkSerialization.h"
#import "eLongNetworkRequest.h"
#import "eLongNetworkCache.h"
#import "eLongDebugManager.h"
#import "eLongNetworkDynamicCommunication.h"
#import "eLongFileIOUtils.h"

#define SUCCESS_BLOCK_INDEX 0
#define FAILURE_BLOCK_INDEX 1

static NSOperationQueue *httpQueue = nil;

@interface eLongHTTPRequest()
/**
 *  实例请求存储当前request
 */
@property (nonatomic, strong) NSURLRequest *currentReq;
/**
 *  实例请求存储当前operation
 */
@property (nonatomic, strong) eLongHTTPRequestOperation *currentOperation;
/**
 *  数据锁
 */
@property (nonatomic, strong) NSRecursiveLock *lock;
/**
 *  存储回调对象 key对应HttpOperation对象的hash值
 */
@property (nonatomic, strong) NSMutableDictionary *callBackObjectDict;

//创建HttpOperation
- (eLongHTTPRequestOperation *)createHttpRequestOperation:(NSURLRequest *)request;

//单例存储回调和HttpOperation
- (eLongHTTPRequestOperation *)readyforStartWith:(NSURLRequest *)request delegate:(id<eLongHTTPRequestDelegate>)delegate;

- (eLongHTTPRequestOperation *)readyforStartWith:(NSURLRequest *)request success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure;
//单例开始请求
- (void)startWith:(eLongHTTPRequestOperation *)httpRequestOperation;

//解压数据
- (NSData *)decodingData:(NSData *)data compressString:(NSString *)compress;

//取消 method
- (void)cancelQueue;
- (void)clearData;

@end

@implementation eLongHTTPRequest

- (void)dealloc{
    [self cancel];
}

- (id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    // 创建网络请求队列
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        httpQueue = [[NSOperationQueue alloc] init];    // 创建请求队列
        httpQueue.maxConcurrentOperationCount = 4;      // 最大并发数
    });
    self.callBackObjectDict = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    self.lock = lock;
    self.lock.name = @"elong.httpReq.lock";
    return self;
}

+ (id)shared {
    static eLongHTTPRequest *httpRequest;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        httpRequest = [[eLongHTTPRequest alloc] init];
    });
    return httpRequest;
}

#pragma mark - 单列 请求
+ (eLongHTTPRequestOperation *)startRequest:(NSURLRequest *)request
                                   delegate:(id<eLongHTTPRequestDelegate>)delegate{
    if (!request) {
        return nil;
    }
    eLongHTTPRequest *httpRequest = [eLongHTTPRequest shared];
    eLongHTTPRequestOperation *httpRequestOperation = [httpRequest readyforStartWith:request delegate:delegate];
    BOOL isSendReqNecessary = [httpRequest fetchCachingWith:httpRequestOperation];
    if (isSendReqNecessary) {
        [httpRequest startWith:httpRequestOperation];
    }
    return httpRequestOperation;
}

- (eLongHTTPRequestOperation *)readyforStartWith:(NSURLRequest *)request delegate:(id<eLongHTTPRequestDelegate>)delegate{
    [self.lock lock];
    eLongHTTPRequestOperation *httpRequestOperation = [self createHttpRequestOperation:request];
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)httpRequestOperation.hash];
    if (delegate) {
        [self.callBackObjectDict setObject:delegate forKey:indexKey];
    }
    [self.lock unlock];
    return httpRequestOperation;
}

+ (eLongHTTPRequestOperation *)startRequest:(NSURLRequest *)request
                                    success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure{
    if (!request) {
        return nil;
    }
    eLongHTTPRequest *httpRequest = [eLongHTTPRequest shared];
    eLongHTTPRequestOperation *httpRequestOperation = [httpRequest readyforStartWith:request success:success failure:failure];
    BOOL isSendReqNecessary = [httpRequest fetchCachingWith:httpRequestOperation];
    if (isSendReqNecessary) {
        [httpRequest startWith:httpRequestOperation];
    }
    return httpRequestOperation;
}

- (eLongHTTPRequestOperation *)readyforStartWith:(NSURLRequest *)request success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure{
    [self.lock lock];
    eLongHTTPRequestOperation *httpRequestOperation = [self createHttpRequestOperation:request];
    NSArray *callbackObject;
    if (success && failure) {
        callbackObject = [[NSArray alloc] initWithObjects:[success copy], [failure copy], nil];
    }else if (success){
        callbackObject = [[NSArray alloc] initWithObjects:[success copy], [NSNull null], nil];
    }else if (failure){
        callbackObject = [[NSArray alloc] initWithObjects:[NSNull null], [failure copy], nil];
    }else{
        callbackObject = [[NSArray alloc] initWithObjects:[NSNull null], [NSNull null], nil];
    }
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)httpRequestOperation.hash];
    [self.callBackObjectDict setObject:callbackObject forKey:indexKey];
    [self.lock unlock];
    return httpRequestOperation;
}

- (void)startWith:(eLongHTTPRequestOperation *)httpRequestOperation{
    [httpQueue addOperation:httpRequestOperation];
}

#pragma mark -
- (void)completeWith:(eLongHTTPRequestOperation *)operation data:(NSData *)data{
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)operation.hash];
    id jsonObject = [eLongNetworkSerialization jsonObjectWithData:data];
    id callbackObject = [self.callBackObjectDict objectForKey:indexKey];
    [self p_checkDynamicCommunicationErrorWith:operation
                                    jsonObject:jsonObject
                             andCallBackObject:callbackObject];
    if ([callbackObject isKindOfClass:[NSArray class]]){
        if (![[callbackObject objectAtIndex:SUCCESS_BLOCK_INDEX] isKindOfClass:[NSNull class]]){
            void (^success)(eLongHTTPRequestOperation *operation, id responseObject) = [callbackObject objectAtIndex:SUCCESS_BLOCK_INDEX];
            success(operation, jsonObject);
        }
    }else if (callbackObject){
        id<eLongHTTPRequestDelegate> delegate = callbackObject;
        if ([delegate respondsToSelector:@selector(eLongHTTPRequest:successWithData:)]){
            [delegate eLongHTTPRequest:self successWithData:data];
        }
        if ([delegate respondsToSelector:@selector(eLongHTTPRequest:successWithJSON:)]){
            if (!jsonObject){
                NSError *error = [NSError errorWithDomain:@"eLongHTTPRequest"
                                                     code:0
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"返回数据为空",NSLocalizedDescriptionKey,nil]];
                [self completeWith:operation error:error];
            } else {
                [delegate eLongHTTPRequest:self successWithJSON:jsonObject];
            }

        }
    }
    [self debugNetworkWith:operation data:data];
}

- (void)completeWith:(eLongHTTPRequestOperation *)operation error:(NSError *)error{
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)operation.hash];
    id callbackObject = [self.callBackObjectDict objectForKey:indexKey];
    if ([callbackObject isKindOfClass:[NSArray class]]){
        if (![[callbackObject objectAtIndex:FAILURE_BLOCK_INDEX] isKindOfClass:[NSNull class]]){
            void (^failure)(eLongHTTPRequestOperation *operation, id responseObject) = [callbackObject objectAtIndex:FAILURE_BLOCK_INDEX];
            failure(operation, error);
        }
    }else if (callbackObject){
        id<eLongHTTPRequestDelegate> delegate = callbackObject;
        if ([delegate respondsToSelector:@selector(eLongHTTPRequest:failureWithError:)]) {
            [delegate eLongHTTPRequest:self failureWithError:error];
        }
    }
    [self debugNetworkWith:operation data:nil];
}

//检测动态通信信息是否过期
- (void)p_checkDynamicCommunicationErrorWith:(eLongHTTPRequestOperation *)operation
                                  jsonObject:(id)jsonObject
                           andCallBackObject:(id)callbackObject {
    BOOL shouldSendError = NO;
    if ([jsonObject isKindOfClass:[NSDictionary class]]) { //动态RSA通信 ERROR_CODE=799时重新协商
        NSObject *code = [jsonObject safeObjectForKey:@"ErrorCode"];
        if ([code isKindOfClass:[NSNumber class]]) {
            if ([((NSNumber *)code) intValue] == 799) {
                shouldSendError = YES;
                [[eLongNetworkDynamicCommunication sharedInstance] startCommunicationWithCompletion:nil];
            }
        } else if ([code isKindOfClass:[NSString class]]) {
            if ([(NSString *)code isEqualToString:@"799"]) {
                shouldSendError = YES;
                [[eLongNetworkDynamicCommunication sharedInstance] startCommunicationWithCompletion:nil];
            }
        }
    }
    if (shouldSendError) {
        NSError *error = [NSError errorWithDomain:@"eLongHTTPRequest"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"返回数据为空",NSLocalizedDescriptionKey,nil]];
        if ([callbackObject isKindOfClass:[NSArray class]]){
            if (![[callbackObject objectAtIndex:FAILURE_BLOCK_INDEX] isKindOfClass:[NSNull class]]){
                void (^failure)(eLongHTTPRequestOperation *operation, id responseObject) = [callbackObject objectAtIndex:FAILURE_BLOCK_INDEX];
                failure(operation, error);
            }
        }else if (callbackObject){
            id<eLongHTTPRequestDelegate> delegate = callbackObject;
            if ([delegate respondsToSelector:@selector(eLongHTTPRequest:failureWithError:)]) {
                [delegate eLongHTTPRequest:self failureWithError:error];
            }
        }
    }
}

- (void) debugNetworkWith:(eLongHTTPRequestOperation *)operation data:(NSData *)data{
    if (!operation.networkRequestModel) {
        return;
    }
    NSString *path = operation.currentReq.URL.absoluteString;
    NSString *method = operation.currentReq.HTTPMethod;
    NSString *type = [operation.currentReq.allHTTPHeaderFields valueForKey:@"Content-Type"];
    NSNumber *size = @(data.length);
    NSString *dataString = nil;
    if (data) {
        dataString = [eLongNetworkSerialization jsonStringWithObject:[eLongNetworkSerialization jsonObjectWithData:data]];
    }else{
        dataString = @"error";
    }
    //NSString *body = [[NSString alloc] initWithData:operation.currentReq.HTTPBody encoding:NSUTF8StringEncoding];
    NSString *header = [eLongNetworkSerialization jsonStringWithObject:operation.currentReq.allHTTPHeaderFields];
    
    operation.networkRequestModel.path = path;
    operation.networkRequestModel.method = method;
    operation.networkRequestModel.type = type;
    operation.networkRequestModel.size = size;
    operation.networkRequestModel.data = dataString;
    //operation.networkRequestModel.body = body;
    operation.networkRequestModel.header = header;
    
    eLongDebugNetwork *debugNetwork = [eLongDebugManager networkInstance];
    [debugNetwork endRequest:operation.networkRequestModel];
}

- (BOOL)fetchCachingWith:(eLongHTTPRequestOperation *)operation{
    BOOL isSendReqNecessary = YES;
    eLongNetworkContentCache cache = [[operation.currentReq.allHTTPHeaderFields objectForKey:@"_eLongNetworkCache"] intValue];
    switch (cache) {
        case eLongNetworkCacheDefault:{
            NSData *cacheData = [[eLongNetworkCache shareInstance] cacheForRequest:operation.currentReq];
            if (cacheData){
                [self completeWith:operation data:cacheData];
                [self removeHttpOperation:operation];
                isSendReqNecessary = NO;
            }
            break;
        }
        case eLongNetworkCacheFirst:{
            NSData *cacheData = [[eLongNetworkCache shareInstance] cacheForRequest:operation.currentReq];
            if (cacheData) {
                [self completeWith:operation data:cacheData];
            }
            break;
        }
        case eLongNetworkCacheNone:{
            break;
        }
        default:
            break;
    }
    return isSendReqNecessary;
}

#pragma mark - 实例 请求
- (eLongHTTPRequest *)initWithRequest:(NSURLRequest *)request{
    self = [self init];
    if (!self) {
        return nil;
    }
    self.currentReq = request;
    self.currentOperation = [self createHttpRequestOperation:self.currentReq];
    return self;
}

- (eLongHTTPRequest *)initWithRequest:(NSURLRequest *)request
                              success:(void (^)(eLongHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(eLongHTTPRequestOperation *operation, NSError *error))failure
{
    self = [self init];
    if (!self) {
        return nil;
    }
    self.currentReq = request;
    
    eLongHTTPRequestOperation *httpRequestOperation = [self readyforStartWith:request success:success failure:failure];
    BOOL isSendReqNecessary = [self fetchCachingWith:httpRequestOperation];
    if (isSendReqNecessary) {
        [self startWith:httpRequestOperation];
    }
    self.currentOperation = httpRequestOperation;
    return self;
}


- (void)start{
    if (!self.currentReq) {
        return;
    }
    if ([httpQueue.operations containsObject:self.currentOperation]) {
        return;
    }
    [self.lock lock];
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)self.currentOperation.hash];
    if (_delegate) {
        [self.callBackObjectDict setObject:self.delegate forKey:indexKey];
    }
    [self.lock unlock];
    BOOL isSendReqNecessary = [self fetchCachingWith:self.currentOperation];
    if (isSendReqNecessary) {
        [httpQueue addOperation:self.currentOperation];
    }
}

#pragma mark - 实例 取消请求，清理数据
- (void)cancelQueue{
    if(httpQueue){
        for(eLongHTTPRequestOperation *requestOperation in httpQueue.operations) {
            if(requestOperation.delegate == self){
                requestOperation.delegate = nil;
                [requestOperation cancel];
                self.currentOperation = nil;
                break;
            }
        }
    }
}

- (void)clearData{
    [self cancelQueue];
    self.delegate = nil;
}

- (void)cancel{
    if([self.delegate respondsToSelector:@selector(eLongHTTPRequestCanceled:)]){
        [self.delegate eLongHTTPRequestCanceled:self];
    }
    [self clearData];
}

#pragma mark -
- (eLongHTTPRequestOperation *)createHttpRequestOperation:(NSURLRequest *)request{
    NSString *params = nil;
    if ([request valueForHTTPHeaderField:@"_eLongNetworkParams"]) {
        params = [NSString stringWithFormat:@"%@",[request valueForHTTPHeaderField:@"_eLongNetworkParams"]];
        params =  [[[eLongHTTPURLEncoding alloc] init] decoding:params];
        if ([request isMemberOfClass:[NSMutableURLRequest class]]) {
            [(NSMutableURLRequest *)request setValue:@"" forHTTPHeaderField:@"_eLongNetworkParams"];
        }
    }
    eLongHTTPRequestOperation *httpRequestOperation = [[eLongHTTPRequestOperation alloc] initWithRequest:request];
    httpRequestOperation.delegate = self;
    
    eLongDebugNetwork *debugNetwork = [eLongDebugManager networkInstance];
    httpRequestOperation.networkRequestModel = [debugNetwork beginRequest];
    httpRequestOperation.networkRequestModel.body = params;
    return httpRequestOperation;
}

- (void)removeHttpOperation:(eLongHTTPRequestOperation *)operation{
    [self.lock lock];
    NSString *indexKey = [NSString stringWithFormat:@"%lu",(unsigned long)operation.hash];
    [self.callBackObjectDict removeObjectForKey:indexKey];
    [self.lock unlock];
}

#pragma mark - eLongHTTPRequestOperationDelegate
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedData:(NSData *)data{
    NSString *compress = [operation.currentReq.allHTTPHeaderFields objectForKey:@"compress"];
    NSData *decodingData = [self decodingData:data compressString:compress];
    if (!decodingData){
        NSError *error = [NSError errorWithDomain:@"eLongHTTPRequest"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"返回数据为空",NSLocalizedDescriptionKey,nil]];
        [self completeWith:operation error:error];
    } else {
        eLongNetworkContentCache cache = [[self.currentReq.allHTTPHeaderFields objectForKey:@"_eLongNetworkCache"] integerValue];
        if (cache != eLongNetworkCacheNone) {
            [[eLongNetworkCache shareInstance] cacheData:decodingData forRequest:operation.currentReq];
        }
        [self completeWith:operation data:decodingData];
    }
    [self removeHttpOperation:operation];
}

- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedError:(NSError *)error{
    [self completeWith:operation error:error];
    [self removeHttpOperation:operation];
}

- (NSData *)decodingData:(NSData *)data compressString:(NSString *)compress{
    NSData *newData;
    if ([compress isEqualToString:@"gzip"]) {
        eLongHTTPGNUzipEncoding *decoding = [[eLongHTTPGNUzipEncoding alloc] init];
        newData = [decoding decodingData:data];
    }else if ([compress isEqualToString:@"lzss"]){
        eLongHTTPLZSSEncoding *decoding = [[eLongHTTPLZSSEncoding alloc] init];
        newData = [decoding decodingData:data];
    }else{
        newData = data;
    }
    return newData;
}

- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedStatusCode:(NSInteger)code{
    operation.networkRequestModel.statuscode = @(code);
}
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedRequestProcess:(float)process{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eLongHTTPRequest:receviedRequestProcess:)]) {
        [self.delegate eLongHTTPRequest:self receviedRequestProcess:process];
    }
}
- (void)eLongHTTPRequestOperation:(eLongHTTPRequestOperation *)operation receviedResponseProcess:(float)process{
    if (self.delegate && [self.delegate respondsToSelector:@selector(eLongHTTPRequest:receviedResponseProcess:)]) {
        [self.delegate eLongHTTPRequest:self receviedResponseProcess:process];
    }
}

@end
