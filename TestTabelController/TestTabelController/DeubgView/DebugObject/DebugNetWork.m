//
//  DebugNetWork.m
//  TestTabelController
//
//  Created by wzg on 16/6/28.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugNetWork.h"
#import <UIKit/UIKit.h>
#import "DebugDB.h"
#import "NetWork.h"

static NSString *networkDebugModelName = @"NetWork";        // 网络存储数据表名
static const NSInteger requestMaxCacheAge = 60 * 60 * 12;   // 数据最长保留时间为0.5天

@interface DebugNetWork()
@property (nonatomic, strong)NSArray *fiterList;
@end

@implementation DebugNetWork
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanRequest) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanRequest) name:UIApplicationBackgroundRefreshStatusDidChangeNotification object:nil];
        
    }
    return self;
}

- (NetWork *) beginRequest
{
    if (!self.enable) {
        return nil;
    }
    
    DebugDB *db = [DebugDB shareInstance];
    NetWork *netWork = [db insertEntity:networkDebugModelName];
    netWork.beginDate = [NSDate date];
    return netWork;
}

- (void) endRequest:(NetWork *)networkModel
{
    if (!self.enable) {
        return ;
    }
    
    DebugDB *db = [DebugDB shareInstance];
    [db saveContext];
    networkModel.endDate = [NSDate date];
}

- (void) cleanRequest
{
    if (!self.enable) {
        return ;
    }
    
    DebugDB *db = [DebugDB shareInstance];
    [db removeDataFromEntity:networkDebugModelName query:[NSPredicate predicateWithFormat: @"(beginDate < %@)",[[NSDate alloc] initWithTimeIntervalSinceNow:-requestMaxCacheAge]]];
    [db saveContext];
    
    NSArray *result = [db selectDataFromEntity:networkDebugModelName query:[NSPredicate predicateWithFormat: @"(beginDate < %@)",[[NSDate alloc] initWithTimeIntervalSinceNow:-requestMaxCacheAge]]];
    
    CGFloat count = [[[NSUserDefaults standardUserDefaults] valueForKey:@"netflowCount"] floatValue];
    for (NetWork *net in result) {
        count -= net.size.floatValue;
    }
    [[NSUserDefaults standardUserDefaults] setValue:@(count) forKey:@"netflowCount"];
}

- (void) clearRequest
{
    if (!self.enable) {
        return ;
    }
    DebugDB *db = [DebugDB shareInstance];
    [db clearEntity:networkDebugModelName];
    [db saveContext];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"netflowCount"];
}

- (NSArray *) requests
{
    return  [self requestsBeginDate:nil endDate:nil];
}

- (NSArray *) requestsBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    if (!self.enable) {
        return nil;
    }
    DebugDB *db = [DebugDB shareInstance];
    NSPredicate *query = nil;
    if (beginDate && endDate) {
        query = [NSPredicate predicateWithFormat:@"(beginDate > %@) AND (beginDate < %@) AND endDate != nil",beginDate,endDate];
    }else if(beginDate){
        query = [NSPredicate predicateWithFormat:@"(beginDate > %@) AND endDate != nil",beginDate];
    }else if(endDate){
        query = [NSPredicate predicateWithFormat:@"(beginDate < %@) AND endDate != nil",endDate];
    }else{
        query = [NSPredicate predicateWithFormat:@"endDate != nil"];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"beginDate" ascending:NO];
    return [db selectDataFromEntity:networkDebugModelName
                                   query:query
                                    sort:sort];

}

- (NSArray *)setFilterList:(NSArray<NSString *> *)list
{
    if (!self.enable) {
        return nil;
    }
    
    if (!list.count) {
        return [self requests];
    }
    
    DebugDB *db = [DebugDB shareInstance];
    NSMutableArray *arrM = [NSMutableArray array];
    NSPredicate *query = nil;
    for (NSString *str in list) {
        query = [NSPredicate predicateWithFormat:@"path CONTAINS %@",str];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"beginDate" ascending:NO];
        [arrM addObjectsFromArray:[db selectDataFromEntity:networkDebugModelName
                                  query:query
                                                      sort:sort]];
    }
    return arrM.copy;
}
@end
