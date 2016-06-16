//
//  eLongConfiguration.h
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/12/12.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongAnalyticsMVTModel.h"

#define MVT_SEARCH_NAME @"searchMVT"

@interface eLongConfiguration : NSObject

/**
 *  eLongConfiguration
 *
 *  @return eLongConfiguration实例
 */
+ (instancetype)sharedInstance;

/**
 *  注册自动化打点本地配置
 *
 *  @param bundle 本地文件bundle
 */
- (void)registerAnalyticsEventConfigWithBundle:(NSString *)bundle;

/**
 *  读取自动化打点配置
 *
 *  @return 打点配置
 */
- (NSDictionary *)getAnalyticsEventConfig;

/**
 *  根据类名获取show点位配置
 *
 *  @param className 类名
 *
 *  @return 配置字典
 */
- (NSDictionary *)getAnalyticsShowEventConfigByClassName:(NSString *)className;


/**
 *  注册MVT
 *
 *  @param data 数据或字典
 */
- (void)registerMVTConfigWithData:(NSDictionary *)data;

/**
 *  获取MVT配置
 *
 *  @return 返回一个数据，每个数组存储一个eLongAnalyticsMVTModel对象
 */
- (NSArray *)getMVTConfigList;

/**
 *  获取所有MVT配置的json字符串
 *
 *  @return json字符串
 */
- (NSString *)getJSONStringOfMVTConfigList;

/**
 *  根据实验id获取实验,现已废弃
 *
 *  @param expId 实验id
 *
 *  @return eLongAnalyticsMVTModel对象
 */
- (eLongAnalyticsMVTModel *)getMVTWithExpId:(NSString *)expId;

/**
 *  根据实验id、变量id获取mvt实验
 *
 *  @param expId 实验id
 *  @param varId 变量id
 *
 *  @return eLongAnalyticsMVTModel对象
 */
- (eLongAnalyticsMVTModel *)getMVTWithExpId:(NSString *)expId varId:(NSString *)varId;

@end
