//
//  eLongLunarCalendar.m
//  TestCalendar
//
//  Created by top on 15/9/14.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import "eLongLunarCalendar.h"

//数组存入阴历1900年到2100年每年中的月天数信息，
//阴历每月只能是29或30天，一年用12（或13）个二进制位表示，对应位为1表30天，否则为29天
int LunarCalendarInfo[] = {
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
    0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
    
    0x04b63,0x0937f,0x049f8,0x04970,0x064b0,0x068a6,0x0ea5f,0x06b20,0x0a6c4,0x0aaef,
    0x092e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x04b55,0x04b6f,0x0a570,0x054e4,0x0d260,
    0x0e968,0x0d520,0x0daa0,0x06aa6,0x056df,0x04ae0,0x0a9d4,0x0a4d0,0x0d150,0x0f252,
    0x0d520};

@interface eLongLunarCalendar ()

@property (nonatomic, strong) NSArray *heavenlyArray;

@property (nonatomic, strong) NSArray *earthlyArray;

@property (nonatomic, strong) NSArray *chineseZodiacArray;

@property (nonatomic, strong) NSArray *solarTermsArray;

@property (nonatomic, strong) NSArray *lunarMonthArray;

@property (nonatomic, strong) NSArray *lunarDayArray;

@end

@implementation eLongLunarCalendar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureData];
    }
    return self;
}

- (void)configureData {
    _heavenlyArray = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
    _earthlyArray = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    _chineseZodiacArray = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    _solarTermsArray = [NSArray arrayWithObjects:@"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", @"小寒", @"大寒", nil];
    
    _lunarMonthArray = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    
    _lunarDayArray = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
}

- (NSString *)dayOfLunarWithDate:(NSDate *)date {
    if (!date || ![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    
    NSString *start = @"1900-01-31";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];

    NSString *end = [dateFormatter stringFromDate:date];
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    int sumdays = (int)[components day];
    
    int tempdays = 0;
    
    int lunarYear = 0;
    
    //计算农历年
    for (lunarYear = 1900; lunarYear < 2100 && sumdays > 0; lunarYear++) {
        tempdays = [self lunarYearDays:lunarYear];
        sumdays -= tempdays;
    }
    
    if (sumdays < 0) {
        sumdays += tempdays;
        lunarYear--;
    }
    
    //计算闰月
    int doubleMonth = [self doubleMonth:lunarYear];
    BOOL isLeap = false;
    
    //计算农历月
    int lunarMonth = 0;
    for (lunarMonth = 1; lunarMonth < 13 && sumdays > 0; lunarMonth++) {
        //闰月
        if (doubleMonth > 0 && lunarMonth == (doubleMonth + 1) && isLeap == false) {
            --lunarMonth;
            isLeap = true;
            tempdays = [self doubleMonthDays:lunarYear];
        } else {
            tempdays = [self monthDays:lunarYear:lunarMonth];
        }
        
        //解除闰月
        if (isLeap == true && lunarMonth == (doubleMonth + 1)) {
            isLeap = false;
        }
        sumdays -= tempdays;
    }
    
    //计算农历日
    if (sumdays == 0 && doubleMonth > 0 && lunarMonth == doubleMonth + 1) {
        if (isLeap) {
            isLeap = false;
        } else {
            isLeap = true;
            --lunarMonth;
        }
    }
    
    if (sumdays < 0) {
        sumdays += tempdays;
        --lunarMonth;
    }
    
    int lunarDay = sumdays + 1;
    
    NSString *dayLunar = (NSString *)[self.lunarDayArray objectAtIndex:(lunarDay - 1)];
    if ([dayLunar isEqualToString:@"初一"]) {
        dayLunar = (NSString *)[self.lunarMonthArray objectAtIndex:(lunarMonth - 1)];
    }
    return dayLunar;
}

- (int)lunarYearDays:(int)y {
    int i, sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1)
    {
        if ((LunarCalendarInfo[y - 1900] & i) != 0)
            sum += 1;
    }
    return (sum + [self doubleMonthDays:y]);
}

///返回农历年闰月的天数
- (int)doubleMonthDays:(int)y {
    if ([self doubleMonth:y] != 0)
        return (((LunarCalendarInfo[y - 1900] & 0x10000) != 0) ? 30 : 29);
    else
        return (0);
}

- (int)doubleMonth:(int)y {
    return (LunarCalendarInfo[y - 1900] & 0xf);
}

///返回农历年月份的总天数
- (int)monthDays:(int)y :(int)m {
    return (((LunarCalendarInfo[y - 1900] & (0x10000 >> m)) != 0) ? 30 : 29);
}

@end
