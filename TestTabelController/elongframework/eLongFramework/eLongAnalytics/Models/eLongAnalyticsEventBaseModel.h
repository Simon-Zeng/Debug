//
//  eLongAnalyticsEventBaseModel.h
//  eLongAnalytics
//
//  用于自动打点配置文件转换，手动打点禁用
//
//  Created by zhaoyingze on 15/11/27.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "JSONModel.h"

@interface eLongAnalyticsEventBaseModel : JSONModel

/**
 *  频道
 */
@property (nonatomic, copy) NSString *ch;

/**
 *  点位所在的类名
 */
@property (nonatomic, copy) NSString *className;

/**
 *  需要打点的方法
 */
@property (nonatomic, copy) NSString *methodName;

- (void)sendEventWithPageName:(NSString *)pageName;

@end
