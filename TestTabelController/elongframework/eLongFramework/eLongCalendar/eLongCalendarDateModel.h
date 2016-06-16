//
//  eLongCalendarDateModel.h
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright © 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongCalendarStatutoryHolidayModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, eLongCalendarDateModelSelectType) {
    eLongCalendarDateModelSelectTypeNone,           //未选中
    eLongCalendarDateModelSelectTypeStartDate,      //选中两个时间点中开始的日期
    eLongCalendarDateModelSelectTypeMarkPoint,      //选中两个时间点中介于开始日期和结束日期之间的日期段
    eLongCalendarDateModelSelectTypeEndDate,        //选中两个时间点中结束的日期
    eLongCalendarDateModelSelectTypeOnlyOneDate,    //选中一个日期（单选一个日期点）
};

@interface eLongCalendarDateModel : NSObject

@property (nonatomic, assign) eLongCalendarDateModelSelectType selectType;

@property (nonatomic, assign) BOOL shouldShow;

@property (nonatomic, assign) BOOL disabled;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) BOOL shouldShowLunarDate;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *dateString;

@property (nonatomic, copy) NSString *commonTitle;

@property (nonatomic, strong) UIColor *commonTitleColor;

@property (nonatomic, copy) NSString *specialTitle;

@property (nonatomic, copy) NSString *dayOfLunar;

@property (nonatomic, assign) NSInteger weekDay;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) eLongCalendarStatutoryHolidayModel *statutoryHolidayModel;

@end
