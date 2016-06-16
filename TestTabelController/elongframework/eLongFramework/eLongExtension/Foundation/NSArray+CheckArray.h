//
//  NSArray+CheckArray.h
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (CheckArray)

/**
 *  是否有值
 *
 *  @return YES or NO
 */
- (BOOL)hasValue;

- (id)safeObjectAtIndex:(NSUInteger)index;

@end
