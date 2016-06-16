//
//  NSMutableDictionary+SafeForObject.h
//  ElongIpadClient
//
//  Created by top on 15/1/28.
//  Copyright (c) 2015年 dragonyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeForObject)

- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey;

// 为了去除酒店详情重复图片专门定制的方法
- (void)removeRepeatingImage;

@end
