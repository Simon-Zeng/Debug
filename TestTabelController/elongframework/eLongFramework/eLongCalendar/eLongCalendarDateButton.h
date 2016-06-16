//
//  eLongCalendarDateButton.h
//  eLongCalendar
//
//  Created by top on 14/12/19.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮状态
typedef NS_ENUM(NSInteger, eLongCalendarDateButtonState) {
    eLongCalendarDateButtonStateNone,       //正常状态
    eLongCalendarDateButtonStateCheckIn,    //入住
    eLongCalendarDateButtonStateCheckOut,   //离店
    eLongCalendarDateButtonStateCommonCheck, //普通选中，入住和离店之间
};

@interface eLongCalendarDateButton : UIButton
{
    UILabel *holidayLbl;
    UILabel *upLbl;
    UILabel *downLbl;
    eLongCalendarDateButtonState curState;

}
@property (nonatomic, retain) NSDate *date;  //日期
@property (nonatomic, retain) NSString *txt; //实际日期
@property (nonatomic, retain) NSString *trueHoliday; //实际日期
@property (nonatomic, assign) BOOL isMidNight; //是否是午夜
@property (nonatomic) BOOL couldNotSelectByCheckIn; //不能被checkin选中
@property (nonatomic) BOOL isGreenDay; //是公休日（周末和十一，五一之类）

//设置日期和title
- (void)setDateAndTitle:(NSDate *)aDate;
//选中状态
- (void)setCheckState:(eLongCalendarDateButtonState)state;
//设置是否可用 YES:可用 NO:不可用
- (void)setBtnEnabled:(BOOL)ennable;
//设置节假日
- (void)setHoliday:(NSString *)holidayString;
//得到状态
- (eLongCalendarDateButtonState)getCheckState;
//设置选中标记
- (void)setDateButtonTitle:(NSString *)title;
- (void)setPremisDateAndTitle:(NSDate *)aDate;
- (void)setCommonCheckImage;
- (void)setHiddenCommonCheckImage;
@end
