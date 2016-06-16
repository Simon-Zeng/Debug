//
//  NSArray+CheckArray.m
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import "NSArray+CheckArray.h"

@implementation NSArray (CheckArray)

- (BOOL)hasValue;{
    if (self && [self isKindOfClass:[NSArray class]] && [self count] > 0) {
        return YES;
    }
    return NO;
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
