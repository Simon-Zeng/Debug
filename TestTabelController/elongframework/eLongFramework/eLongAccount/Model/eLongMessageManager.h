//
//  MessageManager.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongMessage.h"

@interface eLongMessageManager : NSObject

+ (id)sharedInstance;

- (void)addMessage:(eLongMessage *)message;
- (BOOL)removeMessage:(eLongMessage *)message;
- (eLongMessage *)getMessageByIndex:(NSUInteger)index;
- (NSUInteger)messageCount;
- (NSUInteger)unreadMessageCount;        //未读消息
- (void)save;


// 消息中心改版，删除以前的本地文件  add by yangfan 2016.03.21
-(void) removeAllLocalMessage;
@end
