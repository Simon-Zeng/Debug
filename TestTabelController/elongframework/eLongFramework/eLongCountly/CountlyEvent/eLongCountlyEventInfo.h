//
//  eLongCountlyEventInfo.h
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventBase.h"

@interface eLongCountlyEventInfo : eLongCountlyEventBase

/**
 *  动作名称
 */
@property (nonatomic,copy) NSString *action;

/**
 *  频道id
 */
@property (nonatomic,copy) NSString *channelId;

/**
 *  客户端类型
 */
@property (nonatomic,copy) NSString *appt;

/**
 *  账号
 */
@property (nonatomic,copy) NSString *account;

@end
