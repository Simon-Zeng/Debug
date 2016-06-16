//
//  eLongConfiguration.m
//  eLongAnalytics
//
//  全局配置类，可用来注册、读取日志自动收集、MVT配置
//
//  Created by zhaoyingze on 15/12/12.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongConfiguration.h"
#import "eLongAnalyticsGlobalModel.h"
#import "eLongAnalyticsMVTModel.h"
#import "eLongDefine.h"
#import "JSONKit.h"

@interface eLongConfiguration()

/**
 *  存储自动化打点信息
 */
@property (nonatomic, strong) NSMutableDictionary *eventDict;

/**
 *  存储自动化打点show信息
 */
@property (nonatomic, strong) NSMutableDictionary *showEventDict;

/**
 *  存储MVT配置，数据类型为Model
 */
@property (nonatomic, strong) NSMutableArray *mvtArr;

/**
 *  存储MVT配置list,数据类型为NSDictionary
 */
@property (nonatomic, strong) NSMutableArray *mvtList;

@end

@implementation eLongConfiguration

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (void)registerAnalyticsEventConfigWithBundle:(NSString *)bundle
{
    if (!_eventDict) {
        
        self.eventDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    NSDictionary *bundleRoot = [NSDictionary dictionaryWithContentsOfFile:bundle];
    [_eventDict addEntriesFromDictionary:bundleRoot];
    
    // show点位单独配置
    if (!_showEventDict) {
        
        self.showEventDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if ([bundleRoot count] > 0) {
        
        // 取出所有key值，每个key都是一个pageName
        NSArray *keyList = [bundleRoot allKeys];
        
        // 遍历取出每个页面的点位配置
        for (NSString *key in keyList) {
            
            // 取出每个页面下的点位配置
            NSDictionary *eventConfigDict = [bundleRoot objectForKey:key];
            
            // 取出show点位列表
            NSArray *showList = [eventConfigDict objectForKey:@"showList"];
            // 每个点位自动打点
            for (NSDictionary *eventDict in showList) {
                
                NSMutableDictionary *showDict = [[NSMutableDictionary alloc] initWithDictionary:eventDict];
                [showDict setObject:key forKey:@"pageName"];
                
                NSString *className = [eventDict objectForKey:@"className"];
                
                if (STRINGHASVALUE(className)) {
                    
                    [self.showEventDict setObject:showDict forKey:className];
                }
            }
        }
    }
}

- (NSDictionary *)getAnalyticsEventConfig
{
    return self.eventDict;
}

- (NSDictionary *)getAnalyticsShowEventConfigByClassName:(NSString *)className
{
    if (STRINGHASVALUE(className) && DICTIONARYHASVALUE(self.showEventDict)) {
        
        return [self.showEventDict objectForKey:className];
    }
    
    return nil;
}

- (void)registerMVTConfigWithData:(NSDictionary *)data
{
    if (DICTIONARYHASVALUE(data)) {
        
        if (!self.mvtArr) {
            
            self.mvtList = [[NSMutableArray alloc] initWithCapacity:0];
            self.mvtArr = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        NSArray *mvtListArr = [data objectForKey:@"mvtConfig"];
        
        if (ARRAYHASVALUE(mvtListArr)) {
            
            // 移除旧值
            [self.mvtArr removeAllObjects];
            [self.mvtList removeAllObjects];
            
            [self.mvtList addObjectsFromArray:mvtListArr];
            
            for (NSDictionary *dict in mvtListArr) {
                
                eLongAnalyticsMVTModel *model = [[eLongAnalyticsMVTModel alloc] initWithDictionary:dict error:nil];
                if (model) {
                    
                    [self.mvtArr addObject:model];
                }
            }
        }
    }
}

- (NSArray *)getMVTConfigList
{
    return self.mvtArr;
}

- (NSString *)getJSONStringOfMVTConfigList
{
    NSString *list = nil;
    
    if (ARRAYHASVALUE(self.mvtList)) {
        
        list = [self.mvtList JSONString];
    }
    
    return list;
}

- (eLongAnalyticsMVTModel *)getMVTWithExpId:(NSString *)expId
{
    return nil;
}

- (eLongAnalyticsMVTModel *)getMVTWithExpId:(NSString *)expId varId:(NSString *)varId
{
    eLongAnalyticsMVTModel *model = nil;
    
    if (ARRAYHASVALUE(self.mvtArr) && STRINGHASVALUE(expId) && STRINGHASVALUE(varId)) {
        
        for (eLongAnalyticsMVTModel *aModel in self.mvtArr) {
            
            if ([aModel.expId isEqualToString:expId] && [aModel.varId isEqualToString:varId]) {
                
                model = aModel;
            }
        }
    }
    
    return model;
}

@end
