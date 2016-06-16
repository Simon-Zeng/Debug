//
//  eLongDebugChannel.h
//  ElongClient
//
//  Created by Dawn on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugChannelModel.h"

@interface eLongDebugChannel : eLongDebugObject
/**
 *  添加渠道
 *
 *  @param channel 渠道名
 *
 *  @return 渠道Model
 */
- (eLongDebugChannelModel *) addChannel:(NSString *)channel;
/**
 *  删除渠道
 *
 *  @param channel 渠道Model
 */
- (void) removeChannel:(eLongDebugChannelModel *)channel;
/**
 *  所有渠道
 *
 *  @return 渠道列表
 */
- (NSArray *) channels;
@end
