//
//  NSMutableArray+SafeForObject.m
//  ElongIpadClient
//
//  Created by top on 15/1/29.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import "NSMutableArray+SafeForObject.h"

@implementation NSMutableArray (SafeForObject)

- (void)safeAddObject:(id)anObject{
    if(anObject != nil){
        [self addObject:anObject];
    }
}

@end
