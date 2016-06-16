//
//  eLongCalendarHandler.h
//  TestCalendar
//
//  Created by top on 15/10/12.
//  Copyright © 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongCalendarDefine.h"

@class eLongCalendarDataSourceModel;
@class eLongCalendarDateModel;

@interface eLongCalendarHandler : NSObject

@property (nonatomic, strong) eLongCalendarDataSourceModel *dataSourceModel;

@property (nonatomic, strong) eLongCalendarDateModel *startDateModel;

@property (nonatomic, strong) eLongCalendarDateModel *endDateModel;

@property (nonatomic, assign) eLongCalendarViewStyle calendarViewStyle;

@property (nonatomic, assign) BOOL showLunarDate;

@property (nonatomic, strong, readonly) NSMutableArray *cellModelsData;

@property (nonatomic, strong, readonly) NSMutableDictionary *periodDict;

- (void)reset;

- (void)configureCellModelsData;

- (void)refreshSpecialTitle;

- (void)refreshPeriodCellModels;

- (void)resetMarkCellModels;

- (void)resetPeriodCellModels;

- (NSInteger)yearWithDate:(NSDate *)date;

- (NSInteger)monthWithDate:(NSDate *)date;

- (BOOL)checkMaximumLimitNumberOfDaysWithDays:(NSInteger)numberOfDays;

@end
