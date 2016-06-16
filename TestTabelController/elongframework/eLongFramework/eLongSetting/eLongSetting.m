//
//  Setting.m
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongSetting.h"
#import "eLongKeyChain.h"
#import "eLongUserDefault.h"
#import "eLongDefine.h"

static NSString *const ELONG_AUTO_LOGIN		= @"ELONG_AUTO_LOGIN";

@interface eLongSetting(){
@private
    int m_hotelListCount;
    int m_flightlistCount;
    BOOL m_displayHotelPic;
    BOOL remAccount;
    BOOL remPassword;
    BOOL autoLogin;						// 是否自动登录
    BOOL mapPriority;					// 周边查询页面是否优先显示地图模式
}
@property (nonatomic,copy) NSString *m_departCity;
@property (nonatomic,copy) NSString *m_account;
@property (nonatomic,copy) NSString *m_password;
@property (nonatomic,copy) NSString *m_defaultClassType;

@property (nonatomic, copy) NSString *elong12306Account;
@property (nonatomic, copy) NSString *elong12306Password;
@property (nonatomic, copy) NSString *elong12306UserToken;

@end

@implementation eLongSetting

- (void) dealloc{
    self.m_departCity = nil;
    self.m_account = nil;
    self.m_password = nil;
    self.m_defaultClassType = nil;
    
    self.elong12306Account = nil;
    self.elong12306Password = nil;
    self.elong12306UserToken = nil;
    
    
    self.globalRepeatSubmitToken = nil;
    self.keyCheckIsChange = nil;
    self.leftTicketStr = nil;
    self.purposeCodes = nil;
    self.tourFlag = nil;
    self.trainLocation = nil;
    self.orderRepeatToken = nil;
    self.randCode = nil;
    self.orderId = nil;
    self.gorderId = nil;
    self.merchantOrderId = nil;
    self.mobileAlertAbout12306Tip = nil;
}


-(int)defaultHotelListCount{
    return m_hotelListCount;
}
-(int)defaultFlightListCount{
    return m_flightlistCount;
}
-(BOOL)defaultDisplayHotelPic{
    return m_displayHotelPic;
}
-(NSString *)defaultDepartCity{
    return self.m_departCity;
}
-(NSString *)defaultAccount{
    return self.m_account;
}
-(NSString *)defaultPwd{
    return self.m_password;
}
-(NSString *)defaultClassType{
    return self.m_defaultClassType;
}

-(BOOL)isRemAccount{
    return remAccount;
}
-(BOOL)isRemPassword{
    return remPassword;
}

-(BOOL)getMapPriority {
    
    if ([eLongUserDefault hasObjectForKey:@"MapPriority"]) {
        
        return [[eLongUserDefault objectForKey:@"MapPriority"] boolValue];
    }
    else {
        
        return NO;
    }
}

-(void)setDisplayPhotoIn2G:(BOOL)display {
    
    [eLongUserDefault setObject:[NSNumber numberWithBool:display] forKey:@"DisplayPhotoIn2G"];
}

-(BOOL)displayPhotoIn2G {
    
    if ([eLongUserDefault hasObjectForKey:@"DisplayPhotoIn2G"]) {
        
        return [[eLongUserDefault objectForKey:@"DisplayPhotoIn2G"] boolValue];
    }
    else {
        
        return YES;
    }
}

-(BOOL)displayHotelPic {
    
    if ([eLongUserDefault hasObjectForKey:@"DisplayHotelPic"]) {
        
        return [[eLongUserDefault objectForKey:@"DisplayHotelPic"] boolValue];
    }
    else {
        
        return YES;
    }
}


-(void)setHotelListCount:(int)count {
    m_hotelListCount=count;
    [eLongUserDefault setObject:[NSNumber numberWithInt:m_hotelListCount] forKey:@"HotelListCount"];
}
-(void)setFlightListCount:(int)count{
    m_flightlistCount=count;
    [eLongUserDefault setObject:[NSNumber numberWithInt:m_flightlistCount] forKey:@"FlightlistCount"];
}
-(void)setDisplayHotelPic:(BOOL)display{
    m_displayHotelPic=display;
    [eLongUserDefault setObject:[NSNumber numberWithBool:m_displayHotelPic] forKey:@"DisplayHotelPic"];
}
-(void)setDepartCity:(NSString *)departCity{
    self.m_departCity=departCity;
    [eLongUserDefault setObject:self.m_departCity forKey:@"DepartCity"];
}

