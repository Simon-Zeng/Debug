//
//  PRAOPManager.m
//  TestTabelController
//
//  Created by wzg on 16/8/31.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PRAOPManager.h"
#import "Aspects.h"

@implementation PRAOPManager

+ (NSMutableArray *)aspectsList
{
    static NSMutableArray *aspectsList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aspectsList = [NSMutableArray array];
    });
    return aspectsList;
}

+ (void)FS_hookSelector:(SEL)selector inObject:(NSObject *)object withOptions:(FSAspectOptions)options usingBlock:(id)block error:(NSError *__autoreleasing *)error
{
    id<AspectToken> hook = [object aspect_hookSelector:selector withOptions:(NSUInteger)options usingBlock:block error:error];
    @synchronized (self) {
    [[self aspectsList] addObject:hook];
    }
}

+ (void)FS_hookSelector:(SEL)selector inClass:(Class)aclass withOptions:(FSAspectOptions)options usingBlock:(id)block error:(NSError *__autoreleasing *)error
{
    id<AspectToken> hook = [aclass aspect_hookSelector:selector withOptions:(NSUInteger)options usingBlock:block error:error];
    @synchronized (self) {
        [[self aspectsList] addObject:hook];
    }
}

+ (void)removeAllHook
{
    @synchronized (self) {
        if ([self aspectsList].count > 0 ) {
            for (id<AspectToken> obj in [self aspectsList]) {
                NSLog(@"%d",[obj remove]);
            }
        }
    }
}
@end
