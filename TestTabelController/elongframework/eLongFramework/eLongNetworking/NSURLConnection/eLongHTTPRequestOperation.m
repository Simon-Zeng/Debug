//
//  eLongHTTPRequestOperation.m
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPRequestOperation.h"
#import <Foundation/Foundation.h>

/**
 NSOperation状态
 */
typedef enum {
    eLongOperationPausedState      = -1,   // 暂停
    eLongOperationReadyState       = 1,    // 准备就绪
    eLongOperationExecutingState   = 2,    // 正在运行
    eLongOperationFinishedState    = 3,    // 完成
}elongOperationState;

/**
 *  状态机转换，判断状态是否可以从一种变为另一种
 *
 *  @param fromState   变换前状态
 *  @param toState     变换后状态
 *  @param isCancelled 是否已经取消
 *
 *  @return 是否可以转换
 */
static inline BOOL elongOperationStateTransitionIsValid(elongOperationState fromState, elongOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case eLongOperationReadyState:     // ReadyState->PausedState、ExecutingState
            switch (toState) {
                case eLongOperationPausedState:
                case eLongOperationExecutingState:
                    return YES;
                case eLongOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case eLongOperationExecutingState: // ExecutingState->PausedState、FinishedState
            switch (toState) {
                case eLongOperationPausedState:
                case eLongOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case eLongOperationFinishedState:  // FinishedState->#
            return NO;
        case eLongOperationPausedState:    // PausedState->(toState == ReadyState)
            return toState == eLongOperationReadyState;
        default: {
            switch (toState) {
                case eLongOperationPausedState:
                case eLongOperationReadyState:
                case eLongOperationExecutingState:
                case eLongOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
    }
}

/**
 *  HttpRequest状态和NSOperation状态转换
 *
 *  @param state HttpRequest状态
 *
 *  @return NSOperation状态
 */
static inline NSString * HttpRequestKeyPathFromOperationState(elongOperationState state) {
    switch (state) {
        case eLongOperationReadyState:
            return @"isReady";
        case eLongOperationExecutingState:
            return @"isExecuting";
        case eLongOperationFinishedState:
            return @"isFinished";
        case eLongOperationPausedState:
            return @"isPaused";
        default: {
            return @"state";
        }
    }
}

@interface eLongHTTPRequestOperation()
/**
 *  当前正在进行的请求
 */
@property (nonatomic,strong,readwrite) NSMutableURLRequest *currentReq;
/**
 *  返回数据
 */
@property (nonatomic,strong) NSMutableData *responseData;
/**
 *  网络连接
 */
@property (nonatomic,strong) NSURLConnection *connection;
/**
 *  网络状态Code
 */
@property (nonatomic,assign) NSInteger statusCode;
/**
 *  网络回传数据大小
 */
@property (nonatomic,assign) long long contentLength;
/**
 *  数据锁
 */
@property (nonatomic,strong) NSRecursiveLock *lock;
/**
 *  HttpRequest状态
 */
@property (nonatomic, assign) elongOperationState state;


@end

@implementation eLongHTTPRequestOperation

- (void)dealloc {
    NSLog(@"网络请求出队：%@",self.currentReq.URL.absoluteString);
    [self cancel];
}

/**
 *  HttpThread线程的RunLoop，线程一直等待，处理所有的网络请求
 */
+ (void)httpThreadWork{
    @autoreleasepool {
        // 线程命名，方便调试
        [[NSThread currentThread] setName:@"eLongHttpThread"];
        
        // runloop一直运行
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

/**
 *  HttpThread线程单例，处理所有的网络请求
 *
 *  @return HttpThread线程单例
 */
+ (NSThread *)httpRequest{
    static NSThread *httpThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        httpThread = [[NSThread alloc] initWithTarget:self selector:@selector(httpThreadWork) object:nil];
        [httpThread start];
    });
    return httpThread;
}

/**
 *  创建新的网络请求Operation
 *
 *  @param request url request
 *
 *  @return self
 */
- (id)initWithRequest:(NSMutableURLRequest *)request {
    if (self = [super init]) {
        self.currentReq	= request;
        NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
        self.lock = lock;
        self.lock.name = @"elong.httpOperation.lock";
        _state = eLongOperationReadyState;
    }
    return self;
}

#pragma mark -
/**
 *  通过elongOperationState设置NSOperation状态
 *
 *  @param state elongOperationState
 */
- (void)setState:(elongOperationState)state {
    // 检测状态是否可以发生转换
    if (!elongOperationStateTransitionIsValid(self.state, state, [self isCancelled])) {
        return;
    }
    
    // 通过KVO设置NSOperation状态
    [self.lock lock];
    NSString *oldStateKey = HttpRequestKeyPathFromOperationState(self.state);
    NSString *newStateKey = HttpRequestKeyPathFromOperationState(state);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    [self.lock unlock];
}

/**
 *  取消HttpRequest，设置状态为FinishedState
 */
- (void)cancel{
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];
        if ([self isExecuting]) {
            [self performSelector:@selector(cancelConnection) onThread:[[self class] httpRequest] withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        }
    }else if(![self isCancelled]){
        [super cancel];
    }
    
    [self.lock unlock];
}

/**
 *  取消网络请求
 */
- (void)cancelConnection{
    if (![self isFinished]) {
        if (self.connection) {
            [self.connection cancel];
            self.connection = nil;
            [self finish];
        }else{
            [self finish];
        }
    }
}

/**
 *  网络请求完成或者取消时调用，设置状态为Finished
 */
- (void)finish {
    [self.lock lock];
    self.state = eLongOperationFinishedState;
    [self.lock unlock];
}

/**
 *  HttpRequest是否Ready
 *
 *  @return YES or NO
 */
- (BOOL)isReady {
    return self.state == eLongOperationReadyState && [super isReady];
}

/**
 *  HttpRequest是否正在执行
 *
 *  @return YES or NO
 */
- (BOOL)isExecuting {
    return self.state == eLongOperationExecutingState;
}

/**
 *  HttpRequest是否已经完成
 *
 *  @return YES or NO
 */
- (BOOL)isFinished {
    return self.state == eLongOperationFinishedState;
}

/**
 *  HttpRequest是否并发
 *
 *  @return YES or NO
 */
- (BOOL)isConcurrent {
    return YES;
}

#pragma mark -
/**
 *  HttpRequest开始运行
 */
- (void)start{
    [self.lock lock];
    if ([self isCancelled]) {
        [self performSelector:@selector(cancelConnection) onThread:[[self class] httpRequest] withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }else if ([self isReady]) {
        self.state = eLongOperationExecutingState;
        [self performSelector:@selector(operationDidStart) onThread:[[self class] httpRequest] withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    [self.lock unlock];
}

/**
 *  开始网络请求并且把网络请求配置到HttpRequestThread的RunLoop上，Mode一定要设置为NSRunLoopCommonModes
 */
- (void)operationDidStart {
    [self.lock lock];
    if (![self isCancelled]) {
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.currentReq delegate:self startImmediately:NO];
        self.connection = connection;
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [self.connection scheduleInRunLoop:runLoop forMode:NSRunLoopCommonModes];
        [self.connection start];
        
        
    }
    [self.lock unlock];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
    if (self.contentLength) {
        float process = self.responseData.length/(self.contentLength + 0.0);
        [self performSelectorOnMainThread:@selector(mainThreadDidReceiveDataProcess:) withObject:[NSNumber numberWithFloat:process] waitUntilDone:NO];
    }
}

- (void) mainThreadDidReceiveDataProcess:(NSNumber *)process{
    if ([self.delegate respondsToSelector:@selector(eLongHTTPRequestOperation:receviedResponseProcess:)]) {
        [self.delegate eLongHTTPRequestOperation:self receviedResponseProcess:[process floatValue]];
    }
    NSLog(@"connection receive data process:%.2f%%",100 * [process floatValue]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:5000];
    self.responseData = data;
    if (nil != response) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        [self performSelectorOnMainThread:@selector(mainThreadDidReceiveResponse:) withObject:response waitUntilDone:NO];
        self.statusCode = res.statusCode;
        self.contentLength = [response expectedContentLength];
    }
}

- (void) mainThreadDidReceiveResponse:(NSURLResponse*)response{
    if (nil != response) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        if ([self.delegate respondsToSelector:@selector(eLongHTTPRequestOperation:receviedStatusCode:)]){
            [self.delegate eLongHTTPRequestOperation:self receviedStatusCode:res.statusCode];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    float process = totalBytesWritten/(totalBytesExpectedToWrite + 0.0);
    [self performSelectorOnMainThread:@selector(mainThreadDidSendProcess:) withObject:[NSNumber numberWithFloat:process] waitUntilDone:NO];
}

- (void) mainThreadDidSendProcess:(NSNumber *)process{
    if ([self.delegate respondsToSelector:@selector(eLongHTTPRequestOperation:receviedRequestProcess:)]) {
        [self.delegate eLongHTTPRequestOperation:self receviedRequestProcess:[process floatValue]];
    }
    NSLog(@"connection send data process:%.2f%%",100 * [process floatValue]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn{
    [self performSelectorOnMainThread:@selector(mainThreadDidFinishLoading) withObject:nil waitUntilDone:NO];
    self.connection = nil;
    [self finish];
}

- (void) mainThreadDidFinishLoading{
    if ([self.delegate respondsToSelector:@selector(eLongHTTPRequestOperation:receviedData:)]) {
        [self.delegate eLongHTTPRequestOperation:self receviedData:self.responseData];
    }
}

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
    [self performSelectorOnMainThread:@selector(mainThreadDidFailWithError:) withObject:error waitUntilDone:NO];
    self.connection = nil;
    [self finish];
}

- (void) mainThreadDidFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(eLongHTTPRequestOperation:receviedError:)]) {
        [self.delegate eLongHTTPRequestOperation:self receviedError:error];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL canAuthenticate = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    if (canAuthenticate) {
        NSLog(@"connection https");
    }
    return canAuthenticate;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}
@end
