//
//  eLongCalendarDateButton.m
//  eLongCalendar
//
//  Created by top on 14/12/19.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "eLongCalendarDateButton.h"
#import "eLongCalendarManager.h"
#import "eLongDefine.h"

@interface eLongCalendarDateButton()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *backgroundView;
@end

@implementation eLongCalendarDateButton
@synthesize date;
@synthesize txt;
@synthesize trueHoliday;
@synthesize isMidNight;
@synthesize couldNotSelectByCheckIn;
@synthesize isGreenDay;

-(UIImageView *)imageView{
    if (_imgView == nil) {
        _imgView=[[UIImageView alloc] init];
        _imgView.image=[UIImage imageNamed:@"calendar_pressed"];
        _imgView.hidden = YES;
    }
    
    return _imgView;
}

-(UIImageView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.image = [UIImage imageNamed:@"calendar_middle_pressed"];
        _backgroundView.hidden = YES;
    }
    return _backgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
        [self setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font=[UIFont systemFontOfSize:16];
        self.adjustsImageWhenDisabled=NO;
        self.adjustsImageWhenHighlighted=NO;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.imageView];
        
        holidayLbl=[[UILabel alloc] init];
        holidayLbl.backgroundColor=[UIColor clearColor];
        holidayLbl.textColor=[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
        holidayLbl.textAlignment=NSTextAlignmentCenter;
        holidayLbl.font=[UIFont systemFontOfSize:12];
        [self addSubview:holidayLbl];
        curState=eLongCalendarDateButtonStateNone;
    }
    return self;
}

- (void)setHoliday:(NSString *)holidayString
{
    holidayLbl.text=holidayString;
}

- (eLongCalendarDateButtonState) getCheckState
{
    return curState;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    holidayLbl.frame=CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40);
}

- (void)setDateAndTitle:(NSDate *)aDate
{
    eLongCalendarManager *helper = [eLongCalendarManager shared];
    self.date = aDate;
    NSInteger day = [helper day:aDate];
    [self setTitle:[NSString stringWithFormat:@"%ld",(long)day] forState:UIControlStateNormal];
    self.txt = [NSString stringWithFormat:@"%ld",(long)day];
}

- (void)setPremisDateAndTitle:(NSDate *)aDate{
    eLongCalendarManager *helper = [eLongCalendarManager shared];
    self.date=aDate;
    NSInteger day =[helper day:aDate];
    [self setTitle:[NSString stringWithFormat:@"%ld",(long)day] forState:UIControlStateNormal];
    self.txt=[NSString stringWithFormat:@"%ld",(long)day];
    
    self.imageView.frame = CGRectMake(4+(SCREEN_WIDTH-320)/14, 4, 38, 38);
    self.imageView.hidden = NO;
}

- (void)setCheckState:(eLongCalendarDateButtonState)state
{
    if (state==curState)
    {
        return;
    }
    
    if(state==eLongCalendarDateButtonStateNone)
    {
        [self setNormalStateUI];
    }
    else if (state==eLongCalendarDateButtonStateCheckIn)
    {
        [self setCheckStateUI:state];
    }
    else if (state==eLongCalendarDateButtonStateCheckOut)
    {
        [self setCheckStateUI:state];
    }
    else if (state==eLongCalendarDateButtonStateCommonCheck)
    {
        [self setCheckStateUI:state];
    }
    
    curState=state;
}

- (void)setNormalStateUI
{
    if(upLbl)
    {
        [upLbl removeFromSuperview];
        upLbl=nil;
    }
    
    if(downLbl)
    {
        [downLbl removeFromSuperview];
        downLbl=nil;
    }
    
    self.imageView.hidden = YES;
    self.backgroundView.hidden = YES;
    
    holidayLbl.hidden=NO;
    [self setTitle:self.txt forState:UIControlStateNormal];
}

-(void)setCommonCheckImage{
    self.backgroundView.hidden = NO;
}

- (void)setHiddenCommonCheckImage{
    self.backgroundView.hidden = YES;
}


