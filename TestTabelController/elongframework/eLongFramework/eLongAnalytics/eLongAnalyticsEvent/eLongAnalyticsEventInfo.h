//
//  eLongAnalyticsEventInfo.h
//  eLongAnalytics
//
//  手动打点时使用此类
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventBase.h"

@interface eLongAnalyticsEventInfo : eLongAnalyticsEventBase

/**
 *  触发位置
 */
@property (nonatomic, copy) NSString *tri;

@end
