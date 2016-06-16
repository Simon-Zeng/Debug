//
//  eLongProcessSwitcher.h
//  eLongFramework
//
//  Created by zhaoyan on 15/7/13.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

// 首页
#define URGENT_APP_URL      @"https://msecure.elong.com/login/appembedded/urgenti?redirecturl=http%3A%2F%2Fm.elong.com%2F%3Fref%3Durgenti"
// 酒店
#define URGENT_HOTEL_URL    @"https://msecure.elong.com/login/appembedded/urgenti?redirecturl=http%3A%2F%2Fm.elong.com%2Fhotel%2F%3Fref%3Durgenti"
// 机票
#define URGENT_FLIGHT_URL   @"https://msecure.elong.com/login/appembedded/urgenti?redirecturl=http%3A%2F%2Fm.elong.com%2Fflight%2F%3Fref%3Durgenti"
// 火车票
#define URGENT_TRAIN_URL    @"https://msecure.elong.com/login/appembedded/urgenti?redirecturl=http%3A%2F%2Fm.elong.com%2Fhuoche%2F%3Fref%3Durgenti"
// 团购
#define URGENT_GROUPON_URL  @"https://msecure.elong.com/login/appembedded/urgenti?redirecturl=http%3A%2F%2Fm.elong.com%2Ftuan%2F%3Fref%3Durgenti"

@interface eLongProcessSwitcher : NSObject

@property (nonatomic) BOOL allowNonmember;				// 是否开放非用户流程
@property (nonatomic) BOOL allowAlipayForFlight;		// 是否允许机票支付宝支付
@property (nonatomic) BOOL allowAlipayForGroupon;		// 是否允许团购支付宝支付
@property (nonatomic) BOOL hotelPassOn;                 // 酒店passbook功能开关
@property (nonatomic) BOOL grouponPassOn;               // 团购passbook功能开关
@property (nonatomic) BOOL hotelHtml5On;                // 酒店h5开关
@property (nonatomic) BOOL grouponHtml5On;              // 团购h5开关
@property (nonatomic) BOOL flightHtml5On;               // 机票h5开关
@property (nonatomic, readonly) BOOL dataOutTime;       // 数据是否过期
@property (nonatomic, retain) NSDate *getDate;          // 获取数据的时间
@property (nonatomic) BOOL allowIFlyMSC;                // 是否启用语音搜索
@property (nonatomic) BOOL allowHttps;                  // 是否启用HTTPS加密，default＝NO
@property (nonatomic) BOOL isHttpsOnForiOSPCI;          // 是否启用PCI需求的Https加密（信用卡相关接口），default＝YES

@property (nonatomic) BOOL showC2CInHotelSearch;        //
@property (nonatomic) BOOL showC2COrder;                //
@property (nonatomic) BOOL openNetMonitoring;           //是否开启网络监控
@property (nonatomic) BOOL registNewForIOS;             //是否使用新注册流程
@property (nonatomic) BOOL hkHotelWifi;                 // 香港酒店免费wiki开关

@property (nonatomic) BOOL showCouponApplyText;          //是否显示申请返现相关文案
@property (nonatomic) BOOL tourPalOn;                    //是否开启找驴友项目

// 紧急处理模块
@property (nonatomic) BOOL urgentHotel;                 // 是否开启紧急酒店模块
@property (nonatomic) BOOL urgentGroupon;               // 是否开启紧急团购模块
@property (nonatomic) BOOL urgentFlight;                // 是否开启紧急机票模块
@property (nonatomic) BOOL urgentTrain;                 // 是否开启紧急火车票模块
@property (nonatomic) BOOL urgentMyElong;               // 是否开启紧急个人中心模块
@property (nonatomic) BOOL urgentApp;                   // 是否全线启用紧急处理

// 公寓模块紧急处理开关 苏松添加 2015-5-15
@property (nonatomic) BOOL isNewApartmentAvaliable;     // 新版公寓入口是否可用
@property (nonatomic) BOOL isApartmentAvaliable;        // 旧版公寓入口是否可用
@property (nonatomic) BOOL isNAPriceSortAvailable;      // 新版价格排序是否可用

@property (nonatomic) BOOL IsCheckedCashDefaultForiOS;        // 默认返现开关
@property (nonatomic) BOOL IsCheckedDiscountCashDefaultForiOS; //五折返现是否勾选

@property (nonatomic, assign) BOOL isOpenIhotelFCode;           //国际酒店优惠码开关

@property (nonatomic) BOOL isShowSupplierName;              //是否显示供应商名字(目前用于国内酒店详情页的房型产品名)

@property (nonatomic) BOOL isClockHotelAvailable;         //是否显示钟点房(本地配置文件默认是打开的)

// 机票开关
@property (nonatomic, assign) BOOL FlightDiscount;      // 是否可以使用红包
@property (nonatomic, assign) BOOL FlightDeliveryFee;   // 快递是否收费

// add by yangfan 2015.12.17  个人中心首页会员俱乐部入口开关
@property (nonatomic, assign) BOOL isOpenUserClub;

// add 9.8.0  个人中心 是否为新的提现规则开关
@property (nonatomic, assign) BOOL isNewWithdraw;

// add 9.10.0 个人中心 积分商城入口开关
@property (nonatomic, assign) BOOL isOpenPointMall;


+ (eLongProcessSwitcher *)shared;

@end
