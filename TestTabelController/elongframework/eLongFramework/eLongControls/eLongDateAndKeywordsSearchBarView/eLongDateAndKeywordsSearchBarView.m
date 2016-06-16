//
//  eLongDateAndKeywordsSearchBarView.m
//  eLongHotel
//
//  Created by top on 16/2/25.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongDateAndKeywordsSearchBarView.h"
#import "UIView+LayoutMethods.h"
#import "eLongDefine.h"

@interface eLongDateAndKeywordsSearchBarView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *dateContainer;

@property (nonatomic, strong) UITextField *checkinTF;

@property (nonatomic, strong) UITextField *checkoutTF;

@property (nonatomic, strong) UITextField *keywordsTF;

@end

@implementation eLongDateAndKeywordsSearchBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    self.height = 30;
    self.backgroundColor = [UIColor colorWithRed:0.941 green:0.945 blue:0.953 alpha:1.000];
    self.layer.cornerRadius = 4.f;
    UIColor *dateLabelTextColor = [UIColor colorWithRed:0.349 green:0.565 blue:0.980 alpha:1.000];
    _dateContainer = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 55, self.height)];
    _dateContainer.backgroundColor = [UIColor clearColor];
    int dateIV_length = 14;
    UIImageView *dateIV = [[UIImageView alloc] initWithFrame:
                           CGRectMake(0,
                                      ceil((self.height-dateIV_length)/2),
                                      dateIV_length,
                                      dateIV_length)];
    dateIV.backgroundColor = [UIColor clearColor];
    dateIV.image = [UIImage imageNamed:@"elong_date_and_keywords_date"];
    [_dateContainer addSubview:dateIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onDateContainer)];
    [_dateContainer addGestureRecognizer:tap];
    int dateTF_Height = 10;
    int dateTF_Interval = ceil(self.height*0.089);
    int checkinTF_y = ceil((self.height-dateTF_Height*2-dateTF_Interval)/2.0);
    UIFont *dateTextFont = [UIFont systemFontOfSize:10.0];
    _checkinTF = [[UITextField alloc] initWithFrame:CGRectMake(dateIV.right+8, checkinTF_y, 32, dateTF_Height)];
    _checkinTF.backgroundColor = [UIColor clearColor];
    _checkinTF.textColor = dateLabelTextColor;
    _checkinTF.font = dateTextFont;
    _checkinTF.placeholder = @"入住日期";
    _checkinTF.userInteractionEnabled = NO;
    [_dateContainer addSubview:_checkinTF];
    _checkoutTF = [[UITextField alloc] initWithFrame:
                   CGRectMake(_checkinTF.x,
                              _checkinTF.bottom+dateTF_Interval,
                              _checkinTF.width, _checkinTF.height)];
    _checkoutTF.backgroundColor = [UIColor clearColor];
    _checkoutTF.textColor = dateLabelTextColor;
    _checkoutTF.font = dateTextFont;
    _checkoutTF.placeholder = @"离店日期";
    _checkoutTF.userInteractionEnabled = NO;
    [_dateContainer addSubview:_checkoutTF];
    [self addSubview:_dateContainer];
    int keywordsTF_x = _dateContainer.right+22;
    int keywordsTF_width = ceil(self.width-keywordsTF_x-20);
    int searchIV_length = 14;
    UIImageView *searchIV = [[UIImageView alloc] initWithFrame:
                             CGRectMake(_dateContainer.right+15,
                                        ceil((self.height-searchIV_length)/2),
                                        searchIV_length,
                                        searchIV_length)];
    searchIV.backgroundColor = [UIColor clearColor];
    searchIV.image = [UIImage imageNamed:@"elong_date_and_keywords_search"];
    [self addSubview:searchIV];
    _keywordsTF = [[UITextField alloc] initWithFrame:CGRectMake(searchIV.right+5, 0, keywordsTF_width, self.height)];
    _keywordsTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _keywordsTF.backgroundColor = [UIColor clearColor];
    _keywordsTF.borderStyle = UITextBorderStyleNone;
    _keywordsTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _keywordsTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    _keywordsTF.textColor = [UIColor colorWithHexStr:@"#555555"];
    _keywordsTF.font = FONT_12;
    _keywordsTF.placeholder = @"暂无搜索内容";
    _keywordsTF.delegate = self;
    _keywordsTF.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_keywordsTF];
    
    //清除按钮
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.frame = CGRectMake(self.frame.size.width-8-15, self.frame.size.height*0.5f-15*0.5f, 15, 15);
    [_clearBtn setImage:[UIImage imageNamed:@"elong_date_and_keywords_clear"] forState:UIControlStateNormal];
    [_clearBtn setBackgroundColor:[UIColor clearColor]];
    _clearBtn.contentMode = UIViewContentModeCenter;
    _clearBtn.hidden = YES;
    [_clearBtn addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clearBtn];
}

#pragma mark --清除按钮点击事件--
- (void)clearText:(id)sender {
    _clearBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(clearKeywords)]) {
        [self.delegate clearKeywords];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(changeKeywords)]) {
        [self.delegate changeKeywords];
    }
    return NO;
}

#pragma mark - 
- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    _keywordsTF.placeholder = _placeholderText;
}

- (void)setKeywordsText:(NSString *)keywordsText {
    _keywordsText = keywordsText;
    _keywordsTF.text = _keywordsText;
}

- (void)setCheckinDate:(NSDate *)checkinDate {
    _checkinDate = checkinDate;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [format setDateFormat:@"MM-dd"];
    _checkinTF.text = [format stringFromDate:_checkinDate];
}

- (void)setCheckoutDate:(NSDate *)checkoutDate {
    _checkoutDate = checkoutDate;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [format setDateFormat:@"MM-dd"];
    _checkoutTF.text = [format stringFromDate:_checkoutDate];
}

#pragma mark - 
- (void)onDateContainer {
    if ([self.delegate respondsToSelector:@selector(changeDate)]) {
        [self.delegate changeDate];
    }
}

@end
