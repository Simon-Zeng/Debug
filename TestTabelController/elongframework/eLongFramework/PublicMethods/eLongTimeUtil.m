//
//  eLongTimeUtil.m
//  MyElong
//
//  Created by yangfan on 15/6/26.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "eLongTimeUtil.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"
#import "NSNull+JSON.h"


static eLongTimeUtil *_instance;

@interface eLongTimeUtil ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation eLongTimeUtil

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

+ (instancetype)sharedTimeUtils {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[eLongTimeUtil alloc] init];
    });
    return _instance;
}

+ (NSDate *)getPreviousDateWithMonth:(NSInteger)month {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender	= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate			= [calender dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    return mDate;
}

+ (NSString *)descriptionFromDate:(NSDate *)date
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:today];
    NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
    NSString *tomorrowString = [dateFormatter stringFromDate:tomorrow];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}


// 计算时间差
+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=(now-late);
    
    if (cha/60<1) {
        timeString = [NSString stringWithFormat:@"%.1f", cha];
        timeString=[NSString stringWithFormat:@"%@秒", timeString];
        
    }
    if (cha/60>1&&cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/60];
        timeString=[NSString stringWithFormat:@"%@分钟", timeString];
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/3600];
        timeString=[NSString stringWithFormat:@"%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%.1f", (cha*1.0)/86400];
        timeString=[NSString stringWithFormat:@"%@天", timeString];
        
    }
    return timeString;
}

+ (NSString *)intervalDesBetweenNowAndDate:(NSDate *)fromDate {
    double aDayMinus = 24*60*60;
    double aMonthMinus = 24*60*60 * 30;
    double threeMonthMinus = 24*60*60 * 30 * 3;
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeInterval late= [fromDate timeIntervalSince1970]*1;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now= [dat timeIntervalSince1970]*1;
    
    NSString *timeString = nil;
    
    NSTimeInterval minus = (now-late);
    
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval: -aDayMinus];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString = [dateFormatter stringFromDate:today];
    NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
    NSString *dateString = [dateFormatter stringFromDate:fromDate];
    
    NSDate *noonDate = [dateFormatter dateFromString:todayString];
    NSDate *fromeDateYMD = [dateFormatter dateFromString:dateString];
    NSTimeInterval interval = [noonDate timeIntervalSinceDate:fromeDateYMD ];
    int dayNumber = interval / 24 / 3600;
    
    if ([dateString isEqualToString:todayString] || minus < 0) {
        return @"今天";
    }else if ([dateString isEqualToString:yesterdayString]) {
        return @"昨天";
    }else if (dayNumber <= 7 ) {
        timeString = @"近一周";
    }else if (minus/aMonthMinus < 1) {
        timeString = @"一周前";
    }else if (minus/threeMonthMinus < 1) {
        timeString = @"一个月前";
    }else {
        timeString = @"三个月前";
    }
    return timeString;
}

// 判断是否同一天
+ (BOOL)twoDateIsSameDay:(NSDate *)fistDate
                  second:(NSDate *)secondDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit =NSMonthCalendarUnit |NSYearCalendarUnit |NSDayCalendarUnit;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate:fistDate];
    NSDateComponents *secondComponets = [calendar components: unit fromDate: secondDate];
    
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year])
    {
        return YES;
    }
    
    return NO;
}

+ (NSString *)getNormalTimeWithSeconds:(NSInteger)currentTime Format:(NSString *)format {
    NSInteger hours	= currentTime / 3600;
    NSInteger minutes = currentTime % 3600 / 60;
    NSInteger seconds = currentTime % 3600 % 60;
    NSInteger dayNum = hours / 24;
    if (dayNum > 0) {
        hours -= dayNum * 24;
    }
    
    NSMutableString *string = [NSMutableString stringWithCapacity:2];
    if (dayNum > 0 && [format rangeOfString:@"DD"].length > 0) {
        [string appendFormat:@"%ld天", (long)dayNum];
    }
    if (hours > 0 && [format rangeOfString:@"HH"].length > 0) {
        [string appendFormat:@"%ld小时", (long)hours];
    }
    if (minutes > 0 && [format rangeOfString:@"mm"].length > 0) {
        [string appendFormat:@"%ld分", (long)minutes];
    }
    if (seconds > 0 && [format rangeOfString:@"ss"].length > 0) {
        [string appendFormat:@"%ld秒", (long)seconds];
    }
    
    return string;
}

// ===================== 原TimeUtil ==========================================

