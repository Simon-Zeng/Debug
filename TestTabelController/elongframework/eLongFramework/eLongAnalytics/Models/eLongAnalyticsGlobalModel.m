//
//  eLongAnalyticsGlobalModel.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/12/1.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsGlobalModel.h"
#import "eLongUserDefault.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "eLongAccountManager.h"
#import "eLongDefine.h"

#define ANALTTICS_CIN_KEY @"ANALTTICS_CIN_KEY"

@interface eLongAnalyticsGlobalModel()

/**
 *  设备类型，1—Iphone 2—Ipad 3—Android 5—Winphone 7—PC 8—androidpad 9—windowspad 99—Unkown，启动时上传
 */
@property (nonatomic, copy) NSString *dt;

/**
 *  设备品牌，启动时上传
 */
@property (nonatomic, copy) NSString *md;

/**
 *  本机安装已应用列表，非必需，启动时上传
 */
@property (nonatomic, copy) NSString *apps;

/**
 *  客户端类型，app 1 浏览器 2，启动时上传
 */
@property (nonatomic, copy) NSString *ct;

/**
 *  运营商，启动时上传
 */
@property (nonatomic, copy) NSString *tsp;

/**
 *  当前网络类型 0—unknown 1-ethernet 2-wifi 3-2g 4-3g 5-4g
 */
@property (nonatomic, copy) NSString *nt;

/**
 *  （deviceid or cookie）App直接取deviceid
 */
@property (nonatomic, copy) NSString *cid;

/**
 *  是否登录
 */
@property (nonatomic, assign) BOOL islogin;

/**
 *  艺龙卡号
 */
@property (nonatomic, copy) NSString *ecrd;

/**
 *  用户级别
 */
@property (nonatomic, copy) NSString *elev;

/**
 *  网络信息
 */
@property (nonatomic,strong) CTTelephonyNetworkInfo *networkInfo;

@end

@implementation eLongAnalyticsGlobalModel

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id singleton;
    dispatch_once(&once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (id)init
{
    if (self = [super init]) {
        
        self.dt = @"1";
        self.md = @"iPhone";
        self.ct = @"1";
        self.opens = @"1";
        self.clientType = @"1";
        _sid = [self getSessionId];
        self.aif = @"10000";
        self.of = @"20000";
    }
    
    return self;
}

- (NSNumber *)cin
{
    NSNumber *number = [eLongUserDefault objectForKey:ANALTTICS_CIN_KEY] ? [eLongUserDefault objectForKey:ANALTTICS_CIN_KEY] : [NSNumber numberWithLongLong:1];
    
    return number;
}

- (void)updateCin
{
    @synchronized(self) {
        
        long long cinV = [self.cin longLongValue];
        cinV ++;
        
        NSNumber *cinNumber = [NSNumber numberWithLongLong:cinV];
        
        [eLongUserDefault setObject:cinNumber forKey:ANALTTICS_CIN_KEY];
    }
}

- (NSString *)bs
{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    NSString *currentBs = [NSString stringWithFormat:@"%0.0f*%0.0f",size_screen.width * scale_screen,size_screen.height * scale_screen];
    
    return currentBs;
}

- (NSString *)os
{
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)osv
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)lg
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}

- (NSString *)v
{
    NSString *appv = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return appv;
}

-(CTTelephonyNetworkInfo *)networkInfo{
    if (_networkInfo == nil) {
        _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    
    return _networkInfo;
}

- (NSString *)tsp
{
    return _networkInfo.subscriberCellularProvider.carrierName;
}

- (NSDictionary *)getBasicAnalyticsInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.sid.length > 0) {
        
        [dict setObject:self.sid forKey:@"sessionId"];
    }
    else {
        
        NSLog(@"eLongAnatics---sid sessionId未赋值！！！");
    }
    
    if (self.dt.length > 0) {
        
        [dict setObject:self.dt forKey:@"dt"];
    }
    else {
        
        NSLog(@"eLongAnatics---dt设备类型未赋值！！！");
    }
    
    if (self.clientType.length > 0) {
        
        [dict setObject:self.clientType forKey:@"clientType"];
    }
    else {
        
        NSLog(@"eLongAnatics---clientType设备类型未赋值！！！");
    }
    
    if (self.md.length > 0) {
        
        [dict setObject:self.md forKey:@"md"];
    }
    else {
        
        NSLog(@"eLongAnatics---md设备品牌未赋值！！！");
    }
    
    if (self.bs.length > 0) {
        
        [dict setObject:self.bs forKey:@"bs"];
    }
    else {
        
        NSLog(@"eLongAnatics---bs设备分辨率未赋值！！！");
    }
    
    if (self.os.length > 0) {
        
        [dict setObject:self.os forKey:@"os"];
    }
    else {
        
        NSLog(@"eLongAnatics---os设备操作系统未赋值！！！");
    }
    
    if (self.osv.length > 0) {
        
        [dict setObject:self.osv forKey:@"osv"];
    }
    else {
        
        NSLog(@"eLongAnatics---osv设备操作系统版本未赋值！！！");
    }
    
    if (self.deviceId.length > 0) {
        
        [dict setObject:self.deviceId forKey:@"mac"];
        [dict setObject:self.deviceId forKey:@"deviceId"];
        [dict setObject:self.deviceId forKey:@"cid"];
    }
    else {
        
        NSLog(@"eLongAnatics---mac地址未赋值！！！");
    }
    
    if (self.apps.length > 0) {
        
        [dict setObject:self.apps forKey:@"apps"];
    }
    else {
        
        NSLog(@"eLongAnatics---apps应用列表未赋值！！！");
    }
    
    if (self.lg.length > 0) {
        
        [dict setObject:self.lg forKey:@"lg"];
    }
    else {
        
        NSLog(@"eLongAnatics---lg设备语言未赋值！！！");
    }
    
    if (self.ct.length > 0) {
        
        [dict setObject:self.ct forKey:@"ct"];
    }
    else {
        
        NSLog(@"eLongAnatics---lg客户端类型未赋值！！！");
    }
    
    if (self.v.length > 0) {
        
        [dict setObject:self.v forKey:@"v"];
    }
    else {
        
        NSLog(@"eLongAnatics---v客户端版本未赋值！！！");
    }
    
    if (self.opens.length > 0) {
        
        [dict setObject:self.opens forKey:@"opens"];
    }
    else {
        
        NSLog(@"eLongAnatics---opens客户端打开方式未赋值！！！");
    }
    
    if (self.tsp.length > 0) {
        
        [dict setObject:self.tsp forKey:@"tsp"];
    }
    else {
        
        NSLog(@"eLongAnatics---tsp运营商未赋值！！！");
    }
    
    if (self.chid.length > 0) {
        
        [dict setObject:self.chid forKey:@"chid"];
    }
    else {
        
        NSLog(@"eLongAnatics---chid channelId未赋值！！！");
    }
    
    if (self.appv.length > 0) {
        
        [dict setObject:self.appv forKey:@"appv"];
    }
    else {
        
        NSLog(@"eLongAnatics---appv channelId未赋值！！！");
    }
    
    return dict;
}

