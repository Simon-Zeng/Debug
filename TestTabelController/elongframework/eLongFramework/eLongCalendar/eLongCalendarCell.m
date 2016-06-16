//
//  eLongCalendarCell.m
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import "eLongCalendarCell.h"
#import "eLongCalendarDateModel.h"
#import "eLongCalendarDefine.h"
#import "UIView+LayoutMethods.h"
#import "UIColor+eLongExtension.h"

@interface eLongCalendarCell ()

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *selectedIV;

@property (nonatomic, strong) UIImageView *markPointIV;

@property (nonatomic, strong) UILabel *statutoryHolidayLabel;

@property (nonatomic, strong, readwrite) eLongCalendarDateModel *dateModel;

@end

@implementation eLongCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor whiteColor];
    /*圆形选中暂时注掉 未来有可能改回来
     double selectedIV_diameter = CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds) ? ceil(CGRectGetHeight(self.bounds)*0.74) : ceil(CGRectGetWidth(self.bounds)*0.74);
     double selectedIV_x = (CGRectGetWidth(self.bounds) - selectedIV_diameter) / 2;
     double selectedIV_y = (CGRectGetHeight(self.bounds) - selectedIV_diameter) / 2;
     CGRectMake(selectedIV_x, selectedIV_y, selectedIV_diameter, selectedIV_diameter)
     */
    int selectedIV_y = 4;
    int selectedIV_height = ceil(self.height-selectedIV_y*2.0);
    _selectedIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, selectedIV_y, self.width, selectedIV_height)];
    _selectedIV.backgroundColor = [UIColor clearColor];
    _selectedIV.clipsToBounds = NO;
    [self.contentView addSubview:_selectedIV];
    _selectedIV.hidden = YES;
    
    /*圆形选中暂时注掉 未来有可能改回来
     double markPointIV_diameter = ceil(CGRectGetHeight(self.bounds)*0.09);
     double markPointIV_x = (CGRectGetWidth(self.bounds) - markPointIV_diameter) / 2;
     double markPointIV_y = CGRectGetMaxY(_dateLabel.frame) + ceil(selectedIV_diameter * 0.2);
     CGRectMake(markPointIV_x, markPointIV_y, markPointIV_diameter, markPointIV_diameter)
     */
    _markPointIV = [[UIImageView alloc] initWithFrame:_selectedIV.frame];
    _markPointIV.backgroundColor = [UIColor colorWithRed:0.820 green:0.898 blue:1.000 alpha:1.000];
    _markPointIV.clipsToBounds = NO;
    [self.contentView addSubview:_markPointIV];
    _markPointIV.hidden = YES;
    
    /*圆形选中暂时注掉 未来有可能改回来
     double dateLabel_x = (CGRectGetWidth(self.bounds) - ceil(selectedIV_diameter*0.75)) / 2;
     double dateLabel_y = ceil(CGRectGetHeight(self.bounds)*0.26);
     CGRectMake(dateLabel_x, dateLabel_y, ceil(selectedIV_diameter*0.75), ceil(CGRectGetHeight(self.bounds)*0.272))
     */
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _selectedIV.y+9, self.width, 15)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.font = [UIFont systemFontOfSize:15.0];
    _dateLabel.adjustsFontSizeToFitWidth = YES;
    _dateLabel.textColor = ELC_CELL_DATE_COLOR;
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dateLabel];
    
    /*圆形选中暂时注掉 未来有可能改回来
     double tipLabel_x = (CGRectGetWidth(self.bounds) - ceil(selectedIV_diameter*0.7)) / 2;
     double tipLabel_y = CGRectGetMaxY(_dateLabel.frame) + ceil(selectedIV_diameter * 0.03);
     CGRectMake(tipLabel_x, tipLabel_y, ceil(selectedIV_diameter*0.7), ceil(selectedIV_diameter*0.281))
     */
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _dateLabel.bottom+5, self.width, 10)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.font = [UIFont systemFontOfSize:10.0];
    _tipLabel.adjustsFontSizeToFitWidth = YES;
    _tipLabel.textColor = ELC_CELL_TIP_COLOR;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_tipLabel];
    
    /*圆形选中暂时注掉 未来有可能改回来
     double statutoryHolidayLabel_diameter = CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds) ? ceil(CGRectGetHeight(self.bounds)*0.167) : ceil(CGRectGetWidth(self.bounds)*0.167);
     double statutoryHolidayLabel_x = CGRectGetWidth(self.bounds)- statutoryHolidayLabel_diameter;
     double statutoryHolidayLabel_y = ceil(CGRectGetHeight(self.bounds)*0.05);
     CGRectMake(statutoryHolidayLabel_x, statutoryHolidayLabel_y, statutoryHolidayLabel_diameter, statutoryHolidayLabel_diameter)
     */
    _statutoryHolidayLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-9, selectedIV_y, 9, 9)];
    _statutoryHolidayLabel.backgroundColor = [UIColor clearColor];
    _statutoryHolidayLabel.font = [UIFont systemFontOfSize:9.0];
    _statutoryHolidayLabel.adjustsFontSizeToFitWidth = YES;
    _statutoryHolidayLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
    _statutoryHolidayLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_statutoryHolidayLabel];
    _statutoryHolidayLabel.hidden = YES;
    
    //    [self addSubview:[self splitView]];
}

