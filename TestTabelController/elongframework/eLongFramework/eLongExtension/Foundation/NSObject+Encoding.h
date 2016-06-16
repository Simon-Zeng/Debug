//
//  NSObject+Encoding.h
//  MyElong
//
//  Created by yangfan on 15/6/17.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Encoding)

- (NSUInteger)safeCount;                // 封装数组和字典的count方法，当null对象执行时，返回0
- (NSString *)JSONRepresentation;
- (NSString *)JSONRepresentationWithURLEncoding;


// 将简单对象转换成Object
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary;

@end
