//
//  eLongCalendarManager.m
//  eLongCalendar
//
//  Created by top on 14/12/17.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "eLongCalendarManager.h"

static eLongCalendarManager *curCalendar;

@implementation eLongCalendarManager
@synthesize calendar;

+ (id)shared{
    @synchronized(curCalendar){
        if (!curCalendar){
            [eLongCalendarManager initCurCalendar];
        }
        [eLongCalendarManager reset];
        return curCalendar;
    }
}

+ (void)initCurCalendar{
    curCalendar = [[eLongCalendarManager alloc] init];
    curCalendar.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [curCalendar.calendar setLocale:[NSLocale currentLocale]];
    [curCalendar.calendar setFirstWeekday:eLongCalendarStartDaySunday];
}

+ (void)reset{
    [curCalendar.calendar setLocale:[NSLocale currentLocale]];
}

- (NSDateComponents *)configureDateComponents:(NSDate *)date{
    NSDateComponents *comps = [self.calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday) fromDate:date];
    return comps;
}

//本月的第一天
- (NSDate *)firstDayOfMonthContainingDate:(NSDate *)date{
    NSDateComponents *comps = [self configureDateComponents:date];
    [comps setDay:1];
    return [self.calendar dateFromComponents:comps];
}

//周一，周二，周三。。。
- (NSArray *)getDaysOfTheWeek {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // adjust array depending on which weekday should be first
    NSArray *weekdays = [dateFormatter shortWeekdaySymbols];
    NSInteger firstWeekdayIndex = [self.calendar firstWeekday] -1;
    if (firstWeekdayIndex > 0){
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7-firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0,firstWeekdayIndex)]];
    }
    return weekdays;
}

- (NSInteger)dayOfWeekForDate:(NSDate *)date{
    NSDateComponents *comps = [self configureDateComponents:date];
    return comps.weekday;
}

- (BOOL)dateIsToday:(NSDate *)date{
    NSDateComponents *otherDay = [self configureDateComponents:date];
    NSDateComponents *today = [self configureDateComponents:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

- (BOOL)dateIsYesterday:(NSDate *)date{
    NSDateComponents *otherDay = [self configureDateComponents:date];
    NSDateComponents *yesterday = [self configureDateComponents:[NSDate dateWithTimeIntervalSinceNow:-(24*3600)]];
    return ([yesterday day] == [otherDay day] &&
            [yesterday month] == [otherDay month] &&
            [yesterday year] == [otherDay year] &&
            [yesterday era] == [otherDay era]);
}

- (BOOL)dateIsTomorrow:(NSDate *)date{
    NSDateComponents *otherDay = [self configureDateComponents:date];
    NSDateComponents *tmorrow = [self configureDateComponents:[NSDate dateWithTimeIntervalSinceNow:(24*3600)]];
    return ([tmorrow day] == [otherDay day] &&
            [tmorrow month] == [otherDay month] &&
            [tmorrow year] == [otherDay year] &&
            [tmorrow era] == [otherDay era]);
}

- (BOOL)dateIsDayAfterTomorrow:(NSDate *)date{
    NSDateComponents *otherDay = [self configureDateComponents:date];
    NSDateComponents *dayAfterTmorrow = [self configureDateComponents:[NSDate dateWithTimeIntervalSinceNow:(24*3600*2)]];
    return ([dayAfterTmorrow day] == [otherDay day] &&
            [dayAfterTmorrow month] == [otherDay month] &&
            [dayAfterTmorrow year] == [otherDay year] &&
            [dayAfterTmorrow era] == [otherDay era]);
}

- (BOOL)dateIsEqual:(NSDate *)firstDate secondDate:(NSDate *)secondDate{
    if(firstDate==nil||secondDate==nil)
        return NO;
    NSDateComponents *firstDay = [self configureDateComponents:firstDate];
    NSDateComponents *secondDay = [self configureDateComponents:secondDate];
    return ([firstDay day] == [secondDay day] &&
            [firstDay month] == [secondDay month] &&
            [firstDay year] == [secondDay year] &&
            [firstDay era] == [secondDay era]);
}

//-比较日期
- (int)compareDate:(NSDate *)date1 withCheckOutDate:(NSDate *)date2{
    if(date1==nil||date2==nil)
        return 100;
    
    NSDateComponents *firstDay = [self configureDateComponents:date1];
    NSDateComponents *secondDay = [self configureDateComponents:date2];
    
    NSInteger year0 = [firstDay year];
    NSInteger year1 = [secondDay year];
    NSInteger month0 = [firstDay month];
    NSInteger month1 = [secondDay month];
    NSInteger day0 = [firstDay day];
    NSInteger day1 = [secondDay day];
    
    if (year0 > year1) {
        return 1;
    }else if(year0 == year1){
        if (month0 > month1) {
            return 1;
        }else if(month0 == month1){
            if (day0 > day1) {
                return 1;
            }else if(day0 == day1){
                return 0;
            }else{
                return -1;
            }
        }else{
            return -1;
        }
    }else {
        return -1;
    }
}

//计算相差几天
- (int)getalldays:(NSDate *)checkin withCheckOutDate:(NSDate *)checkout{
    if(checkin==nil||checkout==nil)
        return 0;
    
    int compareValue = [self compareDate:checkin withCheckOutDate:checkout];
    if(compareValue == 1 || compareValue == 0){
        return 0;
    }
    NSTimeInterval time = [checkout timeIntervalSinceDate:checkin];
    int days = ((int)time) / (3600*24);
    return days;
}

- (NSInteger)weekNumberInMonthForDate:(NSDate *)date{
    NSDateComponents *comps = [self configureDateComponents:date];
    return comps.weekOfMonth;
}

- (int)numberOfWeeksInMonthContainingDate:(NSDate *)date{
    return (int)[self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (BOOL)dateIsInMonthShowing:(NSDate *)date otherDate:(NSDate *)otherDate{
    NSDateComponents *comps1 = [self configureDateComponents:otherDate];
    NSDateComponents *comps2 = [self configureDateComponents:date];
    return comps1.month == comps2.month;
}

- (NSString *)monthKey:(NSDate *)date{
    NSString *monthKey = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[self year:date],(long)[self month:date],(long)[self day:date]];
    return monthKey;
}

- (NSDate *)nextDay:(NSDate *)date{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    NSDate *nextDay = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return nextDay;
}

- (NSDate *)preDay:(NSDate *)date{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    NSDate *preDay = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return preDay;
}

- (NSDate *)nextMonth:(NSDate *)date{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *nextMonth = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return nextMonth;
}

- (NSDate *)addMonth:(NSDate *)date addValue:(int)addValue{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:addValue];
    NSDate *re = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    return re;
}

- (NSInteger)getDayCountOfMonth:(NSDate *)date{
    NSDate *fromDate = [self firstDayOfMonthContainingDate:date];
    NSDate *toDate = [self nextMonth:fromDate];
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return comps.day;
}

- (NSInteger)hour:(NSDate *)date{
    NSDateComponents *components= [self configureDateComponents:date];
    return [components hour];
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components= [self configureDateComponents:date];
    return [components month];
}

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components= [self configureDateComponents:date];
    return [components day];
}

-(NSInteger) year:(NSDate *)date{
    NSDateComponents *components= [self configureDateComponents:date];
    return [components year];
}

@end
