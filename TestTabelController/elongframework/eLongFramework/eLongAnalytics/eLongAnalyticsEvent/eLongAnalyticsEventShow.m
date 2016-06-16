//
//  eLongAnalyticsEventShow.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventShow.h"
#import "eLongAnalyticsGlobalModel.h"

@implementation eLongAnalyticsEventShow

- (void)sendEventCount:(NSInteger)count
{
    [super sendEvent:@"show" count:count];
}

@end
