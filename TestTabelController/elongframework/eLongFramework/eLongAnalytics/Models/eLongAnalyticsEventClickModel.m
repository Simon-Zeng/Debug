//
//  eLongAnalyticsEventClickModel.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/27.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventClickModel.h"
#import "eLongAnalyticsEventClick.h"

@implementation eLongAnalyticsEventClickModel

- (void)sendEventWithPageName:(NSString *)pageName
{
    eLongAnalyticsEventClick *click = [[eLongAnalyticsEventClick alloc] init];
    click.pt = pageName;
    click.ch = self.ch;
    click.cspot = self.clickSpot;
    
    [click sendEventCount:1];
}

@end
