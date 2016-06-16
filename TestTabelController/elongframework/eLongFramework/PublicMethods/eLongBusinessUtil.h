//
//  eLongBusinessUtil.h
//  MyElong
//
//  Created by yangfan on 15/6/29.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongHotelConfig.h"
#import <UIKit/UIKit.h>

typedef enum
{
    eLongIDCARD_IS_VALID = 0,                            //合法身份证
    eLongIDCARD_LENGTH_SHOULD_NOT_BE_NULL,               //身份证号码不能为空
    eLongIDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18,     //身份证号码长度应该为15位或18位
    eLongIDCARD_SHOULD_BE_15_DIGITS,                     //身份证15位号码都应为数字
    eLongIDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE,      //身份证18位号码除最后一位外，都应为数字
    eLongIDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW,     //身份证出生年月日不能大于当前日期
    eLongIDCARD_BIRTHDAY_IS_INVALID,                     //身份证出生年月日不是合法日期
    eLongIDCARD_REGION_ENCODE_IS_INVALID,                //输入的身份证号码地域编码不符合大陆和港澳台规则
    eLongIDCARD_IS_INVALID,                              //身份证无效，不是合法的身份证号码
    eLongIDCARD_PARSER_ERROR,                            //解析身份证发生错误
}eLongIdCardValidationType;


@interface eLongBusinessUtil : NSObject

// ============= 原Public Methods =================
// 获取passbook数据
+ (NSData *)getPassDateByType:(NSString *)type
                      orderID:(NSString *)orderId
                      cardNum:(NSString *)num
                          lat:(NSString *)latitude
                          lon:(NSString *)longitude;

+ (NSString *)getPassUrlByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude;

// 是否登录
+ (BOOL)  adjustIsLogin;

// 获取龙萃会员信息
+ (void)getLongVIPInfo;


// 存储酒店搜索关键词及其对应城市(国际城市适用)
+ (void) saveSearchKey:(NSString *)key forCity:(NSString *)city;

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city;

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid propertiesType:(NSNumber *)pidType lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city;
// 获取指定城市下所有的关键词
+ (NSArray *) allSearchKeysForCity:(NSString *)city;

// 清除指定城市下所有的关键词
+ (void) clearSearchKeyforCity:(NSString *)city;

// 纠偏算法 WGS84->CGJ_02
+ (void) wgs84ToGCJ_02WithLatitude:(double *)lat longitude:(double *)lon;

// 判断国内酒店地标是否需要纠偏
+ (BOOL) needSwitchWgs84ToGCJ_02:(NSString *)cityName;

// 判断国际酒店地标是否需要纠偏
//+ (BOOL) needSwitchWgs84ToGCJ_02Abroad;

// 判断国内团购地标是否需要纠偏
+ (BOOL) needSwitchWgs84ToGCJ_02Groupon:(NSString *)cityName;

// 获取酒店星级
+ (NSString *) getStar:(NSInteger)level;

//得到评论描述
+(NSString *) getCommentDespLogic:(NSInteger) goodComment badComment:(NSInteger) badComment comentPoint:(float) commentPoint;

//得到评论描述(老)
+(NSString *) getCommentDespOldLogic:(NSInteger) goodComment badComment:(NSInteger) badComment;

// 获取公寓星级
+ (NSString *) getHouseStar:(NSInteger)level;

// 返回首页每个模块的标识
+ (NSInteger) getHomeItemType:(NSInteger)tag;
+ (NSString *) getHomeItemName:(NSInteger)tag;

// 通过价格返回Level
+ (NSInteger) getMaxPriceLevel:(NSInteger)price;
+ (NSInteger) getMinPriceLevel:(NSInteger)price;

//扩展通过价格返回level
+ (NSInteger) getMaxPriceLevel:(NSInteger)price andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion;
+ (NSInteger) getMinPriceLevel:(NSInteger)price andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion;

// 通过Level返回价格
+ (NSInteger) getMinPriceByLevel:(NSInteger)level;
+ (NSInteger) getMaxPriceByLevel:(NSInteger)level;

//扩展通过价格返回Level
+ (NSInteger) getMinPriceByLevel:(NSInteger)level andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion;
+ (NSInteger) getMaxPriceByLevel:(NSInteger)level andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion;


//是否可以支付宝app支付
+(BOOL) couldPayByAlipayApp;

/**
 *  比较两个字符串型的版本号
 */
+ (BOOL)version:(NSString *)aVersion lessthanOtherVersion:(NSString *)other;

// ============= 原Public Methods =================

// ================== 原Utils ======================

//+ (NSString *)getOrderStatusIcon:(int)orderStatus;
//+ (NSString *)getTicketStatusName:(NSString *)flightS dict:(NSDictionary *)dict;
//+ (int)getTicketStatus:(NSString *)flightS dict:(NSDictionary *)dict;
//
//+ (NSString *)getAirCorpPicName:(NSString *)airCorpName;
//+ (NSString *)getAirCorpShortName:(NSString *)airCorpName;
//+ (UIColor *)getFlightStatusColor:(NSInteger)statusCode;
//
//+ (NSString *)getCertificateName:(NSInteger)key;
//+ (int)getClassTypeID:(NSString *)name;
//+ (NSString *)getClassTypeName:(int)type;
+ (void)clearHotelData;

+ (NSDate *) getBirthday: (NSString *)idNumber;
+ (eLongIdCardValidationType)isIdCardNumberValid:(NSString *)idNumber;

// ================== 原Utils ======================

@end
