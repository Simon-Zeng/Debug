//
//  eLongAnalyticsTracker.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsTracker.h"
#import "eLongAspects.h"
#import "eLongAnalyticsEventShowModel.h"
#import "eLongAnalyticsEventClickModel.h"
#import "eLongConfiguration.h"
#import "eLongAnalyticsEventShow.h"
#import "eLongAnalyticsEventClick.h"
#import <UIKit/UIKit.h>
#import "Aspects.h"
#import "eLongDefine.h"
#import "ElongBaseViewController.h"

@interface eLongAnalyticsTracker()

@property (nonatomic, strong) NSMutableDictionary *eventDict;

@end

@implementation eLongAnalyticsTracker

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init
{
    if (self = [super init]) {
        
        self.eventDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)setUp
{
    [self setUpShowEvent];
    
    NSDictionary *allDict = [[eLongConfiguration sharedInstance] getAnalyticsEventConfig];
    
    if ([allDict count] > 0) {
        
        // 取出所有key值，每个key都是一个pageName
        NSArray *keyList = [allDict allKeys];
        
        // 遍历取出每个页面的点位配置
        for (NSString *key in keyList) {
            
            // 取出每个页面下的点位配置
            NSDictionary *eventConfigDict = [allDict objectForKey:key];
            
            // 取出click点位列表
            NSArray *clickList = [eventConfigDict objectForKey:@"clickList"];
            // 每个点位自动打点
            for (NSDictionary *eventDict in clickList) {
                
                NSString *methodName = [eventDict objectForKey:@"methodName"];
                NSString *className = [eventDict objectForKey:@"className"];
                
                [eLongAspects hookSelector:NSSelectorFromString(methodName) inClass:NSClassFromString(className) withOptions:eAspectPositionBefore usingBlock:^{
                    
                    NSString *pageName = key;
                    NSString *ch = [eventDict objectForKey:@"ch"];
                    NSString *clickSpot = [eventDict objectForKey:@"clickSpot"];
                    
                    eLongAnalyticsEventClick *click = [[eLongAnalyticsEventClick alloc] init];
                    click.pt = pageName;
                    click.ch = ch;
                    click.cspot = clickSpot;
                    
                    [click sendEventCount:1];
                    
                }error:nil];
            }
        }
    }
}


- (void)setUpShowEvent
{
    [[ElongBaseViewController class] aspect_hookSelector:NSSelectorFromString(@"viewDidAppear:") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info)
     {
         
         NSString *className = NSStringFromClass([info.instance class]);
         
         NSDictionary *dict = [[eLongConfiguration sharedInstance] getAnalyticsShowEventConfigByClassName:className];
         
         if (DICTIONARYHASVALUE(dict)) {
             
             NSString *ch = [dict objectForKey:@"ch"];
             NSString *pageName = [dict objectForKey:@"pageName"];
             
             eLongAnalyticsEventShow *click = [[eLongAnalyticsEventShow alloc] init];
             click.pt = pageName;
             click.ch = ch;
             
             [click sendEventCount:1];
         }
         
     } error:nil];
}

@end
