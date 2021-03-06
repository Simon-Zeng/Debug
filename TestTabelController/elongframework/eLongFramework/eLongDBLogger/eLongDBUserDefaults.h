//
//  eLongUserDefaults.h
//  eLongAnalytics
//
//  Created by chenggong on 15/12/1.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface eLongDBUserDefaults : NSObject

+ (eLongDBUserDefaults *)standardUserDefaults;
- (instancetype)init;

- (nullable id)objectForKey:(NSString *)defaultName;
- (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
- (void)removeObjectForKey:(NSString *)defaultName;

//- (nullable NSString *)stringForKey:(NSString *)defaultName;
//- (nullable NSArray *)arrayForKey:(NSString *)defaultName;
//- (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;
//- (nullable NSData *)dataForKey:(NSString *)defaultName;
//- (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;
//- (NSInteger)integerForKey:(NSString *)defaultName;
//- (float)floatForKey:(NSString *)defaultName;
//- (double)doubleForKey:(NSString *)defaultName;
//- (BOOL)boolForKey:(NSString *)defaultName;
//- (nullable NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
- (void)setFloat:(float)value forKey:(NSString *)defaultName;
- (void)setDouble:(double)value forKey:(NSString *)defaultName;
- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
- (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0);

@end

NS_ASSUME_NONNULL_END