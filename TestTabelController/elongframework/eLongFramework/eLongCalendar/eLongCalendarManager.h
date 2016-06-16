//
//  eLongCalendarManager.h
//  eLongCalendar
//
//  Created by top on 14/12/17.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCalendarManager : NSObject

//周以什么开始 1：星期天 2：星期一
typedef NS_ENUM(NSInteger, eLongCalendarStartDay) {
    eLongCalendarStartDaySunday = 1,
    eLongCalendarStartDayMonday = 2,
};

@property (nonatomic,retain) NSCalendar *calendar;

+ (id)shared;

//重置
+(void) reset;

- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date;  //日期在月份中的第一天

- (NSArray *)getDaysOfTheWeek;         //得到周日，周一的数组

- (NSInteger)dayOfWeekForDate:(NSDate *)date;                //week中的第几天

- (BOOL)dateIsToday:(NSDate *)date;                    //是否今天

- (BOOL)dateIsTomorrow:(NSDate *)date;                    //是否今天

- (BOOL)dateIsDayAfterTomorrow:(NSDate *)date;                    //是否今天

- (NSInteger)weekNumberInMonthForDate:(NSDate *)date;

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date;

- (BOOL)dateIsInMonthShowing:(NSDate *)date otherDate:(NSDate *) otherDate;    //两个日期是否在同一个月

- (NSDate *)nextDay:(NSDate *)date;               //日期的后一天

- (NSDate *)nextMonth:(NSDate *)date;             //得到日期的下个月

- (NSInteger)getDayCountOfMonth:(NSDate *)date;        //得到日期所在月有几天

- (NSDate *)addMonth:(NSDate *)date addValue:(int)addValue;      //指定日期增加几个月

- (BOOL)dateIsEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate;    //两个日期是否相等

- (int)compareDate:(NSDate *)date1 withCheckOutDate:(NSDate *)date2;      //-比较日期

- (int)getalldays:(NSDate *)checkin withCheckOutDate:(NSDate *)checkout;   //两个日期之间间隔多少天

- (BOOL)dateIsYesterday:(NSDate *)date;        //是否是昨天

- (NSInteger)hour:(NSDate *)date;                  //得到时间hour

- (NSInteger)month:(NSDate *)date;                 //得到时间month

- (NSInteger)day:(NSDate *)date;                   //得到时间day

- (NSInteger)year:(NSDate *)date;                  //得到时间year

- (NSDate *)preDay:(NSDate *)date;            //前一天

- (NSString *)monthKey:(NSDate *)date;       //返回yyyy-MM的string

@end
