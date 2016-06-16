//
//  MessageManager.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "eLongMessageManager.h"
#import "eLongDefine.h"
#import "NSArray+CheckArray.h"
#import "NSMutableDictionary+SafeForObject.h"
#import "NSMutableArray+SafeForObject.h"

static eLongMessageManager *instance = nil;
#define OlderFilePath ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Messages/Message.data"])
#define NewFilePath ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Messages/eLongMessage.data"])

@interface eLongMessageManager ()

@property (nonatomic, retain) NSMutableArray *messageList;

@end

@implementation eLongMessageManager

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[eLongMessageManager alloc] init];
        if([[NSFileManager defaultManager] fileExistsAtPath:OlderFilePath]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:OlderFilePath error:NULL];
        }
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        
        BOOL isDir;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:NewFilePath isDirectory:&isDir]) {
            NSData *data = [NSData dataWithContentsOfFile:NewFilePath];
            
            if (data) {
                @try {
                    NSArray *fileArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:fileArray.count];
                    for (NSDictionary *dict in fileArray) {
                        eLongMessage *message = [[eLongMessage alloc] initWithDictionary:dict error:NULL];
                        [tempArray safeAddObject:message];
                    }
                    self.messageList = tempArray;
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                    self.messageList = [NSMutableArray array];
                }
                @finally {
                    return self;
                }
            }
        }
        else {
            self.messageList = [NSMutableArray array];
        }
    }
    
    return self;
}


- (void)addMessage:(eLongMessage *)message {
    while (self.messageCount > 19) {
        [self.messageList removeObjectAtIndex:0];
    }
    // 排重
    [self removeMessage:message];
    [self.messageList addObject:message];
}

- (BOOL)removeMessage:(eLongMessage *)message{
    for (eLongMessage *msg in self.messageList) {
        if (STRINGHASVALUE(message.url)) {
            if ([message.body isEqualToString:msg.body] && [message.url isEqualToString:msg.url]) {
                [self.messageList removeObject:msg];
                return YES;
            }
        }else{
            if ([message.body isEqualToString:msg.body]) {
                [self.messageList removeObject:msg];
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)haveMessage:(eLongMessage *)message {
    for (eLongMessage *msg in self.messageList) {
        if (STRINGHASVALUE(message.url)) {
            if ([message.body isEqualToString:msg.body] && [message.url isEqualToString:msg.url]) {
                return YES;
            }
        }else{
            if ([message.body isEqualToString:msg.body]) {
                return YES;
            }
        }
    }
    return NO;
}

- (eLongMessage *)getMessageByIndex:(NSUInteger)index {
    return [self.messageList safeObjectAtIndex:index];
}

- (NSUInteger)messageCount {
    return self.messageList.count;
}

-(NSUInteger)unreadMessageCount {
    int count = 0;
    for(eLongMessage *em in self.messageList){
        if(!em.hasRead){
            count++;
        }
    }
    
    return count;
}

- (void)save {
    NSString *directoryPath = [NewFilePath stringByDeletingLastPathComponent];
    BOOL isDir;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSMutableArray *tempArrayM = [NSMutableArray arrayWithCapacity:_messageList.count];
    for (eLongMessage *message in _messageList) {
        NSDictionary *dict = [message toDictionary];
        [tempArrayM safeAddObject:dict];
    }
    
    NSData *data = nil;
    if (tempArrayM && tempArrayM.count) {
        data = [NSKeyedArchiver archivedDataWithRootObject:tempArrayM];
    }
    
    NSError *error = nil;
    BOOL successful = [data writeToFile:NewFilePath options:NSDataWritingAtomic error:&error];
    
    if (!successful) {
        NSLog(@"保存失败了");
    }
    else {
        NSLog(@"保存成功了");
    }
}

// 消息中心改版，删除以前的本地文件  add by yangfan 2016.03.21
-(void) removeAllLocalMessage{
    if([[NSFileManager defaultManager] fileExistsAtPath:OlderFilePath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:OlderFilePath error:NULL];
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:NewFilePath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:NewFilePath error:NULL];
    }
}

@end
