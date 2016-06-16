//
//  eLongTimeUtil.h
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongTimeUtil : NSObject

// 获取今天以后（之前）x月的日期
+ (NSDate *)getPreviousDateWithMonth:(NSInteger)month;

// 获取今天还是明天的日期
+ (NSString *)descriptionFromDate:(NSDate *)date;

// 计算时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate;

// 计算时间差（今天、昨天、近一周、一周前、一个月前、三个月前）
+ (NSString *)intervalDesBetweenNowAndDate:(NSDate *)fromDate;

// 判断是否同一天
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate
                  second:(NSDate *)secondDate;

// 按照秒数获取x天x小时x分x秒的时间，format使用"DD-HH-mm-ss"决定输出哪些单位的时间
+ (NSString *)getNormalTimeWithSeconds:(NSInteger)currentTime Format:(NSString *)format;

// ===================== 原TimeUtil ==========================================
+(void)setDefaultTimeZoneWithUTC;
+(NSDate *)NSStringToNSDate:(NSString *)string  formatter:(NSString *)formatter;
+(NSString *)dPCalendarDateToString:(NSDate *)date;
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date formatter:(NSString *)formatter;
+(NSString *)displayDateWithNSDate:(NSDate *)date formatter:(NSString *)formatter;
+(NSString *)displayDateWithNSTimeInterval:(NSTimeInterval)seconds formatter:(NSString *)formatter;
+(NSString *)displayDateWithJsonDate:(NSString *)jsondate formatter:(NSString *)formatter;
+(NSDate *)parseJsonDate:(NSString *)jsondate;
+(NSString *)makeJsonDateWithNSTimeInterval:(NSTimeInterval)seconds;
+(NSString *)makeJsonDateWithUTCDate:(NSDate *)utcDate;
+(NSString *)makeJsonDateWithDisplayNSStringFormatter:(NSString *)string formatter:(NSString *)formatter;
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date;
+(NSDate *)displayNSStringToGMT8NSDate:(NSString *)s;
+(NSDate *)resetNSDate:(NSDate *)date  formatter:(NSString *)formatter;
+(NSDate *)displayNSStringToGMT8CNNSDate:(NSString *)s;
+ (NSString *)displayNoTimeZoneJsonDate:(NSString *)jsonDate formatter:(NSString *)formatter;

//C2C 时间
+(NSString *)makeJsonDateWithNSTimeInterval_C2C:(NSTimeInterval)seconds;

+ (instancetype)sharedTimeUtils;
- (NSString *)simpleDateStringFromAbsoluteDateString:(NSString *)absoluteDateStr;
- (NSString *)simpleDateFromAbsoluteDateString:(NSString *)absoluteDateStr;
- (NSString *)getWeekStrWithAbsoluteDateString:(NSString *)absoluteDateStr;
- (NSUInteger)dayIntervalFromTime:(NSString *)fromTime toTime:(NSString *)toTime;
/**
 *  获取星期x字符串
 *
 *  @param jsondate jsonDate
 *
 *  @return 获取星期x的Str
 */
+(NSString *)getWeekStrWithJson:(NSString *)jsondate;

/**
 *  获取周几字符串
 *
 *  @param jsondate jsonDate
 *
 *  @return 获取周几的Str
 */
+ (NSString *)zhoujiWithJson:(NSString *)jsonDate;
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate;

// ===================== 原TimeUtil ==========================================

// 得到星期几
+ (NSString *)getShortWeekend:(NSDate *)newDate;

@end
