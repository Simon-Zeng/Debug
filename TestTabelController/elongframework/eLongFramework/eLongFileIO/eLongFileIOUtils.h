//
//  eLongFileIOUtils.h
//  eLongFramework
//
//  Created by yangfan on 15/5/6.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongFileIOUtils : NSObject

@end

// =====================================================
// NSDictionary category
// =====================================================
@interface NSDictionary (ELC_Utility)

- (id)safeObjectForKey:(id)aKey;

@end

// =====================================================
// NSMutableDictionary category
// =====================================================
@interface NSMutableDictionary (ELC_Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey;

@end

// =====================================================
// NSArray category
// =====================================================
@interface NSArray (ELC_Utility)

-(id) safeObjectAtIndex:(NSUInteger)index;
- (NSUInteger)safeCount;


@end