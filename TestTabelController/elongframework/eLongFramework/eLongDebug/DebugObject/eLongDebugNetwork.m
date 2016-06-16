//
//  eLongDebugNetwork.m
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugNetwork.h"
#import "eLongDebugDB.h"
#import <UIKit/UIKit.h>

static NSString *networkDebugModelName = @"Network";        // 网络存储数据表名
static const NSInteger requestMaxCacheAge = 60 * 60 * 12;   // 数据最长保留时间为0.5天

@implementation eLongDebugNetwork

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanRequest)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanRequest)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (eLongDebugNetworkModel *) beginRequest {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    eLongDebugNetworkModel *networkModel = [debugDB insertEntity:networkDebugModelName];
    networkModel.begindate = [NSDate date];
    return networkModel;
}

- (void) endRequest:(eLongDebugNetworkModel *)networkModel {
    if (!self.enabled) {
        return;
    }
    networkModel.enddate = [NSDate date];
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
}

- (NSArray *) requests {
    return [self requestsBeginDate:nil endDate:nil];
}

- (NSArray *) requestsBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSPredicate *query = nil;
    if (beginDate && endDate) {
        query = [NSPredicate predicateWithFormat:@"(begindate > %@) AND (begindate < %@) AND enddate != nil",beginDate,endDate];
    }else if(beginDate){
        query = [NSPredicate predicateWithFormat:@"(begindate > %@) AND enddate != nil",beginDate];
    }else if(endDate){
        query = [NSPredicate predicateWithFormat:@"(begindate < %@) AND enddate != nil",endDate];
    }else{
        query = [NSPredicate predicateWithFormat:@"enddate != nil"];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"begindate" ascending:NO];
    return [debugDB selectDataFromEntity:networkDebugModelName
                                   query:query
                                    sort:sort];
}

- (void) cleanRequest {
    if (!self.enabled) {
        return;
    }
    // 查找过期的请求，并删除requestMaxCacheAge之前的数据
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB removeDataFromEntity:networkDebugModelName
                            query:[NSPredicate predicateWithFormat: @"(begindate < %@)",[[NSDate alloc] initWithTimeIntervalSinceNow:-requestMaxCacheAge]]];
    [debugDB saveContext];
}

- (void) clearRequest {
    if (!self.enabled) {
        return;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB clearEntity:networkDebugModelName];
    [debugDB saveContext];
}
@end
