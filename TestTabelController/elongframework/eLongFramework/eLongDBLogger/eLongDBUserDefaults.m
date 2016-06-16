//
//  eLongUserDefaults.m
//  eLongAnalytics
//
//  Created by chenggong on 15/12/1.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongDBUserDefaults.h"
#import "eLongDatabaseManager.h"

@implementation eLongDBUserDefaults

+ (eLongDBUserDefaults *)standardUserDefaults {
    static eLongDBUserDefaults *shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shareInstance = [[eLongDBUserDefaults alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[eLongDatabaseManager shareDataInstance] createTable:@"eLongDBUserDefaults" withArguments:@"'id' integer primary key autoincrement not null , 'key' varchar(30), 'value' blob" withOwnerType:eLongUserDefaultsType];
        [[eLongDatabaseManager shareDataInstance] createIndex:@"key" withIndexName:@"keyIndex" withOwnerType:eLongUserDefaultsType];
    }
    return self;
}

- (nullable id)objectForKey:(NSString *)defaultName {
    return [[eLongDatabaseManager shareDataInstance] queryByKey:defaultName];
}

- (void)setObject:(nullable id)value forKey:(NSString *)defaultName {
    [[eLongDatabaseManager shareDataInstance] setObject:value forKey:defaultName withDatabaseOwnerType:eLongUserDefaultsType];
}

- (void)removeObjectForKey:(NSString *)defaultName {
    [[eLongDatabaseManager shareDataInstance] removeObjectForKey:defaultName withDatabaseOwnerType:eLongUserDefaultsType];
} 

//- (nullable NSString *)stringForKey:(NSString *)defaultName {
//}
//
//- (nullable NSArray *)arrayForKey:(NSString *)defaultName {
//}
//
//- (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName {
//}
//
//- (nullable NSData *)dataForKey:(NSString *)defaultName {
//}
//
//- (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName {
//}
//
//- (NSInteger)integerForKey:(NSString *)defaultName {
//}
//
//- (float)floatForKey:(NSString *)defaultName {
//}
//
//- (double)doubleForKey:(NSString *)defaultName {
//}
//
//- (BOOL)boolForKey:(NSString *)defaultName {
//}
//
//- (nullable NSURL *)URLForKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0) {
//}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName {
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName {
}

- (void)setDouble:(double)value forKey:(NSString *)defaultName {
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName {
}

- (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName NS_AVAILABLE(10_6, 4_0) {
}

@end
