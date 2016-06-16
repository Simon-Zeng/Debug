//
//  eLongCalendarHandler.m
//  TestCalendar
//
//  Created by top on 15/10/12.
//  Copyright © 2015年 top. All rights reserved.
//

#import "eLongCalendarHandler.h"
#import "eLongCalendar.h"
#import "eLongCalendarMonthModel.h"
#import "eLongCalendarDateModel.h"
#import "eLongCalendarDataSourceModel.h"
#import "eLongCalendarStatutoryHolidayModel.h"
#import "eLongNetworking.h"
#import "eLongDefine.h"
#import "NSDictionary+CheckDictionary.h"
#import "eLongCalendarSpecialTitleModel.h"

//周以什么开始 1：星期天 2：星期一
typedef NS_ENUM(NSInteger, eLongCalendarStartDay) {
    eLongCalendarStartDaySunday = 1,
    eLongCalendarStartDayMonday = 2,
};

@interface eLongCalendarHandler ()

@property (nonatomic, strong) eLongCalendar *calendar;

@property (nonatomic, strong, readwrite) NSMutableArray *cellModelsData;

@property (nonatomic, strong) NSMutableDictionary *statutoryHolidayModelsData;

@property (nonatomic, strong) NSMutableArray *dateModelsData;

@property (nonatomic, strong) NSMutableArray *periodDateModelsData;

@property (nonatomic, strong, readwrite) NSMutableDictionary *periodDict;

@end

@implementation eLongCalendarHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showLunarDate = NO;
        _calendar = [[eLongCalendar alloc] init];
        _cellModelsData = [NSMutableArray new];
        _statutoryHolidayModelsData = [NSMutableDictionary new];
        _dateModelsData = [NSMutableArray new];
        _periodDateModelsData = [NSMutableArray new];
        _periodDict = [NSMutableDictionary new];
    }
    return self;
}

- (void)reset {
    self.showLunarDate = NO;
    [self.periodDateModelsData removeAllObjects];
    [self.periodDict removeAllObjects];
    [self.dateModelsData removeAllObjects];
    [self.statutoryHolidayModelsData removeAllObjects];
    [self.cellModelsData removeAllObjects];
    self.dataSourceModel = nil;
    self.startDateModel = nil;
    self.endDateModel = nil;
}

- (void)configureCellModelsData {
    [self p_fetchStatutoryHolidayData];
    
    [self p_configureCellModelsData];
    
    if (self.startDateModel && self.endDateModel) {
        [self refreshPeriodCellModels];
    }
}

- (void)p_configureCellModelsData {
    NSDate *date = self.dataSourceModel.disabledToSelectBeforeDate ? self.dataSourceModel.disabledToSelectBeforeDate : [NSDate date];
    for (NSInteger i = 0; i < self.dataSourceModel.numberOfMonths; i++) {
        [self.cellModelsData addObject:[self p_configureMonthDataWithDate:date indexOfMonth:i]];
        date = [self.calendar nextMonthWithDate:date];
    }
}

- (void)p_fetchStatutoryHolidayData {
    [self.statutoryHolidayModelsData removeAllObjects];
    NSArray *statutoryHoliday = [eLongUserDefault objectForKey:@"elongCalendarStatutoryHolidayData"];
    if (ARRAYHASVALUE(statutoryHoliday)) {
        [statutoryHoliday enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            eLongCalendarStatutoryHolidayModel *statutoryHolidayModel = [[eLongCalendarStatutoryHolidayModel alloc] initWithDictionary:obj error:nil];
            [self.statutoryHolidayModelsData setObject:statutoryHolidayModel forKey:statutoryHolidayModel.holidayWorkdayDate];
        }];
    }
}

