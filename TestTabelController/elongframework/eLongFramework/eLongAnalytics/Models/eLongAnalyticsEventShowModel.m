//
//  eLongAnalyticsEventShowModel.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/27.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventShowModel.h"
#import "eLongAnalyticsEventShow.h"

@implementation eLongAnalyticsEventShowModel

- (void)sendEventWithPageName:(NSString *)pageName
{
    eLongAnalyticsEventShow *show = [[eLongAnalyticsEventShow alloc] init];
    show.pt = pageName;
    show.ch = self.ch;
    
    [show sendEventCount:1];
}

@end
