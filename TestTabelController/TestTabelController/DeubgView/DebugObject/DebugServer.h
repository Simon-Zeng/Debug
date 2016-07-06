//
//  DebugServer.h
//  TestTabelController
//
//  Created by wzg on 16/7/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugObject.h"
#import "Server.h"

#define SERVER_NOTI_SERVERCHANGED   @"SERVER_NOTI_SERVERCHANGED"    // 服务器地址变更

@interface DebugServer : DebugObject
@property (nonatomic, strong,readonly)Server *server;
@property (nonatomic, copy,readonly) NSString *serevrUrl;

/**
 *  添加服务器地址
 *
 *  @param name 服务器名字
 *  @param url  地址
 */
- (Server *)addServerName:(NSString *)name Url:(NSString *)url;
/**
 *  删除服务器
 *
 *  @param serverModel 服务器Model
 */
- (void) removeServer:(Server *)serverModel;
/**
 *  服务器列表
 *
 *  @return 服务器列表
 */
- (NSArray *)servers;
/**
 *  保存修改后的ServerModel
 *
 *  @param serverModel
 */
- (void) saveServer:(Server *)serverModel;
/**
 *  设置服务器列表
 *
 *  @param servers 服务器列表
 NSArray *tempServers = @[@{
 @"name":@"线上",
 @"url":@"",
 @"enabled":@(YES)
 }
 ]
 */
- (void)setServers:(NSArray *)servers;
@end
