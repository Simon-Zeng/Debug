//
//  eLongAnalyticsEventClick.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventClick.h"

@implementation eLongAnalyticsEventClick

- (void)sendEventCount:(NSInteger)count
{
    [super sendEvent:@"click" count:count];
}

@end