- (void)resetAllSubviews {
    self.dateLabel.textColor = ELC_CELL_DATE_COLOR;
    self.tipLabel.textColor = ELC_CELL_TIP_COLOR;
    self.selectedIV.hidden = YES;
    self.markPointIV.hidden = YES;
    self.statutoryHolidayLabel.hidden = YES;
    self.statutoryHolidayLabel.text = nil;
    self.statutoryHolidayLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
    self.dateLabel.hidden = NO;
    self.tipLabel.hidden = NO;
}

- (void)refreshContentViewWithDateModel:(eLongCalendarDateModel *)dateModel {
    [self resetAllSubviews];
    
    self.dateModel = dateModel;
    
    if (dateModel.shouldShow) {
        if (dateModel.disabled) {
            self.dateLabel.textColor = ELC_CELL_DISABLE_COLOR;
            self.tipLabel.textColor = ELC_CELL_DISABLE_COLOR;
            self.dateLabel.text = dateModel.dateString;
            self.tipLabel.text = dateModel.shouldShowLunarDate ? dateModel.dayOfLunar : nil;
        } else {
            self.dateLabel.text = dateModel.dateString;
            self.tipLabel.text = dateModel.shouldShowLunarDate ? dateModel.dayOfLunar : nil;
            if ([dateModel.specialTitle isKindOfClass:[NSString class]] && dateModel.specialTitle.length > 0) {
                self.tipLabel.text = dateModel.specialTitle;
            } else if ([dateModel.commonTitle isKindOfClass:[NSString class]] && dateModel.commonTitle.length > 0) {
                if (dateModel.commonTitleColor && [dateModel.commonTitleColor isKindOfClass:[UIColor class]]) {
                    self.tipLabel.textColor = dateModel.commonTitleColor;
                }
                self.tipLabel.text = dateModel.commonTitle;
            } else if (dateModel.shouldShowLunarDate) {
                self.tipLabel.text = dateModel.dayOfLunar;
            }
            
            if (dateModel.statutoryHolidayModel) {
                self.statutoryHolidayLabel.text = dateModel.statutoryHolidayModel.statusDes;
                if ([self.statutoryHolidayLabel.text isEqualToString:@"班"]) {
                    self.statutoryHolidayLabel.textColor = [UIColor colorWithHexStr:@"#333333"];
                }
                self.statutoryHolidayLabel.hidden = NO;
            }
            
            if (dateModel.selected) {
                switch (dateModel.selectType) {
                    case eLongCalendarDateModelSelectTypeNone: {
                        break;
                    }
                    case eLongCalendarDateModelSelectTypeStartDate: {
                        self.dateLabel.textColor = [UIColor whiteColor];
                        self.tipLabel.textColor = [UIColor colorWithRed:0.624 green:0.784 blue:1.000 alpha:1.000];
                        self.selectedIV.hidden = NO;
                        self.selectedIV.image = [UIImage imageNamed:@"calendar_multiple_choice_left_bg"];
                        if (dateModel.statutoryHolidayModel) {
                            self.statutoryHolidayLabel.textColor = [UIColor whiteColor];
                        }
                        break;
                    }
                    case eLongCalendarDateModelSelectTypeMarkPoint: {
                        self.dateLabel.textColor = ELC_CELL_BLUE_COLOR;
                        self.markPointIV.hidden = NO;
                        self.tipLabel.hidden = YES;
                        if (dateModel.statutoryHolidayModel) {
                            self.statutoryHolidayLabel.textColor = ELC_CELL_BLUE_COLOR;
                        }
                        break;
                    }
                    case eLongCalendarDateModelSelectTypeEndDate: {
                        self.dateLabel.textColor = [UIColor whiteColor];
                        self.tipLabel.textColor = [UIColor colorWithRed:0.624 green:0.784 blue:1.000 alpha:1.000];
                        self.selectedIV.hidden = NO;
                        self.selectedIV.image = [UIImage imageNamed:@"calendar_multiple_choice_right_bg"];
                        if (dateModel.statutoryHolidayModel) {
                            self.statutoryHolidayLabel.textColor = [UIColor whiteColor];
                        }
                        break;
                    }
                    case eLongCalendarDateModelSelectTypeOnlyOneDate: {
                        self.dateLabel.textColor = [UIColor whiteColor];
                        self.selectedIV.image = [UIImage imageNamed:@"calendar_one_choice_bg"];
                        self.selectedIV.hidden = NO;
                        if (dateModel.statutoryHolidayModel) {
                            self.statutoryHolidayLabel.textColor = [UIColor whiteColor];
                        }
                        break;
                    }
                    default: {
                        break;
                    }
                }
            }
            if ([dateModel.dateString isEqualToString:@"今天"] && !dateModel.selected) {
                self.dateLabel.textColor = ELC_CELL_BLUE_COLOR;
            }
            /*红色标红周末 暂时注掉
             if ([dateModel.dateString isEqualToString:@"今天"] && !dateModel.selected) {
             self.dateLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
             } else if (dateModel.weekDay == 1 || dateModel.weekDay == 7) {
             if (!dateModel.selected) {
             if (dateModel.statutoryHolidayModel.status == 2) {
             self.dateLabel.textColor = ELC_CELL_DATE_COLOR;
             self.statutoryHolidayLabel.textColor = ELC_CELL_TIP_COLOR;
             } else {
             self.dateLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
             self.statutoryHolidayLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
             }
             }
             }
             */
        }
    }
    self.contentView.hidden = !dateModel.shouldShow;
}

@end
