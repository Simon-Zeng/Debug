//
//  NSDictionary+CheckDictionary.h
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CheckDictionary)

/**
 *  是否有值
 *
 *  @return YES or NO
 */
- (BOOL)hasValue;

- (id)safeObjectForKey:(id)aKey;

@end
