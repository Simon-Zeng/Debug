//
//  eLongServices.h
//  ElongClient
//
//  Created by Kirn on 15/4/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongServices : NSObject
+ (instancetype) services;
+ (void) addService:(NSString *)service class:(NSString *)className protocol:(NSString *)protocol singleton:(BOOL)singleton;
- (void) addService:(NSString *)service class:(NSString *)className protocol:(NSString *)protocol singleton:(BOOL)singleton;
+ (void) callService:(NSString *)service,...;
- (void) callService:(NSString *)service arguments:(va_list)argList;

// 带返回值的服务 注意：参数和返回值不能为int、NSInteger、BOOL等基础数据类型，基础数据类型可转化为NSNumber代替
+ (id)callServiceHasReturnValue:(NSString *)service,...;

@end
