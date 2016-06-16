//
//  eLongCalendarView.h
//  eLongCalendar
//
//  Created by top on 14/12/17.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongCalendarDefine.h"
#import "eLongCalendarSpecialTitleModel.h"

@protocol eLongCalendarViewDataSource;
@protocol eLongCalendarViewDelegate;

typedef void(^ReloadDataCompletionBlock)();

@interface eLongCalendarView : UIView

@property (nonatomic, weak) id<eLongCalendarViewDataSource> dataSource;

@property (nonatomic, weak) id<eLongCalendarViewDelegate> delegate;

@property (nonatomic, copy, readonly) NSString *currentYear;  //当前年份

@property (nonatomic, copy, readonly) NSString *currentMonth; //当前月份

@property (nonatomic, assign) NSInteger maximumLimitNumberOfDays; //最大可选天数

@property (nonatomic, copy) NSString *tipOfLimitOfDays;  //超出最大可选天数的提示语

@property (nonatomic, assign) BOOL showLunarCalendar;  //是否展示阴历日期

/**
 *  指定初始化方法
 *
 *  @param frame 尺寸
 *  @param style 日历类型
 *
 *  @return eLongCalendarView
 */
- (id)initWithFrame:(CGRect)frame style:(eLongCalendarViewStyle)style;
/**
 *  开始加载日历数据
 *
 *  @param block 数据加载完毕回调
 */
- (void)reloadDataWithCompletionBlock:(ReloadDataCompletionBlock)block;
/**
 *  刷新特殊提示：如价格
 */
- (void)refreshSpecialTitle;
/**
 *  重置离店日期
 */
- (void)resetCheckoutDate;

@end

@protocol eLongCalendarViewDataSource<NSObject>

@optional
/**
 *  设置显示的月数
 *
 *  @param calendarView 日历视图
 *
 *  @return 要显示的月数
 */
- (NSInteger)numberOfMonthsInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置入住的日期
 *
 *  @param calendarView 日历视图
 *
 *  @return 入住的日期
 */
- (NSDate *)checkinDateInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置离开的日期
 *
 *  @param calendarView 日历视图
 *
 *  @return 离开的日期
 */
- (NSDate *)checkoutDateInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置入住选中之后的提示语
 *
 *  @param calendarView 日历视图
 *
 *  @return 入住选中之后的提示语
 */
- (NSString *)checkinDateTitleCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置离开选中之后的提示语
 *
 *  @param calendarView 日历视图
 *
 *  @return 离开选中之后的提示语
 */
- (NSString *)checkoutDateTitleCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置某日期之前为不可选
 *
 *  @param calendarView 日历视图
 *
 *  @return 某日期
 */
- (NSDate *)disabledToSelectBeforeDateInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置某日期之后为不可选
 *
 *  @param calendarView 日历视图
 *
 *  @return 某日期
 */
- (NSDate *)disabledToSelectAfterDateInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  设置一些日期的特殊提示（如低价日历）
 *
 *  @param calendarView 日历视图
 *
 *  @return 日期和特殊提示语组成的数组
 
 code :
 eLongCalendarSpecialTitleModel *model = [[eLongCalendarSpecialTitleModel alloc] init];
 model.date = [NSDate date];
 model.title = @"￥12";
 model.titleColor = [UIColor redColor];
 NSArray *array = @[ model ];
 return array;
 */
- (NSArray *)changeSomeDateTitleInCalendarView:(eLongCalendarView *)calendarView;

/**
 *  时间段最大限制天数
 *
 *  @return 天数
 */
- (NSInteger)daysOfPeriodLimit;

/**
 *  选择时间段超过天数限制提示信息
 *
 *  @return 提示信息
 */
- (NSString *)messageOfPeriodLimit;

/**
 *  时间段气泡提示中的天数文案,只1个字
 *
 *  @return 夜/天
 */
- (NSString *)titleForBubbble;

@end

@protocol eLongCalendarViewDelegate<NSObject>

@optional
/**
 *  将要选择的某日期
 *
 *  @param calendarView 日历视图
 *  @param date         日期
 *
 *  @return 是否可选
 */
- (BOOL)calendarView:(eLongCalendarView *)calendarView shouldSelectOneDate:(NSDate *)date;

/**
 *  已选择的某日期
 *
 *  @param calendarView 日历视图
 *  @param date         日期
 */
- (void)calendarView:(eLongCalendarView *)calendarView didSelectOneDate:(NSDate *)date;

/**
 *  已取消选择的某日期
 *
 *  @param calendarView 日历视图
 *  @param date         日期
 */
- (void)calendarView:(eLongCalendarView *)calendarView didDeselectOneDate:(NSDate *)date;

/**
 *  已选择的某日期段 对应eLongCalendarViewStylePeriod类型
 *
 *  @param calendarView 日历视图
 *  @param date         日期段
 log : period {
 checkinDate = "2015-01-07 07:00:00 +0000";
 checkoutDate = "2015-01-14 07:00:00 +0000";
 selectDays = 7;
 }
 */
- (void)calendarView:(eLongCalendarView *)calendarView didSelectPeriod:(NSDictionary *)period;
/**
 *  点击了选择时间段超过天数限制提示信息弹框的“确定”
 *
 *  @param calendarView 日历视图
 */
- (void)calendarViewConfirmPeriodLimit:(eLongCalendarView *)calendarView;
/**
 *  选中入住日期 对应eLongCalendarViewStylePeriod类型
 *
 *  @param calendarView 日历视图
 *  @param date         入住日期
 */
- (void)calendarView:(eLongCalendarView *)calendarView didSelectCheckinDateInPeriod:(NSDate *)date;
/**
 *  取消选中离店日期 对应eLongCalendarViewStylePeriod类型
 *
 *  @param calendarView 日历视图
 *  @param date         离店日期
 */
- (void)calendarView:(eLongCalendarView *)calendarView didSelectCheckoutDateInPeriod:(NSDate *)date;
/**
 *  选中离店日期 对应eLongCalendarViewStylePeriod类型
 *
 *  @param calendarView 日历视图
 *  @param date         离店日期
 */
- (void)calendarView:(eLongCalendarView *)calendarView didDeselectCheckinDateInPeriod:(NSDate *)date;

@end
