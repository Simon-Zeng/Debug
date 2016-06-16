//
//  eLongAnalyticsGlobalModel.h
//  eLongAnalytics
//
//  日志收集全局model，用于存储日志收集关键信息
//
//  Created by zhaoyingze on 15/12/1.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface eLongAnalyticsGlobalModel : NSObject

+ (instancetype)sharedInstance;

/**
 *  device id
 */
@property (nonatomic, copy) NSString *deviceId;

/**
 *  客户端打开类型 用户主动 1 唤起  2，启动时上传
 */
@property (nonatomic, copy) NSString *opens;

/**
 *  channelId，启动时上传
 */
@property (nonatomic, copy) NSString *chid;

/**
 *  客户端类型，默认为1
 */
@property (nonatomic, copy) NSString *clientType;

/**
 *  客户端类型，艺龙旅行传1，艺龙酒店传2
 */
@property (nonatomic, copy) NSString *appv;

/**
 *  session
 */
@property (nonatomic, copy, readonly) NSString *sid;

/**
 *  基于cid的日志自增编号
 */
@property (nonatomic, strong, readonly) NSNumber *cin;

/**
 *  频道
 */
@property (nonatomic, copy) NSString *ch;

/**
 *  上一跳页面名称
 */
@property (nonatomic, copy) NSString *rf;

/**
 *  orderfrom,访问来源，每次变化，成单后用最后一次的orderfrom，本机/站用一个默认的，和财务统计有关很重要
 */
@property (nonatomic, copy) NSString *of;

/**
 *  内部跳转标识，回首页后重置
 */
@property (nonatomic, copy) NSString *aif;


/**
 *  获取首次上传信息,静态信息
 *
 *  @return 返回一个NSDictionary
 */
- (NSDictionary *)getBasicAnalyticsInfo;

/**
 *  返回打点需要的基本信息，每次打点时调用
 *
 *  @return 返回一个NSDictionary
 */
- (NSDictionary *)getAnalyticsInfo;

/**
 *  更新日志Id
 */
- (void)updateCin;

/**
 *  给一个url追加日志收集信息
 *
 *  @param urlStr url
 *
 *  @return 追加之后的url
 */
- (NSString *)urlStringAppendAnalyticsData:(NSString *)urlStr;

/**
 *  重置业绩统计字段（if、of）
 */
- (void)resetAchievementFlag;

/**
 *  重置业绩统计字段of值
 */
- (void)resetOfValue;

/**
 *  重置业绩统计字段of值
 */
- (void)resetIfValue;

@end