//入住离店状态UI
- (void)setCheckStateUI:(eLongCalendarDateButtonState)state
{
    self.imageView.hidden = YES;
    self.backgroundView.hidden = YES;
    
    CGFloat width = 54;//MAX(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    CGFloat x = 4 + (CGRectGetWidth(self.frame) - width)/2;
    if (CGRectGetHeight(self.frame)-CGRectGetWidth(self.frame)>5) {
        x = 0;
    }
    if (state == eLongCalendarDateButtonStateCommonCheck){
        //        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-8)];
        //        imgView.image = [UIImage imageNamed:@"calendar_middle_pressed"];
        //        [self addSubview:imgView];
        self.backgroundView.frame = CGRectMake(x, 4, SCREEN_WIDTH/7, CGRectGetHeight(self.frame)-8);
        self.backgroundView.hidden = NO;
    }
    
    /*
     UIImage *image = [UIImage imageNamed:@"calender_middle_pressed"];
     CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
     frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
     [image drawInRect:frame];*/
    
    if (state == eLongCalendarDateButtonStateCheckIn)
    {
        //        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 4, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-8)];
        //        backgroundView.image = [UIImage imageNamed:@"calendar_middle_pressed"];
        //        [self addSubview:backgroundView];
        //        backgroundView.hidden = YES;
        //
        //        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.frame)-8, CGRectGetHeight(self.frame)-8)];
        //        imgView.image = [UIImage imageNamed:@"calendar_pressed"];
        //        [self addSubview:imgView];
        
        self.backgroundView.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 +(x-4), 4, width, CGRectGetHeight(self.frame)-8);
        self.imageView.frame = CGRectMake(x, 4, width-8, CGRectGetHeight(self.frame)-8);
        self.imageView.hidden = NO;
    }
    
    if (state == eLongCalendarDateButtonStateCheckOut)
    {
        //        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-8)];
        //        backgroundView.image = [UIImage imageNamed:@"calendar_middle_pressed"];
        //        [self addSubview:backgroundView];
        //
        //        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(self.frame)-8, CGRectGetHeight(self.frame)-8)];
        //        imgView.image = [UIImage imageNamed:@"calendar_pressed"];
        //        [self addSubview:imgView];
        
        self.backgroundView.frame = CGRectMake(x, 4, width/2, CGRectGetHeight(self.frame)-8);
        self.backgroundView.hidden = NO;
        self.imageView.frame = CGRectMake(x, 4, width-8, CGRectGetHeight(self.frame)-8);
        self.imageView.hidden = NO;
    }
    
    
    if(upLbl)
    {
        [upLbl removeFromSuperview];
        upLbl=nil;
    }
    
    if(downLbl)
    {
        [downLbl removeFromSuperview];
        downLbl=nil;
    }
    
    
    upLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height-12)];
    upLbl.text=self.txt;
    //upLbl.font=[UIFont boldSystemFontOfSize:14];
    upLbl.textAlignment=NSTextAlignmentCenter;
    if (state == eLongCalendarDateButtonStateCheckIn ||
        state == eLongCalendarDateButtonStateCheckOut) {
        upLbl.textColor=[UIColor whiteColor];
    }
    upLbl.backgroundColor=[UIColor clearColor];
    [self addSubview:upLbl];
    
    //普通选中下边不管
    if(state==eLongCalendarDateButtonStateCommonCheck)
    {
        [self setTitle:@"" forState:UIControlStateNormal];
        return;
    }
    
    downLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-40)];
    downLbl.backgroundColor=[UIColor clearColor];
    downLbl.textColor= [UIColor whiteColor];// [UIColor colorWithRed:29/255.0 green:94/255.0 blue:226/255.0 alpha:1];
    downLbl.textAlignment=NSTextAlignmentCenter;
    downLbl.font=[UIFont systemFontOfSize:12];
    [self addSubview:downLbl];
    
    holidayLbl.hidden=YES;
    [self setTitle:@"" forState:UIControlStateNormal];
}

- (void)setDateButtonTitle:(NSString *)title{
    if (!title) {
        holidayLbl.hidden = NO;
        downLbl.hidden = YES;
    }else{
        holidayLbl.hidden = YES;
        downLbl.hidden = NO;
        downLbl.text = title;
    }
}
//不可用时的button的UI
- (void)setBtnEnabled:(BOOL)ennable
{
    self.enabled=ennable;
    
    if(ennable)
    {
        if (self.isGreenDay)
        {
            //[self setTitleColor:[UIColor colorWithRed:20/255.0 green:157/255.0 blue:52/255.0 alpha:1] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
        else
        {
            [self setTitleColor:[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        }
        
        holidayLbl.textColor=[UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1];
    }
    
    else
    {
        [self setTitleColor:[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1] forState:UIControlStateNormal];
        
        holidayLbl.textColor=[UIColor colorWithRed:174/255.0 green:174/255.0 blue:174/255.0 alpha:1];
    }
}

@end
