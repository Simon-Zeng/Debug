//
//  eLongCalendarDataSourceModel.h
//  TestCalendar
//
//  Created by top on 15/9/23.
//  Copyright © 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCalendarDataSourceModel : NSObject

@property (nonatomic, assign) BOOL showLunarCalendar;

@property (nonatomic, assign) NSInteger numberOfMonths;

@property (nonatomic, strong) NSDate *periodStartDate;

@property (nonatomic, strong) NSDate *periodEndDate;

@property (nonatomic, copy) NSString *titleOfStartDate;

@property (nonatomic, copy) NSString *titleOfEndDate;

@property (nonatomic, strong) NSDate *disabledToSelectBeforeDate;

@property (nonatomic, strong) NSDate *disabledToSelectAfterDate;

@property (nonatomic, strong) NSArray *changeSomeDateTitleArray;

@end
