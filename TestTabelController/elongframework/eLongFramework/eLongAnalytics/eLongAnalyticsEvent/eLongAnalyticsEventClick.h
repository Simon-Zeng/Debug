//
//  eLongAnalyticsEventClick.h
//  eLongAnalytics
//
//  手动打点时使用此类
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventBase.h"

@interface eLongAnalyticsEventClick : eLongAnalyticsEventBase

/**
 *  点位名称
 */
@property (nonatomic, copy) NSString *cspot;

@end
