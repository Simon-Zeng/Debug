//
//  eLongCountlyEventShow.h
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventBase.h"

@interface eLongCountlyEventShow : eLongCountlyEventBase

/**
 *  页面名称
 */
@property (nonatomic,copy) NSString *page;

/**
 *  模块名称
 */
//@property (nonatomic,copy) NSString *ch;

/**
 *  频道id
 */
@property (nonatomic,copy) NSString *channelId;

/**
 *  客户端类型
 */
@property (nonatomic,copy) NSString *appt;
@end
