//
//  eLongFileIOUtils.m
//  eLongFramework
//
//  Created by yangfan on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongFileIOUtils.h"

@implementation eLongFileIOUtils

@end

@implementation NSDictionary (ELC_Utility)

- (id)safeObjectForKey:(id)aKey
{
    if ([self isKindOfClass:[NSDictionary class]] &&
        ([self objectForKey:aKey] != nil))
    {
        return [self objectForKey:aKey];
    }
    
    return nil;
}
@end

@implementation NSMutableDictionary (ELC_Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    if(anObject != nil)
    {
        [self setObject:anObject forKey:aKey];
    }
}
@end

@implementation NSArray (ELC_Utility)

-(id) safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSUInteger)safeCount
{
    if ([self isKindOfClass:[NSArray class]])
    {
        return [(NSArray *)self count];
    }
    else if ([self isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)self count];
    }
    else
    {
        return 0;
    }
}

@end
