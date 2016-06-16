//
//  Setting.h
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface eLongSetting : NSObject {
    
}

@property (nonatomic, copy) NSString *globalRepeatSubmitToken;
@property (nonatomic, copy) NSString *keyCheckIsChange;
@property (nonatomic, copy) NSString *leftTicketStr;
@property (nonatomic, copy) NSString *purposeCodes;
@property (nonatomic, copy) NSString *tourFlag;
@property (nonatomic, copy) NSString *trainLocation;
@property (nonatomic, copy) NSString *orderRepeatToken;
@property (nonatomic, copy) NSString *randCode;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *gorderId;
@property (nonatomic, copy) NSString *merchantOrderId;
// 12306订单填写页手机号提示文案
@property (nonatomic, copy) NSString *mobileAlertAbout12306Tip;


-(void)setDisplayPhotoIn2G:(BOOL)display;
-(BOOL)displayPhotoIn2G;
-(BOOL)displayHotelPic;
-(void)setHotelListCount:(int)count;
-(void)setFlightListCount:(int)count;
-(void)setDisplayHotelPic:(BOOL)display;
-(void)setMapPriority:(BOOL)animated;
-(void)setDepartCity:(NSString *)departCity;
-(void)setAccount:(NSString *)account;
-(void)setClassType:(NSString *)classtype;
-(int)defaultHotelListCount;
-(int)defaultFlightListCount;
-(BOOL)defaultDisplayHotelPic;
-(NSString *)defaultDepartCity;
-(NSString *)defaultAccount;
-(NSString *)defaultClassType;
-(NSString *)defaultPwd;
-(NSString *)getKeyChainPassWord;
-(void)setPwd:(NSString *)pwd;
-(BOOL)isRemAccount;
-(BOOL)isRemPassword;
-(BOOL)isAutoLogin;
-(BOOL)getMapPriority;
- (BOOL)isHongAoTai;   //是不是港澳台
-(void)setRemAccount:(BOOL)save;
-(void)setRemPassword:(BOOL)save;
-(void)setAutoLogin:(BOOL)animated;
-(void)clearPwd;

-(void)clearRegisterAccount;
-(void)setRegisterAccount:(NSString *)account;
-(NSString *)registerAccount;


-(void)set12306Account:(NSString *)account;
-(void)set12306Password:(NSString *)password;
-(void)set12306UserToken:(NSString *)userToken;

- (NSString *)elong12306Account;
- (NSString *)elong12306Password;
- (NSString *)elong12306Usertoken;
- (BOOL)is12306Login;
// 登录失败或token失效时候或用户清空当前12306账户时调用
- (void)clear12306Account;
- (void)clear12306UserToken;

@end
