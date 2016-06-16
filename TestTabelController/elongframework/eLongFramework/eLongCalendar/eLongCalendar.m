//
//  eLongCalendar.m
//  TestCalendar
//
//  Created by top on 15/9/11.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import "eLongCalendar.h"
#import "eLongLunarCalendar.h"

//周以什么开始 1：星期天 2：星期一
typedef NS_ENUM(NSInteger, eLongCalendarStartDay) {
    eLongCalendarStartDaySunday = 1,
    eLongCalendarStartDayMonday = 2,
};

@interface eLongCalendar ()

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, strong) eLongLunarCalendar *lunarCalendar;

@end

@implementation eLongCalendar

- (instancetype)init {
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_calendar setLocale:[NSLocale systemLocale]];
        [_calendar setFirstWeekday:eLongCalendarStartDaySunday];
    }
    return self;
}

- (NSDateComponents *)configureDateComponents:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitEra
                                                         | NSCalendarUnitYear
                                                         | NSCalendarUnitMonth
                                                         | NSCalendarUnitDay
                                                         | NSCalendarUnitHour
                                                         | NSCalendarUnitWeekOfMonth
                                                         | NSCalendarUnitWeekday)
                                               fromDate:date];
    return comps;
}

- (NSDate *)firstDateOfMonthWithDate:(NSDate *)date {
    NSDateComponents *comps = [self configureDateComponents:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

- (NSDate *)nextDateWithDate:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *nextDay = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return nextDay;
}

- (NSDate *)preDateWithDate:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    NSDate *preDay = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return preDay;
}

- (NSInteger)weekdayWithDate:(NSDate *)date {
    NSDateComponents *comps = [self configureDateComponents:date];
    return comps.weekday;
}

- (NSInteger)dayWithDate:(NSDate *)date {
    NSDateComponents *components= [self configureDateComponents:date];
    return [components day];
}

- (NSInteger)hourWithDate:(NSDate *)date {
    NSDateComponents *components= [self configureDateComponents:date];
    return [components hour];
}

- (NSInteger)monthOfYearWithDate:(NSDate *)date {
    NSDateComponents *comps = [self configureDateComponents:date];
    return comps.month;
}

- (NSInteger)yearWithDate:(NSDate *)date {
    NSDateComponents *components= [self configureDateComponents:date];
    return [components year];
}

- (NSDate *)nextMonthWithDate:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *nextMonth = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return nextMonth;
}

- (NSInteger)daysOfMonthWithDate:(NSDate *)date {
    NSDate *fromDate = [self firstDateOfMonthWithDate:date];
    NSDate *toDate = [self nextMonthWithDate:fromDate];
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return comps.day;
}

- (NSString *)dayOfLunarWithDate:(NSDate *)date {
    if (!self.lunarCalendar) {
        self.lunarCalendar = [[eLongLunarCalendar alloc] init];
    }
    return [self.lunarCalendar dayOfLunarWithDate:date];
}

- (eLongCalendarDateComparison)compareTwoDateWithFirstDate:(NSDate *)firstDate secondDate:(NSDate *)secondDate {
    if(firstDate == nil || secondDate == nil)
        return 100;
    
    NSDateComponents *firstDay = [self configureDateComponents:firstDate];
    NSDateComponents *secondDay = [self configureDateComponents:secondDate];
    
    NSInteger year0 = [firstDay year];
    NSInteger year1 = [secondDay year];
    NSInteger month0 = [firstDay month];
    NSInteger month1 = [secondDay month];
    NSInteger day0 = [firstDay day];
    NSInteger day1 = [secondDay day];
    
    if (year0 > year1) {
        return eLongCalendarDateComparisonAfter;
    } else if (year0 == year1) {
        if (month0 > month1) {
            return eLongCalendarDateComparisonAfter;
        } else if (month0 == month1) {
            if (day0 > day1) {
                return eLongCalendarDateComparisonAfter;
            } else if(day0 == day1) {
                return eLongCalendarDateComparisonEqual;
            } else {
                return eLongCalendarDateComparisonBefore;
            }
        } else {
            return eLongCalendarDateComparisonBefore;
        }
    } else {
        return eLongCalendarDateComparisonBefore;
    }
}

- (NSString *)gregorianDateStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:self.calendar];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

- (int)daysBetweenTwoDateWithFirstDate:(NSDate *)firstDate
                            secondDate:(NSDate *)secondDate {
    if(firstDate ==nil || secondDate == nil)
        return 0;
    
    int days = 0;
    eLongCalendarDateComparison compareValue = [self compareTwoDateWithFirstDate:firstDate secondDate:secondDate];
    switch (compareValue) {
        case eLongCalendarDateComparisonAfter: {
            NSTimeInterval time = [firstDate timeIntervalSinceDate:secondDate];
            days = ((int)time) / (3600*24);
        }
            break;
        case eLongCalendarDateComparisonBefore: {
            NSTimeInterval time = [secondDate timeIntervalSinceDate:firstDate];
            days = ((int)time) / (3600*24);
        }
            break;
        case eLongCalendarDateComparisonEqual:
            break;
        default:
            break;
    }
    return days;
}

@end