+(void)setDefaultTimeZoneWithUTC{
    NSTimeZone *tz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [NSTimeZone setDefaultTimeZone:tz];
}

+(NSDate *)NSStringToNSDate:(NSString *)string  formatter:(NSString *)formatter{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:formatter];
    //NSString *__string=[[NSString alloc] initWithString:string];
    NSDate *d = [f dateFromString:string];
    //[__string release];
    //    [f release];
    return d;
}

+(NSDate *)resetNSDate:(NSDate *)date  formatter:(NSString *)formatter{
    NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:dtz];
    [f setDateFormat:formatter];
    NSString* s = [f stringFromDate:date];
    [f setTimeZone:dtz];
    NSDate *d=[f dateFromString:s];
    //    [f release];
    return d;
    
    
}
+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date formatter:(NSString *)formatter{
    NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:formatter];
    NSString* s = [f stringFromDate:date];
    [f setTimeZone:dtz];
    NSDate *d=[f dateFromString:s];
    //    [f release];
    return d;
    
}

+(NSDate *)gmtNSDateToGMT8NSDate:(NSDate *)date{
    NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:[NSTimeZone systemTimeZone]];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString* s = [f stringFromDate:date];
    [f setTimeZone:dtz];
    NSDate *d=[f dateFromString:s];
    //    [f release];
    return d;
    
}

+(NSDate *)displayNSStringToGMT8NSDate:(NSString *)s{
    NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:dtz];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[f dateFromString:s];
    //    [f release];
    return d;
}
+(NSDate *)displayNSStringToGMT8CNNSDate:(NSString *)s {
    NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:dtz];
    [f setDateFormat:@"yyyy年MM月"];
    NSDate *d=[f dateFromString:s];
    //    [f release];
    return d;
}
+(NSString *)dPCalendarDateToString:(NSDate *)date{
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    //[f setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSString* s = [f stringFromDate:date];
    //    [f release];
    return s;
}

+(NSString *)displayDateWithNSDate:(NSDate *)date formatter:(NSString *)formatter{
    
    NSTimeZone *tz=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //NSTimeZone *tz=[NSTimeZone systemTimeZone];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    NSCalendar * lcalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [f setCalendar:lcalendar];
    [f setTimeZone:tz];
    [f setDateFormat:formatter];
    NSString* s=[f stringFromDate:date];
    //    [f release];
    return s;
    
}


+(NSString *)displayDateWithNSTimeInterval:(NSTimeInterval)seconds formatter:(NSString *)formatter{
    
    
    return [self displayDateWithNSDate:[NSDate dateWithTimeIntervalSince1970:seconds] formatter:formatter];
    
}

+(NSString *)displayDateWithJsonDate:(NSString *)jsondate formatter:(NSString *)formatter{
    
    return [self displayDateWithNSDate:[self parseJsonDate:jsondate] formatter:formatter];
    
}


+ (NSString *)displayNoTimeZoneJsonDate:(NSString *)jsonDate formatter:(NSString *)formatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSTimeZone *tz=[NSTimeZone systemTimeZone];
    [format setTimeZone:tz];
    [format setDateFormat:formatter];
    return [format stringFromDate:[self parseJsonDate:jsonDate]];
}

- (NSString *)simpleDateStringFromAbsoluteDateString:(NSString *)absoluteDateStr {
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [self.dateFormatter dateFromString:absoluteDateStr];
    self.dateFormatter.dateFormat = @"MM月dd日 HH:mm";
    NSLog(@"%@", [self.dateFormatter stringFromDate:date]);
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)simpleDateFromAbsoluteDateString:(NSString *)absoluteDateStr {
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [self.dateFormatter dateFromString:absoluteDateStr];
    self.dateFormatter.dateFormat = @"MM-dd";
    NSLog(@"%@", [self.dateFormatter stringFromDate:date]);
    
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)getWeekStrWithAbsoluteDateString:(NSString *)absoluteDateStr {
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [self.dateFormatter dateFromString:absoluteDateStr];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    NSLog(@"%@", [weekdays safeObjectAtIndex:theComponents.weekday]);
    return [weekdays safeObjectAtIndex:theComponents.weekday];
    
}

- (NSUInteger)dayIntervalFromTime:(NSString *)fromTime toTime:(NSString *)toTime {
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *fromDate = [self.dateFormatter dateFromString:fromTime];
    NSDate *toDate = [self.dateFormatter dateFromString:toTime];
    NSTimeInterval timeInterval = [toDate timeIntervalSinceDate:fromDate];
    NSUInteger dayNumber = timeInterval / 24 / 3600;
    return dayNumber;
}


