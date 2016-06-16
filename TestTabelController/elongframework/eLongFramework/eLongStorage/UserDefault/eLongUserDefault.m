//
//  eLongUserDefault.m
//  ElongClient
//
//  Created by top on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongUserDefault.h"

@implementation eLongUserDefault

+ (id)objectForKey:(NSString *)defaultName {
    if (!defaultName)
        return nil;
    [[NSUserDefaults standardUserDefaults] synchronize];
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
    return value;
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    if (!value || !defaultName)
        return;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectForKey:(NSString *)defaultName {
    if (!defaultName)
        return;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeAllObjects {
    [NSUserDefaults resetStandardUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hasObjectForKey:(id)key {
    [[NSUserDefaults standardUserDefaults] synchronize];
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value ? YES : NO;
}

@end
