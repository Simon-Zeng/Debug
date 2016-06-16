//
//  eLongCalendarStatutoryHolidayModel.h
//  TestCalendar
//
//  Created by top on 15/9/24.
//  Copyright © 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface eLongCalendarStatutoryHolidayModel : JSONModel

@property (nonatomic, copy) NSString *holidayWorkdayDate;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *statusDes;

/*
holidayWorkdayDate	String	假期调休日期(yyyy-MM-dd)
status	int	状态(1:休 2:班)
statusDes	String	状态描述
*/

@end
