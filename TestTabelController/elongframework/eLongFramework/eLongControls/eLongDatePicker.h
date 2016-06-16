//
//  eLongDatePicker.h
//  ElongClient
//
//  Created by yangfan on 15/1/12.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, eLongDatePickerType) {
    eLongDatePickerTypeBirthday,//生日(支付，个人中心)
    eLongDatePickerTypeCredentialsValidDate,//证件有效期（个人中心旅客信息专用）
};


@protocol eLongDatePickerDelegate;

@interface eLongDatePicker: UIViewController
<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIDatePicker * datePicker;

@property (nonatomic, copy) NSString * titleText;

@property (nonatomic, assign) id <eLongDatePickerDelegate> delegate;

/**
 *  初始化一个带类型的选择器
 *
 *  @param title    pickerTitle
 *  @param dateType 选择器类型
 */
- (id)initWithTitle:(NSString *)title DateType:(eLongDatePickerType)dateType;

- (void)showDatePicker;							// 展示
@end


@protocol eLongDatePickerDelegate<NSObject>
-(void) passDate:(NSString *)dateStr withDate:(NSDate *) date;
@end
