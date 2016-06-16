//
//  NSMutableArray+SafeForObject.h
//  ElongIpadClient
//
//  Created by top on 15/1/29.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SafeForObject)

- (void)safeAddObject:(id)anObject;

@end
