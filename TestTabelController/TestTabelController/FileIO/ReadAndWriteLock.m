//
//  ReadAndWriteLock.m
//  TestTabelController
//
//  Created by wzg on 16/8/15.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "ReadAndWriteLock.h"

@interface ReadAndWriteLock()
@property (nonatomic, strong)dispatch_queue_t isolation;
@property (nonatomic, strong)NSMutableDictionary *counts;
@end

@implementation ReadAndWriteLock
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (nil == self.isolation) {
            NSString *queueName = [NSString stringWithFormat:@"%@.isolation.%p",[self class],self];
            self.isolation = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        }
        
        if (nil == self.counts) {
            self.counts = [NSMutableDictionary dictionary];
            [self.counts setValue:[NSNumber numberWithInt:0] forKey:@"count"];
        }
    }
    
  
    return self;
}

/**
 *  单写
 */
- setCount:(NSUInteger)count forKey:(NSString *)key
{
    key = [key copy];
    dispatch_barrier_async(self.isolation, ^{
        if (count == 0) {
            [self.counts removeObjectForKey:key];
        }else{
            self.counts[key] = count;
        }
    });
}

/**
 *  多读
 */
- (NSUInteger)countForKey:(NSString *)key
{
    __block NSUInteger count;
    dispatch_sync(self.isolation, ^{
        count = [self.counts[key] unsignedIntegerValue];
    });
    return count;
}

@end
