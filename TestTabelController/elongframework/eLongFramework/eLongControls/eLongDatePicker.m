//
//  eLongDatePicker.m
//  ElongClient
//
//  Created by yangfan on 15/1/12.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDatePicker.h"
#import "eLongDefine.h"
#import "UIImageView+Extension.h"
#import "eLongCalendarManager.h"
#import "NSDate+Helper.h"
#import "eLongExtension.h"

#define ELONG_COMMON_COLOR_4499FFHEXSTR @"0x4499ff"
#define ELONG_COMMON_COLOR_FF5555HEXSTR @"0xff5555"

#define kBirthDatePickerViewHeight 216

@interface eLongDatePicker ()
{
    
    eLongDatePickerType type;
    UIView *topView;
    UILabel *titleLabel;
}

@property (nonatomic, strong) UIView * datePickerBackgroundView;
@property (nonatomic, strong) UIView * markView;
@end

@implementation eLongDatePicker

@synthesize markView;

- (id)initWithTitle:(NSString *)title DateType:(eLongDatePickerType)dateType{
    if (self = [super init]) {
        _titleText = title;
        type =  dateType;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT, SCREEN_WIDTH, kBirthDatePickerViewHeight + NAVIGATION_BAR_HEIGHT)];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.datePickerBackgroundView = backgroundView;
        [self.view addSubview:_datePickerBackgroundView];
        
        topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 0.5f)]];
        [self loadTitleLable];
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
        topSplitView.image = [UIImage imageNamed:@"myelong_dashed"];
        [topView addSubview:topSplitView];
        
        // left button
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
        [leftBtn.titleLabel setFont:FONT_B16];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithHexStr:ELONG_COMMON_COLOR_4499FFHEXSTR] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithHexStr:ELONG_COMMON_COLOR_4499FFHEXSTR] forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(cancelBirthdayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:leftBtn];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
        [rightBtn.titleLabel setFont:FONT_B16];
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithHexStr:ELONG_COMMON_COLOR_4499FFHEXSTR] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithHexStr:ELONG_COMMON_COLOR_4499FFHEXSTR] forState:UIControlStateHighlighted];
        [rightBtn addTarget:self action:@selector(confirmBirthdayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:rightBtn];
        [_datePickerBackgroundView addSubview:topView];
        [self loadDatePicker];
    }
    return self;
}


- (void)setTitleText:(NSString *)titleText_{
    if (![_titleText isEqualToString:titleText_]) {
        _titleText = titleText_;
        [self loadTitleLable];
        [self loadDatePicker];
    }
}

- (void)loadDatePicker{
    if (!_datePicker && !_datePicker.superview) {
        _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0.0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 216.0)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePickerBackgroundView addSubview:_datePicker];
    }
    _datePicker.maximumDate = [NSDate date];
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setDay:0];
    // 如果是证件有效期，则默认日期为六个月之后的日期
    if (type == eLongDatePickerTypeCredentialsValidDate) {
        [comps setMonth:6];
    }
    _datePicker.date = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];

}

- (void)loadTitleLable{
    if (!titleLabel && !titleLabel.superview) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:FONT_B18];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
        [topView addSubview:titleLabel];
    }
    [titleLabel setText:_titleText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) cancelBirthdayBtnClick{
    [self dismissDatePicker];
}

-(void) confirmBirthdayBtnClick{
    NSDate * birthday = [_datePicker date];
    
//    if ([self checkDataValidWithDate:birthday]) {
//        
//        NSString * alertMsg = [self checkDataValidWithDate:birthday];
//        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        
//        return;
//    }
//    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:birthday];
    
    if ([_delegate respondsToSelector:@selector(passDate:withDate:)]) {
        [_delegate performSelector:@selector(passDate:withDate:) withObject:dateStr withObject:birthday];
    }
    [self dismissDatePicker];
}

//-(NSString *) checkDataValidWithDate:(NSDate *)date
//{
//    NSString * msg = nil;
//    // 如果是生日，判断是否是婴儿
//    if ([type integerValue] == 1) {
//        NSDate * standardDate = [[eLongCalendarManager shared] addYear:date addValue:2];
//        NSDate * departDate = [NSDate dateFromString:[[FlightSingleton sharedInstance] departDate] withFormat:@"yyyy-MM-dd"];
//        NSInteger compareResult = [[eLongCalendarManager shared] compareDate:departDate withCheckOutDate:standardDate];
//        
//        if (compareResult == -1) {
//            msg = @"年龄超出购票范围";
//        }
//    }
//    
//    return msg;
//    
//}
-(void) showDatePicker
{
    
    markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    markView.backgroundColor = RGBACOLOR(0, 0, 0, 1.0f);
    [[UIApplication sharedApplication].keyWindow addSubview:markView];
    markView.alpha = 0.5f;
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    singleTapGesture.delegate = self;
    [self.view addGestureRecognizer:singleTapGesture];
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }
    [self.view bringSubviewToFront:_datePickerBackgroundView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - 216 - NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, kBirthDatePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) dismissDatePicker{
    [UIView animateWithDuration:0.2 animations:^{
        self.datePickerBackgroundView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, SCREEN_WIDTH, kBirthDatePickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [self.view removeFromSuperview];
    }];
}

-(void) singleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self dismissDatePicker];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}
@end
