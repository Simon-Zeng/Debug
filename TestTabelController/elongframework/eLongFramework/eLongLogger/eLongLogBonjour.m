//
//  eLongLogBonjour.m
//  eLongLogger
//
//  Created by Dawn on 14-12-3.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongLogBonjour.h"
#import "DTBonjourDataConnection.h"
#import "eLongLogger.h"
#import <UIKit/UIKit.h>

@interface eLongLogBonjour()<NSNetServiceBrowserDelegate,DTBonjourDataConnectionDelegate>
/**
 *  服务器监听
 */
@property (nonatomic,strong) NSNetServiceBrowser *serviceBrowser;
/**
 *  已发现的Services
 */
@property (nonatomic,strong) NSMutableArray *bonjourServices;
/**
 *  当前的Bonjour连接
 */
@property (nonatomic,strong) DTBonjourDataConnection *connection;
/**
 *  普通日志缓存
 */
@property (nonatomic,strong) NSMutableArray *msgCache;
/**
 *  要发送到服务器的日志缓存
 */
@property (nonatomic,strong) NSMutableArray *msgToServiceCache;
/**
 *  普通日志的缓存数量，超过此数量，旧的日志就会被清除
 */
@property (nonatomic,assign) NSInteger cacheCount;
/**
 *  线程锁
 */
@property (nonatomic,retain) NSRecursiveLock *lock;
@property (nonatomic,assign) id<eLongLogBonjourDelegate> delegate;
@end

@implementation eLongLogBonjour
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}
- (id) init{
    if (self = [super init]) {
        self.cacheCount = 1000;
        self.bonjourServices = [[NSMutableArray alloc] initWithCapacity:3];
        self.msgCache = [[NSMutableArray alloc] initWithCapacity:self.cacheCount];
        self.msgToServiceCache = [[NSMutableArray alloc] initWithCapacity:[eLongLogger logServerCount]];
        self.lock = [[NSRecursiveLock alloc] init];
        
#if TARGET_OS_IPHONE
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
    }
    return self;
}

- (void) dealloc{
    self.delegate = nil;
}

- (NSArray *) services{
    return _bonjourServices;
}

- (void) startBrowserOfType:(NSString *)type delegate:(id)delegate{
    if (self.serviceBrowser) {
        return;
    }
    self.delegate = delegate;
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.delegate = self;
    self.serviceBrowser.includesPeerToPeer = YES;
    [self.serviceBrowser searchForServicesOfType:(type ? type : @"_eLongLogger._tcp.") inDomain:@""];
}

- (void) connectionService:(NSNetService *)service{
    if (!self.connection) {
        // 如果connection为空，创建新的connection，并且open
        self.connection = [[DTBonjourDataConnection alloc] initWithService:service];
        self.connection.delegate = self;
        [self.connection open];
    }else{
        if (self.connection.service == service) {
            // 如果connection不为空，并且connection的service和传入的service是同一个，不作处理
            return;
        }else{
            // 如果connection不为空，并且connection的service和传入的service不是同一个，关闭之前的connection，打开新的connection
            [self.connection close];
            self.connection = nil;
            self.connection = [[DTBonjourDataConnection alloc] initWithService:service];
            self.connection.delegate = self;
            [self.connection open];
        }
    }
}

#pragma mark - Notifications

- (void)appDidEnterBackground:(NSNotification *)notification{
    [self.connection close];
    self.connection = nil;
}

- (void)appWillEnterForeground:(NSNotification *)notification{

}

#pragma mark - NetServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing{
    [self.bonjourServices addObject:aNetService];
    if ([self.delegate respondsToSelector:@selector(eLongLogBonjour:didFindService:)]) {
        [self.delegate eLongLogBonjour:self didFindService:aNetService];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing{
    if ([self.delegate respondsToSelector:@selector(eLongLogBonjour:didRemoveService:)]) {
        [self.delegate eLongLogBonjour:self didRemoveService:aNetService];
    }
    if (self.connection) {
        // 如果当前connection的service和即将被移除的service是同一个，关闭当前connection
        if (self.connection.service == aNetService) {
            [self.connection close];
            self.connection = nil;
        }
    }
    [self.bonjourServices removeObject:aNetService];
}

#pragma mark -
#pragma mark DTBonjourDataConnectionDelegate
- (void) connection:(DTBonjourDataConnection *)connection didReceiveObject:(id)object{
}

- (void) connectionDidOpen:(DTBonjourDataConnection *)connection{
    if ([self.delegate respondsToSelector:@selector(eLongLogBonjourDidConnected:)]) {
        [self.delegate eLongLogBonjourDidConnected:self];
    }
    [self sendLog];
}

- (void) connectionDidClose:(DTBonjourDataConnection *)connection{
}

- (void) connection:(DTBonjourDataConnection *)connection didFinishSendingChunk:(DTBonjourDataChunk *)chunk{
}

#pragma mark -
#pragma mark SendMessage
- (void) sendMessage:(NSObject *)object service:(BOOL)service{
    if (service) {
        [self sendToServer:object];
    }else{
        // 先存入缓冲区
        [self.lock lock];
        while (self.msgCache.count > self.cacheCount) {
            [self.msgCache removeLastObject];
        }
        [self.msgCache insertObject:object atIndex:0];
        [self.lock unlock];
        
        [self sendLog];
    }
}

- (void) sendToServer:(NSObject *)object{
    [self.lock lock];
    while (self.msgToServiceCache.count > [eLongLogger logServerCount]) {
        [self.msgToServiceCache removeLastObject];
    }
    [self.msgToServiceCache insertObject:object atIndex:0];
    [self.lock unlock];
}

- (void) sendLog{
    [self.lock lock];
    if([self.connection isOpen]){
        NSError *error = NULL;
        while(self.msgCache.count){
            [self.connection sendObject:[self.msgCache lastObject] error:&error];
            if(!error){
                [self.msgCache removeLastObject];
            }
        }
    }
    [self.lock unlock];
}

- (void) sendLogToServer{
    // 发送日志到服务器
    [self.lock lock];
    
    [self.lock unlock];
}
@end
