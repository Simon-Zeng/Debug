//
//  eLongVerificationCodeTimer.m
//  eLongFramework
//
//  Created by lvyue on 15/6/19.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongVerificationCodeTimer.h"

#define REGISTERTIMESPAN 60 //注册验证码时间限制
#define FORGETPWDTIMESPAN 60 //忘记密码验证码时间限制
#define DYNAMICLOGINTIMESPAN 60 //动态登录验证码时间限制
#define REGISTPAYERTIMESPAN     120   //修改支付密码倒计时限制

@implementation eLongVerificationCodeTimer{
    NSTimer *timerRegister;//注册流程中时间控制
    NSTimer *timerForgetPwd;//忘记密码流程中时间控制
    NSTimer *timerDynamicLogin;//动态密码登录流程中时间控制
    NSTimer *timerInModifyCashAccountPassword;//修改支付密码时间控制
}

DEF_SINGLETON(eLongVerificationCodeTimer)

-(id) init{
    if (self = [super init]) {
        _remainSecondsRegister = REGISTERTIMESPAN;
        _remainSecondsForgetPwd = FORGETPWDTIMESPAN;
        _remainSecondsDynamicLogin = DYNAMICLOGINTIMESPAN;
        _remainModifyCashPasswordSeconds = REGISTPAYERTIMESPAN;
    }
    return self;
}

#pragma mark
#pragma mark ------RegisterProcessTimeControl

-(void)fireTheTimerAndCountWithLeftSecondsForRegister:(int)seconds{
    _remainSecondsRegister = seconds;
    if (_remainSecondsRegister > 0 && _remainSecondsRegister < REGISTERTIMESPAN) {
        timerRegister = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTheLeftCountsForRegister) userInfo:nil repeats:YES];
    }else{
        _remainSecondsRegister = REGISTERTIMESPAN;
    }
}

-(void)fireTheTimerAndCountWithLeftSecondsForDynamicLogin:(int)seconds{
    _remainSecondsDynamicLogin = seconds;
    if (_remainSecondsDynamicLogin > 0 && _remainSecondsDynamicLogin < DYNAMICLOGINTIMESPAN) {
        timerDynamicLogin = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTheLeftCountsForDynamicLogin) userInfo:nil repeats:YES];
    }else{
        _remainSecondsDynamicLogin = DYNAMICLOGINTIMESPAN;
    }
}

-(void)fireTheTimerAndCountWithLeftSecondsForForgetPwd:(int)seconds{
    _remainSecondsForgetPwd = seconds;
    if (_remainSecondsForgetPwd > 0 && _remainSecondsForgetPwd < FORGETPWDTIMESPAN) {
        timerForgetPwd = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTheLeftCountsForForgetPwd) userInfo:nil repeats:YES];
    }else{
        _remainSecondsForgetPwd = FORGETPWDTIMESPAN;
    }
}

-(void)fireTheTimerAndCountWithLeftSecondsInModifyCashAccountPassword:(int)seconds{
    
    _remainModifyCashPasswordSeconds = seconds;
    if (_remainModifyCashPasswordSeconds > 0 && _remainModifyCashPasswordSeconds < REGISTPAYERTIMESPAN) {
        timerInModifyCashAccountPassword = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTheLeftCountsInModifyCashAccountPassword) userInfo:nil repeats:YES];
    }else{
        _remainModifyCashPasswordSeconds = REGISTPAYERTIMESPAN;
    }
    
}


-(void)updateTheLeftCountsForRegister{
    if (_remainSecondsRegister <= 0) {
        [self destoryTimerForRegister];
        _remainSecondsRegister = REGISTERTIMESPAN;
    }else{
        _remainSecondsRegister -= 1;
    }
}

-(void)updateTheLeftCountsForDynamicLogin{
    if (_remainSecondsDynamicLogin <= 0) {
        [self destoryTimerForDynamicLogin];
        _remainSecondsDynamicLogin = DYNAMICLOGINTIMESPAN;
    }else{
        _remainSecondsDynamicLogin -= 1;
    }
}

-(void)updateTheLeftCountsForForgetPwd{
    if (_remainSecondsForgetPwd <= 0) {
        [self destoryTimerForForgetPwd];
        _remainSecondsForgetPwd = FORGETPWDTIMESPAN;
    }else{
        _remainSecondsForgetPwd -= 1;
    }
}

-(void)updateTheLeftCountsInModifyCashAccountPassword{
    if (_remainModifyCashPasswordSeconds <= 0) {
        [self destoryTimerInModifyCashAccountPassword];
        _remainModifyCashPasswordSeconds = REGISTPAYERTIMESPAN;
    }else{
        _remainModifyCashPasswordSeconds -= 1;
    }
}


-(void)destoryTimerForRegister{
    [timerRegister invalidate];
    timerRegister =  nil;
}

-(void)destoryTimerForDynamicLogin{
    [timerDynamicLogin invalidate];
    timerDynamicLogin = nil;
}

-(void)destoryTimerForForgetPwd{
    [timerForgetPwd invalidate];
    timerForgetPwd  =  nil;
}

-(void)destoryTimerInModifyCashAccountPassword{
    [timerInModifyCashAccountPassword invalidate];
    timerInModifyCashAccountPassword  =  nil;
}

@end