- (NSDictionary *)getAnalyticsInfo
{
    self.islogin = [eLongAccountManager userInstance].isLogin;
    
    if (self.islogin) {
        
        self.ecrd = [eLongAccountManager userInstance].cardNo;
        self.elev = [NSString stringWithFormat:@"%ld",(long)[eLongAccountManager userInstance].userLevel];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.dt.length > 0) {
        
        [dict setObject:self.dt forKey:@"dt"];
    }
    else {
        
        NSLog(@"eLongAnatics---dt设备类型未赋值！！！");
    }
    
    if (self.md.length > 0) {
        
        [dict setObject:self.md forKey:@"md"];
    }
    else {
        
        NSLog(@"eLongAnatics---md设备品牌未赋值！！！");
    }
    
    if (self.bs.length > 0) {
        
        [dict setObject:self.bs forKey:@"bs"];
    }
    else {
        
        NSLog(@"eLongAnatics---bs设备分辨率未赋值！！！");
    }
    
    if (self.ct.length > 0) {
        
        [dict setObject:self.ct forKey:@"ct"];
    }
    else {
        
        NSLog(@"eLongAnatics---lg客户端类型未赋值！！！");
    }
    
    if (self.opens.length > 0) {
        
        [dict setObject:self.opens forKey:@"opens"];
    }
    else {
        
        NSLog(@"eLongAnatics---opens客户端打开方式未赋值！！！");
    }
    
    if (self.nt.length > 0) {
        
        [dict setObject:self.nt forKey:@"nt"];
    }
    else {
        
        NSLog(@"eLongAnatics---nt 当前网络类型未赋值！！！");
    }
    
    if (self.sid.length > 0) {
        
        [dict setObject:self.sid forKey:@"sid"];
    }
    else {
        
        NSLog(@"eLongAnatics---sid sessionId未赋值！！！");
    }
    
    [dict setObject:[[NSNumber numberWithBool:self.islogin] stringValue] forKey:@"islogin"];
    
    if (self.ecrd.length > 0) {
        
        [dict setObject:self.ecrd forKey:@"ecrd"];
    }
    else {
        
        NSLog(@"eLongAnatics---ecrd 艺龙卡号未赋值！！！");
    }
    
    if (self.elev.length > 0) {
        
        [dict setObject:self.elev forKey:@"elev"];
    }
    else {
        
        NSLog(@"eLongAnatics---elev 用户等级未赋值！！！");
    }
    
    if (self.deviceId.length > 0) {
        
        [dict setObject:self.deviceId forKey:@"deviceId"];
        [dict setObject:self.deviceId forKey:@"cid"];
    }
    else {
        
        NSLog(@"eLongAnatics---mac地址未赋值！！！");
    }
    
    if (self.clientType.length > 0) {
        
        [dict setObject:self.clientType forKey:@"clientType"];
    }
    else {
        
        NSLog(@"eLongAnatics---clientType设备类型未赋值！！！");
    }
    
    if (self.of.length > 0) {
        
        [dict setObject:self.of forKey:@"of"];
    }
    
    if (self.aif.length > 0) {
        
        [dict setObject:self.aif forKey:@"if"];
    }
    
    return dict;
}

- (NSString *)getSessionId
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

- (void)resetAchievementFlag
{
    self.aif = @"10000";
    //self.of = @"20000";
}

- (void)resetIfValue
{
    self.aif = @"10000";
}

- (void)resetOfValue
{
    self.of = @"20000";
}

- (NSString *)urlStringAppendAnalyticsData:(NSString *)urlStr
{
    if (!STRINGHASVALUE(urlStr)) {
        
        return nil;
    }
    
    NSString *newUrl = nil;
    
    NSArray *targetArray = [urlStr componentsSeparatedByString:@"?"];
    if (targetArray.count == 2) {
        
        newUrl = [NSString stringWithFormat:@"%@&of=%@&if=%@&chid=%@&ref=%@",urlStr,self.of,self.aif,self.chid,self.chid];
    }
    else {
        
        newUrl = [NSString stringWithFormat:@"%@?of=%@&if=%@&chid=%@&ref=%@",urlStr,self.of,self.aif,self.chid,self.chid];
    }
    
    if (STRINGHASVALUE(self.ch)) {
        
        newUrl = [newUrl stringByAppendingString:[NSString stringWithFormat:@"&ch=%@",self.ch]];
    }
    
    return newUrl;
}

@end
