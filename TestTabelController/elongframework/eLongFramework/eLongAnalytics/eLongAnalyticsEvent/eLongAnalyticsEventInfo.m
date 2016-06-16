//
//  eLongAnalyticsEventInfo.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventInfo.h"

@implementation eLongAnalyticsEventInfo

- (void)sendEventCount:(NSInteger)count
{
    [super sendEvent:@"info" count:count];
}

@end
