//
//  eLongAnalyticsEventClickModel.h
//  eLongAnalytics
//
//  用于自动打点配置文件转换，手动打点禁用
//
//  Created by zhaoyingze on 15/11/27.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsEventBaseModel.h"

@interface eLongAnalyticsEventClickModel : eLongAnalyticsEventBaseModel

/**
 *  点击动作名称
 */
@property (nonatomic, copy) NSString *clickSpot;

@end