- (eLongCalendarMonthModel *)p_configureMonthDataWithDate:(NSDate *)date
                                             indexOfMonth:(NSInteger)indexOfMonth {
    NSDate *startDate = [self.calendar firstDateOfMonthWithDate:date];
    NSInteger month = [self.calendar monthOfYearWithDate:startDate];
    NSInteger year = [self.calendar yearWithDate:startDate];
    NSMutableArray *cellModels = [NSMutableArray new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"elc_holiday_new" ofType:@"plist"];
    NSMutableDictionary *dicHoliday = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSInteger startDateWeekNumber = [self.calendar weekdayWithDate:startDate];
    for (int i = 1; i < startDateWeekNumber; i++) {
        eLongCalendarDateModel *dateModel = [[eLongCalendarDateModel alloc] init];
        dateModel.shouldShow = NO;
        dateModel.date = [self.calendar preDateWithDate:startDate];
        dateModel.dayOfLunar = self.showLunarDate ? [self.calendar dayOfLunarWithDate:dateModel.date] : nil;
        dateModel.dateString = [NSString stringWithFormat:@"%ld",(long)[self.calendar dayWithDate:dateModel.date]];
        dateModel.selectType = eLongCalendarDateModelSelectTypeNone;
        startDate = [self.calendar preDateWithDate:startDate];
        [cellModels insertObject:dateModel atIndex:0];
    }
    
    startDate = [self.calendar firstDateOfMonthWithDate:date];
    NSInteger days = [self.calendar daysOfMonthWithDate:date];
    for (NSInteger i = 0; i < days; i++) {
        eLongCalendarDateModel *dateModel = [[eLongCalendarDateModel alloc] init];
        dateModel.shouldShow = YES;
        dateModel.date = startDate;
        dateModel.dayOfLunar = self.showLunarDate ? [self.calendar dayOfLunarWithDate:dateModel.date] : nil;
        dateModel.weekDay = [self.calendar weekdayWithDate:dateModel.date];
        dateModel.selectType = eLongCalendarDateModelSelectTypeNone;
        if ([self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:[NSDate date]] == eLongCalendarDateComparisonEqual) {
            dateModel.dateString = @"今天";
        } else {
            NSString *holidayKey = [self.calendar gregorianDateStringWithDate:dateModel.date];
            if ([dicHoliday safeObjectForKey:holidayKey]) {
                dateModel.dateString = [dicHoliday safeObjectForKey:holidayKey];
            } else {
                dateModel.dateString = [NSString stringWithFormat:@"%ld",(long)[self.calendar dayWithDate:dateModel.date]];
            }
        }
        
        if (DICTIONARYHASVALUE(self.statutoryHolidayModelsData)) {
            eLongCalendarStatutoryHolidayModel *statutoryHolidayModel = [self.statutoryHolidayModelsData safeObjectForKey:[self.calendar gregorianDateStringWithDate:dateModel.date]];
            if (statutoryHolidayModel && [statutoryHolidayModel isKindOfClass:[eLongCalendarStatutoryHolidayModel class]]) {
                dateModel.statutoryHolidayModel = statutoryHolidayModel;
            }
        }
        
        if (ARRAYHASVALUE(self.dataSourceModel.changeSomeDateTitleArray)) {
            [self.dataSourceModel.changeSomeDateTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[eLongCalendarSpecialTitleModel class]]) {
                    eLongCalendarSpecialTitleModel *specialTitleModel = (eLongCalendarSpecialTitleModel *)obj;
                    if ([self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:specialTitleModel.date] == eLongCalendarDateComparisonEqual) {
                        dateModel.commonTitle = STRINGHASVALUE(specialTitleModel.title) ? specialTitleModel.title : nil;
                        if (specialTitleModel.titleColor && [specialTitleModel.titleColor isKindOfClass:[UIColor class]]) {
                            dateModel.commonTitleColor = specialTitleModel.titleColor;
                        }
                        *stop = YES;
                    }
                }
            }];
        }
        
        if (self.dataSourceModel.disabledToSelectBeforeDate
            && [self.dataSourceModel.disabledToSelectBeforeDate isKindOfClass:[NSDate class]]) {
            eLongCalendarDateComparison comparingResult = [self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:self.dataSourceModel.disabledToSelectBeforeDate];
            if (comparingResult == eLongCalendarDateComparisonBefore) {
                dateModel.disabled = YES;
            }
        }
        
        if (self.dataSourceModel.disabledToSelectAfterDate
            && [self.dataSourceModel.disabledToSelectAfterDate isKindOfClass:[NSDate class]]) {
            eLongCalendarDateComparison comparingResult = [self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:self.dataSourceModel.disabledToSelectAfterDate];
            if (comparingResult == eLongCalendarDateComparisonAfter) {
                dateModel.disabled = YES;
            }
        }
        
        if (self.dataSourceModel.periodStartDate && [self.dataSourceModel.periodStartDate isKindOfClass:[NSDate class]]) {
            if ([self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:self.dataSourceModel.periodStartDate] == eLongCalendarDateComparisonEqual) {
                dateModel.specialTitle = self.dataSourceModel.titleOfStartDate;
                dateModel.selected = YES;
                switch (self.calendarViewStyle) {
                    case eLongCalendarViewStyleNone: {
                        break;
                    }
                    case eLongCalendarViewStylePeriod: {
                        dateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
                        break;
                    }
                    case eLongCalendarViewStyleOneDate: {
                        dateModel.selectType = eLongCalendarDateModelSelectTypeOnlyOneDate;
                        break;
                    }
                    default: {
                        break;
                    }
                }
                self.startDateModel = dateModel;
            }
        }
        
        if (self.dataSourceModel.periodEndDate && [self.dataSourceModel.periodEndDate isKindOfClass:[NSDate class]]) {
            if ([self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:self.dataSourceModel.periodEndDate] == eLongCalendarDateComparisonEqual) {
                dateModel.specialTitle = self.dataSourceModel.titleOfEndDate;
                dateModel.selected = YES;
                dateModel.selectType = eLongCalendarDateModelSelectTypeEndDate;
                self.endDateModel = dateModel;
            }
        }
        
        startDate = [self.calendar nextDateWithDate:startDate];
        [cellModels addObject:dateModel];
        dateModel.cellIndexPath = [NSIndexPath indexPathForRow:i inSection:indexOfMonth];
        [self.dateModelsData addObject:dateModel];
    }
    
    NSInteger endDateWeekNumber = [self.calendar weekdayWithDate:startDate];
    if (endDateWeekNumber != 1) {
        for (int i = 0; i <= 7 - endDateWeekNumber; i++) {
            eLongCalendarDateModel *dateModel = [[eLongCalendarDateModel alloc] init];
            dateModel.shouldShow = NO;
            dateModel.date = startDate;
            dateModel.dayOfLunar = self.showLunarDate ? [self.calendar dayOfLunarWithDate:dateModel.date] : nil;
            dateModel.dateString = [NSString stringWithFormat:@"%ld",(long)[self.calendar dayWithDate:dateModel.date]];
            dateModel.selectType = eLongCalendarDateModelSelectTypeNone;
            [cellModels addObject:dateModel];
        }
    }
    
    eLongCalendarMonthModel *monthModel = [[eLongCalendarMonthModel alloc] init];
    monthModel.days = cellModels;
    monthModel.month = month;
    monthModel.year = year;
    
    return monthModel;
}