-(void)setRemAccount:(BOOL)save{
    remAccount=save;
    [eLongUserDefault setObject:[NSNumber numberWithBool:remAccount] forKey:@"RemAccount"];
}

-(void)setRemPassword:(BOOL)save{
    remPassword=save;
    [eLongUserDefault setObject:[NSNumber numberWithBool:remPassword] forKey:@"RemPassword"];
}


- (void)setAutoLogin:(BOOL)animated {
    autoLogin = animated;
    [eLongUserDefault setObject:[NSNumber numberWithBool:animated] forKey:ELONG_AUTO_LOGIN];
}

- (BOOL)isAutoLogin {
    return autoLogin;
}

-(void)setAccount:(NSString *)account{
    self.m_account=account;
    /*
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:self.m_account forKey:@"Account"];
     [defaults synchronize];
     */
    
    [eLongKeyChain writeValue:account forKey:KEYCHAIN_ACCOUNT];
    
}

-(void)setMapPriority:(BOOL)animated {
    mapPriority = animated;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:mapPriority] forKey:@"MapPriority"];
    [defaults synchronize];
}

-(void)setPwd:(NSString *)pwd{
    self.m_password=pwd;
    /*
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:self.m_password forKey:@"Password"];
     [defaults synchronize];
     */
    
    [eLongKeyChain writeValue:pwd forKey:KEYCHAIN_PASSWORD];
}

-(void)setClassType:(NSString *)classtype{
    self.m_defaultClassType = classtype;
    [eLongUserDefault setObject:self.m_defaultClassType forKey:@"ClassType"];
}

-(NSString *)getKeyChainPassWord{
    
    return[eLongKeyChain readValueForKey:KEYCHAIN_PASSWORD];
}

- (void) clearPwd{
    [eLongUserDefault removeObjectForKey:@"Password"];
    
    [eLongKeyChain deleteValueForKey:KEYCHAIN_PASSWORD];
}

-(id)init{
    if (self=[super init]) {
        
        NSString *DepartCity = [eLongUserDefault objectForKey:@"DepartCity"];
        NSString *Account = [eLongUserDefault objectForKey:@"Account"];
        NSNumber *DisplayHotelPic = [eLongUserDefault objectForKey:@"DisplayHotelPic"];
        NSNumber *HotelListCount = [eLongUserDefault objectForKey:@"HotelListCount"];
        NSNumber *FlightlistCount = [eLongUserDefault objectForKey:@"FlightlistCount"];
        NSString *FlightClassType = [eLongUserDefault objectForKey:@"ClassType"];
        NSString *Password = [eLongUserDefault objectForKey:@"Password"];
        NSNumber *IsRemAccount = [eLongUserDefault objectForKey:@"RemAccount"];
        NSNumber *IsRemPassword = [eLongUserDefault objectForKey:@"RemPassword"];
        NSNumber *isAutoLogin = [eLongUserDefault objectForKey:ELONG_AUTO_LOGIN];
        
        if (DepartCity==nil) {
            self.m_departCity=@"北京";
        }else {
            self.m_departCity=DepartCity;
        }
        
        if (FlightClassType==nil) {
            self.m_defaultClassType=@"不限";
        }else {
            self.m_defaultClassType=FlightClassType;
        }
        
        if (DisplayHotelPic==nil) {
            m_displayHotelPic=YES;
        }else {
            m_displayHotelPic=[DisplayHotelPic boolValue];
        }
        if (IsRemAccount==nil) {
            remAccount=NO;
        }else {
            remAccount=[IsRemAccount boolValue];
        }
        if (IsRemPassword==nil) {
            remPassword=NO;
        }else {
            remPassword=[IsRemPassword boolValue];
        }
        
        if (HotelListCount==nil) {
            m_hotelListCount=25;
        }else {
            m_hotelListCount=[HotelListCount intValue];
        }
        
        if (FlightlistCount==nil) {
            m_flightlistCount=51;
        }else {
            m_flightlistCount=[FlightlistCount intValue];
        }
        
        
        // 用户名密码转存到keychain by dawn 2014.3.24
        if (Account==nil||[Account length]==0) {
            // 本地数据取不到用户名，尝试读取keychain
            Account = [eLongKeyChain readValueForKey:KEYCHAIN_ACCOUNT];
            if (Account == nil) {
                self.m_account=@"";
            }else{
                self.m_account= Account;
            }
        }else {
            // 本地数据可以取到用户名
            self.m_account=Account;
            // 存入keychain
            [eLongKeyChain writeValue:self.m_account forKey:KEYCHAIN_ACCOUNT];
            // 移除本地数据
            [eLongUserDefault removeObjectForKey:@"Account"];
        }
        
        if (Password==nil||[Password length]==0) {
            // 本地数据取不到密码
            Password = [eLongKeyChain readValueForKey:KEYCHAIN_PASSWORD];
            
            if (Password == nil) {
                self.m_password = @"";
            }else{
                self.m_password = Password;
            }
        }else {
            // 本地数据可以取到密码
            self.m_password = Password;
            // 存入keychain
            [eLongKeyChain writeValue:self.m_password forKey:KEYCHAIN_PASSWORD];
            // 移除本地数据
            [eLongUserDefault removeObjectForKey:@"Password"];
        }
        
        if (!isAutoLogin) {
            autoLogin = NO;
        }
        else {
            autoLogin = [isAutoLogin boolValue];
        }
        
    }
    return self;
}