+(NSDate *)parseJsonDate:(NSString *)jsondate{
    
    if (!STRINGHASVALUE(jsondate)) {
        return nil;
    }
    
    NSTimeInterval interval;
    NSRange range1 = [jsondate rangeOfString:@"/Date("];
    NSRange range2 = [jsondate rangeOfString:@")/"];
    if (range1.length ==0 && range2.length == 0) {
        interval = [jsondate longLongValue]/1000;
    }else{
        NSInteger start = range1.location + range1.length;
        NSInteger end = range2.location;
        
        BOOL isBefore1970 = NO;
        if ((end - start)>0) {
            NSRange startNum = NSMakeRange(start, 1);
            NSString * firstNum = [jsondate substringWithRange:startNum];
            // 1970年前时间戳为负数
            if ([firstNum isEqualToString:@"-"]) {
                isBefore1970 = YES;
                NSMutableString * newJsonDate = [jsondate mutableCopy];
                [newJsonDate deleteCharactersInRange:startNum];
                jsondate = newJsonDate;
            }
        }
        else{
            return nil;
        }
        
        NSCharacterSet* timezoneDelimiter = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
        NSRange rangeOfTimezoneSymbol = [jsondate rangeOfCharacterFromSet:timezoneDelimiter];
        if (rangeOfTimezoneSymbol.length!=0) {
            NSInteger firstend = rangeOfTimezoneSymbol.location;
            
            NSRange secondrange=NSMakeRange(start, firstend-start);
            NSString* timeIntervalString = [jsondate substringWithRange:secondrange];
            
            unsigned long long s = [timeIntervalString longLongValue];
            interval = s/1000;
        }
        else {
            NSRange timerange=NSMakeRange(start, end-start);
            NSString* timestring =[jsondate substringWithRange:timerange];
            unsigned long long t = [timestring longLongValue];
            interval = t/1000;
        }
        if (isBefore1970) {
            interval = 0 - interval;
        }
    }
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}


+(NSString *)makeJsonDateWithNSTimeInterval:(NSTimeInterval)seconds{
    
    NSTimeZone *stz=[NSTimeZone systemTimeZone];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:stz];
    [f setDateFormat:@"Z"];
    NSString *jsondate=[NSString stringWithFormat:@"/Date(%.f%@)/",seconds*1000,[f stringFromDate:[NSDate date]]];
    //    [f release];
    
    return jsondate;
}

//C2C 时间
+(NSString *)makeJsonDateWithNSTimeInterval_C2C:(NSTimeInterval)seconds{
    
    NSTimeZone *stz=[NSTimeZone systemTimeZone];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:stz];
    [f setDateFormat:@"Z"];
    NSString *jsondate=[NSString stringWithFormat:@"/Date(%.f%@)/",seconds,[f stringFromDate:[NSDate date]]];
    //    [f release];
    
    return jsondate;
}


+(NSString *)makeJsonDateWithUTCDate:(NSDate *)utcDate{
    NSTimeInterval seconds = [utcDate timeIntervalSince1970];
    
    return [self makeJsonDateWithNSTimeInterval:seconds];
}


+(NSString *)makeJsonDateWithDisplayNSStringFormatter:(NSString *)string formatter:(NSString *)formatter {
    
    NSTimeZone *dtz=[NSTimeZone systemTimeZone];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:dtz];
    [f setDateFormat:formatter];
    NSDate *d=[f dateFromString:string];
    //    [f release];
    
    return [self makeJsonDateWithUTCDate:d];
}

+(NSString *)getWeekStrWithJson:(NSString *)jsondate{
    NSString *weekStr = @"";
    NSDate *date = [self parseJsonDate:jsondate];
    weekStr = [self weekdayStringFromDate:date];
    return weekStr;
}


+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays safeObjectAtIndex:theComponents.weekday];
    
}

+ (NSString*)zhoujiStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周天", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays safeObjectAtIndex:theComponents.weekday];
    
}

+ (NSString *)zhoujiWithJson:(NSString *)jsonDate {
    NSString *weekStr = @"";
    NSDate *date = [self parseJsonDate:jsonDate];
    weekStr = [self zhoujiStringFromDate:date];
    return weekStr;
}


// ===================== 原TimeUtil ==========================================

// 得到星期几
+ (NSString *)getShortWeekend:(NSDate *)newDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];;
    NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    NSInteger curWeekday = [dateComponents weekday];
    
    switch (curWeekday)
    {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
    }
    
    return nil;
}

@end