- (void)refreshPeriodCellModels {
    eLongCalendarDateComparison comparingResult = [self.calendar compareTwoDateWithFirstDate:self.startDateModel.date secondDate:self.endDateModel.date];
    [self.periodDict removeAllObjects];
    switch (comparingResult) {
        case eLongCalendarDateComparisonBefore: {
            int days = [self.calendar daysBetweenTwoDateWithFirstDate:self.startDateModel.date secondDate:self.endDateModel.date];
            self.startDateModel.selected = YES;
            self.endDateModel.selected = YES;
            NSRange daysRange = NSMakeRange([self.dateModelsData indexOfObject:self.startDateModel], days);
            if (daysRange.location + daysRange.length < self.dateModelsData.count) {
                [self.periodDateModelsData addObjectsFromArray:[self.dateModelsData subarrayWithRange:daysRange]];
            }
            [self.periodDateModelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                eLongCalendarDateModel *model = (eLongCalendarDateModel *)obj;
                model.selected = YES;
                model.selectType = eLongCalendarDateModelSelectTypeMarkPoint;
            }];
            self.startDateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
            self.endDateModel.selectType = eLongCalendarDateModelSelectTypeEndDate;
            
            self.startDateModel.specialTitle = self.dataSourceModel.titleOfStartDate;
            self.endDateModel.specialTitle = self.dataSourceModel.titleOfEndDate;
            
            [self.periodDict setObject:self.startDateModel.date forKey:@"checkinDate"];
            [self.periodDict setObject:self.endDateModel.date forKey:@"checkoutDate"];
            [self.periodDict setObject:[NSNumber numberWithInt:days] forKey:@"selectDays"];
        }
            break;
        case eLongCalendarDateComparisonAfter: {
            self.startDateModel.selected = NO;
            self.startDateModel.specialTitle = nil;
            self.startDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
            self.startDateModel = self.endDateModel;
            self.endDateModel = nil;
            self.startDateModel.specialTitle = self.dataSourceModel.titleOfStartDate;
            self.startDateModel.selected = YES;
            self.startDateModel.selectType = eLongCalendarDateModelSelectTypeStartDate;
        }
            break;
        case eLongCalendarDateComparisonEqual: {
            self.startDateModel.selected = NO;
            self.startDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
            self.startDateModel.specialTitle = nil;
            self.startDateModel = nil;
            self.endDateModel.selected = NO;
            self.endDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
            self.endDateModel.specialTitle = nil;
            self.endDateModel = nil;
        }
            break;
        default:
            break;
    }
}