-(void)setRegisterAccount:(NSString *)account{
    if (STRINGHASVALUE(account)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:account forKey:@"RegisterAccount"];
        [defaults synchronize];
    }
}
-(NSString *)registerAccount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults objectForKey:@"RegisterAccount"];
    return (STRINGHASVALUE(string))?string:@"";
}

-(void)clearRegisterAccount{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults  removeObjectForKey:@"RegisterAccount"];
    [defaults synchronize];
}

#pragma mark
#pragma mark ------12306

-(void)set12306Account:(NSString *)account{
    self.elong12306Account = account;
    [eLongKeyChain writeValue:account forKey:KEYCHAIN_12306_ACCOUNT];
}

-(void)set12306Password:(NSString *)password{
    self.elong12306Password = password;
    [eLongKeyChain writeValue:password forKey:KEYCHAIN_12306_PASSWORD];
}

-(void)set12306UserToken:(NSString *)userToken{
    self.elong12306UserToken = userToken;
    [eLongKeyChain writeValue:userToken forKey:KEYCHAIN_12306_USERTOKEN];
}

- (NSString *)elong12306Account
{
    return STRINGHASVALUE([eLongKeyChain readValueForKey:KEYCHAIN_12306_ACCOUNT]) ? [eLongKeyChain readValueForKey:KEYCHAIN_12306_ACCOUNT] : _elong12306Account;
    //    if (STRINGHASVALUE([eLongKeyChain readValueForKey:KEYCHAIN_12306_ACCOUNT]))
    //    return [eLongKeyChain readValueForKey:KEYCHAIN_12306_ACCOUNT];
    //    return _elong12306Account;
}

- (NSString *)elong12306Password
{
    return STRINGHASVALUE([eLongKeyChain readValueForKey:KEYCHAIN_12306_PASSWORD]) ? [eLongKeyChain readValueForKey:KEYCHAIN_12306_PASSWORD] : _elong12306Password;
    //    return _elong12306Password;
}
- (NSString *)elong12306Usertoken
{
    return _elong12306UserToken;
}

- (BOOL)is12306Login
{
    if (STRINGHASVALUE(_elong12306Account) && STRINGHASVALUE(_elong12306Password) && STRINGHASVALUE(_elong12306UserToken)) {
        return YES;
    }
    return NO;
}

- (void)clear12306Account
{
    [self setElong12306Account:nil];
    [self setElong12306Password:nil];
    [self setElong12306UserToken:nil];
    //    self.elong12306Account = nil;
    //    self.elong12306Password = nil;
    //    self.elong12306UserToken = nil;
}

- (void)clear12306UserToken
{
    [self setElong12306UserToken:nil];
}

//是不是港澳台标记
- (BOOL)isHongAoTai
{
    if ([self defaultAccount] ) {
        NSString  *matchHongKangStr = @"SELF MATCHES '852[0-9]{8}$'";
        NSString  *matchAomenStr =@"SELF MATCHES '853[0-9]{8}$'";
        NSString   *matchTaiwanStr =@"SELF MATCHES '886[0-9]{9}$'";
        
        if ([[NSPredicate predicateWithFormat:matchHongKangStr]
             evaluateWithObject:[self  defaultAccount]]
            ||[[NSPredicate predicateWithFormat:matchAomenStr]
               evaluateWithObject:[self  defaultAccount]]
            ||[[NSPredicate predicateWithFormat:matchTaiwanStr]
               evaluateWithObject:[self  defaultAccount]])
        {
            
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
