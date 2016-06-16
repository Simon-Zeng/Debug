//
//  eLongDebugServer.m
//  ElongClient
//
//  Created by Kirn on 15/3/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugServer.h"
#import "eLongDebugDB.h"

static NSString *serverDebugModelName = @"Server";        // 服务器存储数据表名

@implementation eLongDebugServer
@synthesize serverModel = _serverModel;

- (eLongDebugServerModel *) addServerName:(NSString *)name url:(NSString *)url {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    
    // 先读取所有的server标记为禁用状态
    NSArray *servers = [self servers];
    for (eLongDebugServerModel *serverModel in servers) {
        serverModel.enabled = @(NO);
    }
    
    // 新增server model
    eLongDebugServerModel *serverModel = [debugDB insertEntity:serverDebugModelName];
    serverModel.name = name;
    serverModel.url = url;
    serverModel.enabled = @(YES);
    
    // 存储入库
    [debugDB saveContext];
    
    // 当前选中项
    _serverModel = serverModel;
    return serverModel;
}

- (void) removeServer:(eLongDebugServerModel *)serverModel {
    if (!self.enabled) {
        return;
    }
    
    if (_serverModel == serverModel) {
        _serverModel = nil;
    }
    
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB remove:serverModel];
    [debugDB saveContext];
}

- (void) saveServer:(eLongDebugServerModel *)serverModel{
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
    if ([serverModel.enabled boolValue]) {
        _serverModel = serverModel;
    }
}

- (NSString *) serverUrl{
    if (self.enabled) {
        if (self.serverModel) {
            NSLog(@"Enabled:%@", self.serverModel.url);
            return self.serverModel.url;
        }else{
            [self servers];
            if (self.serverModel) {
                NSLog(@"!Enabled:%@", self.serverModel.url);
                return self.serverModel.url;
            }
            NSLog(@"FromDB:http://mobile-api2011.elong.com");
            return @"http://mobile-api2011.elong.com";
        }
    }else{
        NSLog(@"FromNormal:http://mobile-api2011.elong.com");
        return @"http://mobile-api2011.elong.com";
    }
}

- (NSArray *)servers {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSArray *servers = [debugDB selectDataFromEntity:serverDebugModelName query:nil];
    if (servers && servers.count) {
        for (eLongDebugServerModel *serverModel in servers) {
            if ([serverModel.enabled boolValue]) {
                _serverModel = serverModel;
            }
        }
        return servers;
    }else{
        // 在没有数据的情况下返回固定数据
        NSArray *tempServers = @[@{
                                     @"name":@"线上",
                                     @"url":@"http://mobile-api2011.elong.com",
                                     @"enabled":@(YES)
                                     },
                                 @{
                                     @"name":@"84",
                                     @"url":@"http://10.35.45.84",
                                     @"enabled":@(NO)
                                     },
                                 @{
                                     @"name":@"28",
                                     @"url":@"http://192.168.9.28",
                                     @"enabled":@(NO)
                                     },
                                 @{
                                     @"name":@"51",
                                     @"url":@"http://192.168.14.51",
                                     @"enabled":@(NO)
                                     },
                                 @{
                                     @"name":@"206",
                                     @"url":@"http://192.168.14.206",
                                     @"enabled":@(NO)
                                     },
                                 @{
                                     @"name":@"140",
                                     @"url":@"http://192.168.14.140",
                                     @"enabled":@(NO)
                                     }];
        
        NSMutableArray *staticServers = [NSMutableArray array];
        eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
        for (NSDictionary *dict in tempServers) {
            eLongDebugServerModel *serverModel = [debugDB insertEntity:serverDebugModelName];
            serverModel.name = dict[@"name"];
            serverModel.url = dict[@"url"];
            serverModel.enabled = dict[@"enabled"];
            [staticServers addObject:serverModel];
            if ([serverModel.enabled boolValue]) {
                _serverModel = serverModel;
            }
        }
        [debugDB saveContext];
        return staticServers;
    }
}

@end
