//
//  eLongCountlyEventBase.m
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventBase.h"
#import "eLongCountlyEventClick.h"
#import "eLongCountlyEventShow.h"
#import "Countly.h"
#import <objc/runtime.h>
#import "eLongNetworkSerialization.h"

@implementation eLongCountlyEventBase

- (void)sendEvent:(NSString *)event count:(NSInteger)count {
    
    NSMutableArray *properties = [NSMutableArray array];
    if ([self isMemberOfClass:[eLongCountlyEventClick class]]
        || [self isMemberOfClass:[eLongCountlyEventShow class]]) {
        [properties addObjectsFromArray:[self getProperties:[self class]]];
    }else{
        [properties addObjectsFromArray:[self getProperties:[self class]]];
        [properties addObjectsFromArray:[self getProperties:self.superclass]];
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *key in properties) {
        if ([self valueForKey:key]) {
            [params setObject:[self valueForKey:key] forKey:key];
        }else{
            // 没有数据时传递空串
            [params setObject:@"" forKey:key];
        }
    }
    
    [params setObject:@([Countly sharedInstance].status) forKey:@"status"];
    //所有都加ch
    [params setObject:[self getUniCH] forKey:@"ch"];
    NSLog(@"记录打点，ch名:%@",params[@"ch"]);
    [[Countly sharedInstance] recordEvent:event segmentation:params count:count];
}

- (void)sendEventCount:(NSInteger)count {
    
}

- (NSString *)description {
    NSMutableArray *properties = [NSMutableArray array];
    if ([self isMemberOfClass:[eLongCountlyEventClick class]]
        || [self isMemberOfClass:[eLongCountlyEventShow class]]) {
        [properties addObjectsFromArray:[self getProperties:[self class]]];
    }else{
        [properties addObjectsFromArray:[self getProperties:[self class]]];
        [properties addObjectsFromArray:[self getProperties:self.superclass]];
        
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *key in properties) {
        if ([self valueForKey:key]) {
            [params setObject:[self valueForKey:key] forKey:key];
        }else{
            // 没有数据时传递空串
            [params setObject:@"" forKey:key];
        }
    }
    return [eLongNetworkSerialization jsonStringWithObject:params];
}

- (NSArray *)getProperties:(Class)class {
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);
    
    NSMutableArray *properties = [NSMutableArray array];
    for (int i = 0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        [properties addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return properties;
}

- (NSString *)getUniCH
{
    NSString * retStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"Countly_allEvents_ch"];
    return retStr?retStr:@"ch not set";
}

- (void)setCh:(NSString *)ch
{
    if (ch.length<=0) {
        return;
    }
    _ch = ch;
    [[NSUserDefaults standardUserDefaults] setObject:_ch forKey:@"Countly_allEvents_ch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
