//
//  eLongLogBonjour.h
//  eLongLogger
//
//  Created by Dawn on 14-12-3.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

@protocol eLongLogBonjourDelegate;
#import <Foundation/Foundation.h>

@interface eLongLogBonjour : NSObject
@property (nonatomic,readonly,assign) NSArray *services;
/**
 *  eLongLogBonjour单例
 *
 *  @return eLongLogBonjour
 */
+ (instancetype)sharedInstance;
/**
 *
 *  开始扫描服务端
 *
 *  @param type     服务端标识 默认：_eLongLogger._tcp
 *  @param delegate delegate
 */
- (void) startBrowserOfType:(NSString *)type delegate:(id)delegate;

/**
 *  连接Bonjour服务端
 *
 *  @param service NSNetService
 */
- (void) connectionService:(NSNetService *)service;

/**
 *  发送消息，内部调用
 *
 *  @param object  消息体
 *  @param service 是否同时发送到服务器
 */
- (void) sendMessage:(NSObject *)object service:(BOOL)service;

/**
 *  把缓存的日志数据批量传回服务器
 */
- (void) sendLogToServer;

@end

@protocol eLongLogBonjourDelegate <NSObject>
@optional
/**
 *  发现新的service
 *
 *  @param bonjour     eLongLogBonjour
 *  @param aNetService NSNetService
 */
- (void) eLongLogBonjour:(eLongLogBonjour *)bonjour didFindService:(NSNetService *)aNetService;
/**
 *  移除service
 *
 *  @param bonjour     eLongLogBonjour
 *  @param aNetService NSNetService
 */
- (void) eLongLogBonjour:(eLongLogBonjour *)bonjour didRemoveService:(NSNetService *)aNetService;
/**
 *  Bonjour已连接
 *
 *  @param bonjour eLongLogBonjour
 */
- (void) eLongLogBonjourDidConnected:(eLongLogBonjour *)bonjour;
@end