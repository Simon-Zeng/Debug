//
//  eLongDebugChannel.m
//  ElongClient
//
//  Created by Dawn on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugChannel.h"
#import "eLongDebugDB.h"
#import "eLongDebugManager.h"

static NSString *channelDebugModelName = @"Channel";        // 服务器存储数据表名
@implementation eLongDebugChannel
/**
 *  添加渠道
 *
 *  @param channel 渠道名
 */
- (eLongDebugChannelModel *) addChannel:(NSString *)channel{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    
    // 先读取所有的server标记为禁用状态
    NSArray *channels = [self channels];
    for (eLongDebugServerModel *channelModel in channels) {
        channelModel.enabled = @(NO);
    }
    
    // 新增server model
    eLongDebugChannelModel *channelModel = [debugDB insertEntity:channelDebugModelName];
    channelModel.name = channel;
    channelModel.enabled = YES;
    
    // 存储入库
    [debugDB saveContext];
    
    return channelModel;
}
/**
 *  删除渠道
 *
 *  @param channel 渠道Model
 */
- (void) removeChannel:(eLongDebugChannelModel *)channel{
    if (!self.enabled) {
        return;
    }
    
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB remove:channel];
    [debugDB saveContext];
}
/**
 *  渠道列表
 */
- (NSArray *) channels{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSArray *channels = [debugDB selectDataFromEntity:channelDebugModelName query:nil];
    if (channels && channels.count) {
        return channels;
    }else{
        // 在没有数据的情况下返回固定数据
        NSArray *tempServers = @[@{@"name":@"ewiphone",@"enabled":@(YES)}];
        NSMutableArray *staticServers = [NSMutableArray array];
        eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
        for (NSDictionary *dict in tempServers) {
            eLongDebugServerModel *serverModel = [debugDB insertEntity:channelDebugModelName];
            serverModel.name = dict[@"name"];
            serverModel.enabled = dict[@"enabled"];
            [staticServers addObject:serverModel];
            if ([serverModel.enabled boolValue]) {
//                _serverModel = serverModel;
            }
        }
        [debugDB saveContext];
        return staticServers;
    }
}
@end