- (void)refreshSpecialTitle {
    if (ARRAYHASVALUE(self.dataSourceModel.changeSomeDateTitleArray)) {
        [self.dataSourceModel.changeSomeDateTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[eLongCalendarSpecialTitleModel class]]) {
                eLongCalendarSpecialTitleModel *specialTitleModel = (eLongCalendarSpecialTitleModel *)obj;
                for (eLongCalendarMonthModel *monthModel in self.cellModelsData) {
                    [monthModel.days enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        eLongCalendarDateModel *dateModel = (eLongCalendarDateModel *)obj;
                        if ([self.calendar compareTwoDateWithFirstDate:dateModel.date secondDate:specialTitleModel.date] == eLongCalendarDateComparisonEqual) {
                            dateModel.commonTitle = STRINGHASVALUE(specialTitleModel.title) ? specialTitleModel.title : nil;
                            if (specialTitleModel.titleColor && [specialTitleModel.titleColor isKindOfClass:[UIColor class]]) {
                                dateModel.commonTitleColor = specialTitleModel.titleColor;
                            }
                            *stop = YES;
                        }
                    }];
                }
            }
        }];
    }
}

- (void)resetMarkCellModels {
    if (self.periodDateModelsData.count > 0) {
        [self.periodDateModelsData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            eLongCalendarDateModel *model = (eLongCalendarDateModel *)obj;
            model.selected = NO;
            model.selectType = eLongCalendarDateModelSelectTypeNone;
        }];
        [self.periodDateModelsData removeAllObjects];
    }
}

- (void)resetPeriodCellModels {
    [self resetMarkCellModels];
    self.startDateModel.selected = NO;
    self.startDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
    self.endDateModel.selected = NO;
    self.endDateModel.selectType = eLongCalendarDateModelSelectTypeNone;
    self.startDateModel.specialTitle = nil;
    self.endDateModel.specialTitle = nil;
    self.startDateModel = nil;
    self.endDateModel = nil;
}

- (BOOL)checkMaximumLimitNumberOfDaysWithDays:(NSInteger)numberOfDays {
    eLongCalendarDateComparison comparingResult = [self.calendar compareTwoDateWithFirstDate:self.startDateModel.date secondDate:self.endDateModel.date];
    if (comparingResult == eLongCalendarDateComparisonBefore) {
        int days = [self.calendar daysBetweenTwoDateWithFirstDate:self.startDateModel.date secondDate:self.endDateModel.date];
        if (days > numberOfDays) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)yearWithDate:(NSDate *)date {
    return [self.calendar yearWithDate:date];
}

- (NSInteger)monthWithDate:(NSDate *)date {
    return [self.calendar monthOfYearWithDate:date];
}

@end

