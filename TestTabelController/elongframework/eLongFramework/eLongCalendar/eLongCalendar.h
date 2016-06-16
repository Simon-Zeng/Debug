//
//  eLongCalendar.h
//  TestCalendar
//
//  Created by top on 15/9/11.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, eLongCalendarDateComparison) {
    eLongCalendarDateComparisonBefore,   //日期之前
    eLongCalendarDateComparisonEqual,    //日期相同
    eLongCalendarDateComparisonAfter,    //日期之后
};

@interface eLongCalendar : NSObject

- (NSDate *)firstDateOfMonthWithDate:(NSDate *)date;

- (NSDate *)nextDateWithDate:(NSDate *)date;

- (NSDate *)preDateWithDate:(NSDate *)date;

- (NSInteger)weekdayWithDate:(NSDate *)date;

- (NSInteger)yearWithDate:(NSDate *)date;

- (NSInteger)monthOfYearWithDate:(NSDate *)date;

- (NSInteger)dayWithDate:(NSDate *)date;

- (NSInteger)hourWithDate:(NSDate *)date;

- (NSDate *)nextMonthWithDate:(NSDate *)date;

- (NSInteger)daysOfMonthWithDate:(NSDate *)date;

- (NSString *)dayOfLunarWithDate:(NSDate *)date;

- (eLongCalendarDateComparison)compareTwoDateWithFirstDate:(NSDate *)firstDate
                                                secondDate:(NSDate *)secondDate;      //-比较日期

- (NSString *)gregorianDateStringWithDate:(NSDate *)date;

- (int)daysBetweenTwoDateWithFirstDate:(NSDate *)firstDate
                            secondDate:(NSDate *)secondDate;

@end