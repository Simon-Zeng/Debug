//
//  eLongAnalyticsEventBase.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventBase.h"
#import "eLongAnalyticsGlobalModel.h"
#import <objc/runtime.h>
#import "eLongNetworkSerialization.h"
#import "eLongAnalyticsLogger.h"
#import "JSONKit.h"
#import "eLongDefine.h"
#import "eLongConfiguration.h"

@implementation eLongAnalyticsEventBase

- (void)sendEvent:(NSString *)event count:(NSInteger)count {
    
    NSMutableArray *properties = [NSMutableArray array];
    
    Class baseClass = [self class];
    
    while ([baseClass isSubclassOfClass:[eLongAnalyticsEventBase class]]) {
        
        [properties addObjectsFromArray:[self getProperties:baseClass]];
        
        baseClass = [baseClass superclass];
    }
    
    eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
    NSDictionary *baseParams = [globalModel getAnalyticsInfo];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:baseParams];
    
    for (NSString *key in properties) {
        
        if ([self valueForKey:key]) {
            
            [params setObject:[self valueForKey:key] forKey:key];
        }
    }
    
    // 事件类型
    [params setObject:event forKey:@"et"];
    //所有都加ch
    NSString *ch = [self getUniCH];
    if (STRINGHASVALUE(ch)) {
        
        [params setObject:ch forKey:@"ch"];
    }
    // 日志自增id
    [params setObject:globalModel.cin forKey:@"cin"];
    // MVT配置
    eLongConfiguration *config = [eLongConfiguration sharedInstance];
    NSString *mvt = [config getJSONStringOfMVTConfigList];
    if (STRINGHASVALUE(mvt)) {
        
        [params setObject:mvt forKey:@"mvt"];
    }
    
    // 日志全局唯一id
    NSString *uuid = [self getUUID];
    if (uuid.length > 0) {
        
        [params setObject:uuid forKey:@"id"];
    }
    
    if (globalModel.rf.length > 0) {
        
        // 上一跳页面名称
        [params setObject:globalModel.rf forKey:@"rf"];
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *st = [NSString stringWithFormat:@"%0.0lf",time * 1000];
    [params setObject:st forKey:@"st"];
    
    NSLog(@"elongAnalytics----%@",[params JSONString]);
    
    eLongAnalyticsLogger *logger = [eLongAnalyticsLogger shareLogger];
    [logger recordLogFlexible:params];
    
    globalModel.rf = self.pt;
    [globalModel updateCin];
}

- (void)sendEventCount:(NSInteger)count {
    
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
    eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
    NSString * retStr = globalModel.ch;
    
    return retStr;
}

- (void)setCh:(NSString *)ch
{
    if (!STRINGHASVALUE(ch)) {
        
        return;
    }
    _ch = ch;
    
    eLongAnalyticsGlobalModel *globalModel = [eLongAnalyticsGlobalModel sharedInstance];
    globalModel.ch = _ch;
}

- (NSString *)getUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

@end
