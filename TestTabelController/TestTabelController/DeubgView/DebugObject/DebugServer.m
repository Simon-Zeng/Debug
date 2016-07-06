//
//  DebugServer.m
//  TestTabelController
//
//  Created by wzg on 16/7/6.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugServer.h"
#import "DebugDB.h"
#import "DebugHttpMonitor.h"

static NSString *serverDebugModelName = @"Server";        // 服务器存储数据表名
@interface DebugServer()

@end

@implementation DebugServer
@synthesize server = _server;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setEnable:(BOOL)enable
{
    if (enable) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeUrl) name:SERVER_NOTI_SERVERCHANGED object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)exchangeUrl
{
    if (!self.enable)return;
    if (!self.server) return;
    [DebugHttpMonitor exchangeRequestUrlWithNewUrl:self.server.url];
}

- (NSString *) serverUrl{
    if (self.enable) {
        if (self.server) {
            NSLog(@"Enabled:%@", self.server.url);
            return self.server.url;
        }else{
            [self servers];
            if (self.server) {
                NSLog(@"!Enabled:%@", self.server.url);
                return self.server.url;
            }
            NSLog(@"线上地址");
            return @"";
        }
    }else{
        NSLog(@"线上地址");
        return @"";
    }
}

- (Server *)addServerName:(NSString *)name Url:(NSString *)url
{
    if (!self.enable) return nil;
    DebugDB *db = [DebugDB shareInstance];
    NSArray *servers = [self servers];
    if (servers.count) {
        for (Server *server in servers) {
            server.enable = @(NO);
        }
    }
    
    Server *server = [db insertEntity:serverDebugModelName];
    server.name = name;
    server.url = url;
    server.enable = @(YES);
    _server = server;
    
    [db saveContext];
    return _server;
}

- (void)removeServer:(Server *)serverModel
{
if (!self.enable) return;
    DebugDB *db = [DebugDB shareInstance];
    if (_server == serverModel) {
        _server = nil;
    }
    
    [db remove:serverModel];
    [db saveContext];
}

- (void)setServers:(NSArray *)servers
{
        if (!self.enable) return;
    NSMutableArray *staticServers = [NSMutableArray array];
    DebugDB *db = [DebugDB shareInstance];
    for (NSDictionary *dict in servers) {
        Server *serverModel = [db insertEntity:serverDebugModelName];
        serverModel.name = dict[@"name"];
        serverModel.url = dict[@"url"];
        serverModel.enable = dict[@"enabled"];
        [staticServers addObject:serverModel];
        if ([serverModel.enable boolValue]) {
            _server = serverModel;
        }
    }
}

- (NSArray *)servers
{
    if (!self.enable) return nil;
    DebugDB *db = [DebugDB shareInstance];
    NSArray *servers = [db selectDataFromEntity:serverDebugModelName query:nil];
    if (servers && servers.count) {
        for (Server *server in servers) {
            if ([server.enable boolValue]) {
                _server = server;
            }
        }
        return servers;
    }else{
        return nil;
    }
}

- (void)saveServer:(Server *)serverModel
{
if (!self.enable) return;
    DebugDB *db = [DebugDB shareInstance];
    [db saveContext];
    
    if ([serverModel.enable boolValue]) {
        _server = serverModel;
    }
}

@end
