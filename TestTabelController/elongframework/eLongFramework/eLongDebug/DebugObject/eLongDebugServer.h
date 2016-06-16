//
//  eLongDebugServer.h
//  ElongClient
//
//  Created by Kirn on 15/3/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugServerModel.h"

#define ELONDEBUG_NOTI_SERVERCHANGED   @"ELONDEBUG_NOTI_SERVERCHANGED"    // 服务器地址变更

@interface eLongDebugServer : eLongDebugObject
@property (nonatomic,strong,readonly) eLongDebugServerModel *serverModel;
@property (nonatomic,strong,readonly) NSString *serverUrl;
/**
 *  添加服务器
 *
 *  @param name 服务器名
 *  @param url  服务器地址
 */
- (eLongDebugServerModel *) addServerName:(NSString *)name url:(NSString *)url;
/**
 *  删除服务器
 *
 *  @param serverModel 服务器Model
 */
- (void) removeServer:(eLongDebugServerModel *)serverModel;
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
- (void) saveServer:(eLongDebugServerModel *)serverModel;
@end
