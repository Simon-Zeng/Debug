//
//  eLongCalendarDefine.h
//  eLongCalendar
//
//  Created by top on 14/12/17.
//  Copyright (c) 2014年 top. All rights reserved.
//

#ifndef eLongCalendar_eLongCalendarDefine_h
#define eLongCalendar_eLongCalendarDefine_h

#define ELC_WeekTitleHeight 18  //周高度
#define ELC_DayLineHeight 54   //日期高度
#define ELC_MonthLineHeight 54   //月栏高度
#define ELC_MonthCount 6    //显示几个月的日历

#define ELC_SCREEN_WIDTH			([[UIScreen mainScreen] bounds].size.width)
#define ELC_SCREEN_HEIGHT			([[UIScreen mainScreen] bounds].size.height)
#define ELC_CALENDAR_HEIGHT	(ELC_SCREEN_HEIGHT - 20 - 44)
#define ELC_SCREEN_SCALE  (1.0f/[UIScreen mainScreen].scale)

#define ELC_CELL_DATE_COLOR [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1]
#define ELC_CELL_TIP_COLOR [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1]
#define ELC_CELL_DISABLE_COLOR [UIColor colorWithRed:196/255.0 green:196/255.0 blue:196/255.0 alpha:1]
#define ELC_CELL_SELECT_BACKCOLOR [UIColor colorWithRed:251/255.0 green:60/255.0 blue:67/255.0 alpha:1]

#define ELC_CELL_BLUE_COLOR [UIColor colorWithRed:0.208 green:0.510 blue:1.000 alpha:1.000]

#endif

typedef NS_ENUM(NSInteger, eLongCalendarViewStyle) {
    eLongCalendarViewStyleNone,    //不可选日历
    eLongCalendarViewStylePeriod,  //选择两个时间点 如：入住，离店
    eLongCalendarViewStyleOneDate   //选择一个时间点 如：出发
};
