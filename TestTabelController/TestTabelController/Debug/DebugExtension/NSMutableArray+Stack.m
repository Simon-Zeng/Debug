//
//  NSMutableArray+Stack.m
//  TestTabelController
//
//  Created by wzg on 16/8/31.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)
- (void)push:(id)obj
{
    @synchronized (self) {
    [self addObject:obj];
    }
}

- (id)popObj
{
    id obj = nil;
    do {
        if (self.count == 0) {
            break;
        }
        obj = self.firstObject;
        [self removeObjectAtIndex:0];
    } while (0);
    return obj;
}

- (void)popFromIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return;
    }
    NSRange range = NSMakeRange(index, self.count - index);
    [self removeObjectsInRange:range];
}
@end
