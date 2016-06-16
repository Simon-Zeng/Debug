//
//  NSDictionary+CheckDictionary.m
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import "NSDictionary+CheckDictionary.h"

@implementation NSDictionary (CheckDictionary)

- (BOOL)hasValue{
    if (self && [self isKindOfClass:[self class]] && [self count] > 0) {
        return YES;
    }
    return NO;
}

- (id)safeObjectForKey:(id)aKey{
    if ([self isKindOfClass:[NSDictionary class]] &&
        ([self objectForKey:aKey] != nil)){
        return [self objectForKey:aKey];
    }
    return nil;
}

@end
