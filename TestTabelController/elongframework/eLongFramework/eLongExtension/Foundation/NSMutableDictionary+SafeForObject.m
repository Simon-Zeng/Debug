//
//  NSMutableDictionary+SafeForObject.m
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import "NSMutableDictionary+SafeForObject.h"
#import "NSDictionary+CheckDictionary.h"

@implementation NSMutableDictionary (SafeForObject)

- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    if(anObject != nil)
    {
        [self setObject:anObject forKey:aKey];
    }
}

// 为了去除酒店详情重复图片专门定制的方法
- (void)removeRepeatingImage
{
    NSArray *imageItems = [self safeObjectForKey:@"HotelImageItems"];
    NSMutableArray *images = [NSMutableArray array];
    NSString *imgPath = nil;
    
    for (NSDictionary *dic in imageItems)
    {
        if (![[dic safeObjectForKey:@"ImagePath"] isEqualToString:imgPath])
        {
            // 重复的url不添加
            [images addObject:dic];
            imgPath = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:@"ImagePath"]];
        }
    }
    
    [self safeSetObject:images forKey:@"HotelImageItems"];
}


@end
