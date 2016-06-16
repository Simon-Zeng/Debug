//
//  eLongProcessSwitcher.m
//  eLongFramework
//
//  Created by zhaoyan on 15/7/13.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongProcessSwitcher.h"

#define OUT_TIME 1800                     // 超时时间30min

@implementation eLongProcessSwitcher

- (void)dealloc {
    self.getDate = nil;
}


+ (eLongProcessSwitcher *)shared {
    static dispatch_once_t once_t;
    static eLongProcessSwitcher *switcher = nil;
    dispatch_once(&once_t, ^{
        switcher = [[eLongProcessSwitcher alloc] init];
    });
    return switcher;
}


- (id)init {
    if (self = [super init]) {
        _allowNonmember          = YES;
        _allowAlipayForFlight    = NO;
        _allowAlipayForGroupon   = NO;
        _hotelPassOn             = NO;
        _grouponPassOn           = NO;
        _hotelHtml5On            = NO;
        _grouponHtml5On          = NO;
        _flightHtml5On           = NO;
        _allowIFlyMSC            = NO;
        _allowHttps              = NO;
        _isHttpsOnForiOSPCI      = YES;
        _tourPalOn               = NO;
        _showC2CInHotelSearch = NO;
        _showC2COrder = NO;
        _openNetMonitoring = NO;
        _registNewForIOS = YES;//默认使用新注册流程
        _hkHotelWifi = NO;
        
        // 紧急预案
        _urgentHotel = NO;
        _urgentGroupon = NO;
        _urgentFlight = NO;
        _urgentTrain = NO;
        _urgentApp = NO;
        _urgentMyElong = NO;
        
        // 公寓模块紧急处理开关 苏松添加 2015-5-15
        _isNewApartmentAvaliable    = NO;   // 新版入口默认不可用
        _isApartmentAvaliable       = YES;  // 旧版入口默认可用
        _isNAPriceSortAvailable     = YES;   // 新版从高到低价格排序默认关闭
        
        _IsCheckedCashDefaultForiOS  = YES;   //返现默认不勾选
        _IsCheckedDiscountCashDefaultForiOS = YES;  //五折返现默认勾选
        _isOpenIhotelFCode = NO;
        
        _isNewWithdraw = NO;                //是否为新的提现规则开关
        
        _isShowSupplierName = YES;
    }
    
    return self;
}

- (void)setAllowHttps:(BOOL)allowHttps {
    if (allowHttps != _allowHttps) {
        // 发送一则通知表示https开关策略有所变化
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_HTTPS_STATECHANGE" object:nil];
    }
    _allowHttps = allowHttps;
}


- (void)setIsHttpsOnForiOSPCI:(BOOL)isHttpsOnForiOSPCI {
    if (_isHttpsOnForiOSPCI != isHttpsOnForiOSPCI) {
        // 发送一则通知表示https开关策略有所变化
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTI_HTTPS_STATECHANGE" object:nil];
    }
    _isHttpsOnForiOSPCI = isHttpsOnForiOSPCI;
}


- (void)setAllowNonmember:(BOOL)animated {
    _allowNonmember = animated;
    
    self.getDate = [NSDate date];
}


- (BOOL)dataOutTime {
    if (!_getDate) {
        return YES;
    }
    
    return [[NSDate date] timeIntervalSinceDate:_getDate] > OUT_TIME;
}


@end
