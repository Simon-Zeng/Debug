//
//  eLongAccountUserInstance.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountUserInstance.h"
#import "eLongAccountUserModel.h"
#import "eLongAccountAddressRequestModel.h"
#import "eLongAccountCustomerRequestModel.h"
#import "eLongAccountModifyUserRequestModel.h"
#import "eLongAccountInvoiceRequestModel.h"
#import "NSString+eLongExtension.h"
#import "NSDictionary+CheckDictionary.h"
#import "elongAccountUserRankInfoModel.h"
#import "eLongDefine.h"
#define CARD_NUMBER					@"CardNo"
#define SESSION_TOKEN               @"SessionToken"
#define APPTYPE                     @"1"

 @interface eLongAccountUserInstance ()
{
    NSInteger points;
    NSNumberFormatter *numberFormatter;

}
@property (nonatomic,strong) eLongAccountUserModel *userModel;
@end

@implementation eLongAccountUserInstance

-(id)init{

    if (self = [super init]) {
        _userLevel = 0;
        points = 0;
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    }
    return self;
}

-(NSDictionary *)getLastLoginSavedUserInfo{

    id object = [[NSUserDefaults standardUserDefaults] objectForKey:Keys_UserDefault_UserInfo];
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)object;
    }
    return nil;
}

-(void)setOriginalDataByLoginReturnDic:(NSDictionary *)root{

    if (root && [root isKindOfClass:[NSDictionary class]] && [root count]>0) {
        NSError *error = nil;
        eLongAccountUserModel *model = [[eLongAccountUserModel alloc] initWithDictionary:root error:&error];
        if (!error) {
            self.userModel = model;
            //
            [[NSUserDefaults standardUserDefaults] setObject:[model toDictionary] forKey:Keys_UserDefault_UserInfo];
            [[NSUserDefaults standardUserDefaults] setObject:[self cardNo] forKey:CARD_NUMBER];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //请求用户类型
            [self requestUserLevelAndCreditsWithCarNo:self.cardNo];
            // 请求用户等级
            [self requestUserRankInfoWithCardNo:self.cardNo];
            //绑定Push接口
            [self requestBindingPush];
            
        }else{
            NSLog(@"elongAccountUserModel parse failed !");
        }
    }
}

-(void)clearData{

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Keys_UserDefault_UserInfo];

    if (STRINGHASVALUE([self cardNo])) {
    
        [[NSUserDefaults  standardUserDefaults] removeObjectForKey:[self cardNo]];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CARD_NUMBER];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.userModel = nil;
    _userLevel = 0;
    self.userRankInfoModel = nil;
}

#pragma mark
#pragma mark ------NetRequest 

-(void)requestUserLevelAndCreditsWithCarNo:(NSString *)carNo{
    NSDictionary *req = [NSDictionary dictionaryWithObjectsAndKeys:carNo,@"CardNo", nil];
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/useablecredits"
                                                                       params:req
                                                                       method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request
                           success:^(eLongHTTPRequestOperation *op,id object){
                               if ([(NSDictionary *)object hasValue]) {
                                   NSDictionary *dic = (NSDictionary *)object;
                                   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                   if ([dic objectForKey:@"CreditCount"]) {
                                       points = [[dic objectForKey:@"CreditCount"] integerValue];
                                   }
                                   if ([dic objectForKey:@"UserLever"]) {
                                       _userLevel = [[dic objectForKey:@"UserLever"] integerValue];
                                   }
                                   if (_userLevel >= 2) {
                                       if (![[self cardNo]empty]) {
                                           [userDefaults setObject:@(2) forKey:[self cardNo]];
                                           [userDefaults synchronize];
                                       }
                                       //龙翠会员发送通知
                                       [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_IsDragonMember object:nil];
                                   }else{
                                       if (![[self cardNo]empty]) {
                                           [userDefaults setObject:@(0) forKey:[self cardNo]];
                                           [userDefaults synchronize];
                                       }
                                   }
                               }
                           }
                           failure:^(eLongHTTPRequestOperation *op,NSError *error){}];
}

// 请求用户等级信息
- (void)requestUserRankInfoWithCardNo:(NSString *)cardNo {
    if (!STRINGHASVALUE(cardNo)) {
        return;
    }
    
    NSDictionary *paramsDict = @{@"cardNo" : cardNo};
    if (STRINGHASVALUE(self.proxy)) {
        paramsDict = @{@"cardNo" : cardNo, @"proxy" : self.proxy};
    }
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:@"user/UserRankInfo"
                             params:paramsDict
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request
                           success:^(eLongHTTPRequestOperation *operation, id responseObject) {
                               NSLog(@"level == %@",responseObject);
                               elongAccountUserRankInfoModel *model = [[elongAccountUserRankInfoModel alloc] initWithDictionary:responseObject error:nil];
                               if (model) {
                                   if (!model.IsError) {
                                       self.userRankInfoModel = model;
                                       // 记录最原始的等级
                                       NSString *key = [NSString stringWithFormat:@"myElong_%@",cardNo];
                                       NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                       NSString *oldLevel = [userDefault objectForKey:key];
                                       if (!oldLevel) {
                                           NSString *currentLevel = model.gradeId;
                                           if (currentLevel) {
                                               [userDefault setObject:currentLevel forKey:key];
                                           }
                                       }
                                       [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Rank_Info object:nil];
                                   }
                               }
                               
                           } failure:^(eLongHTTPRequestOperation *operation, NSError *error) {
                           }];
    
}

-(void)requestBindingPush{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:Keys_UserDefault_DeviceToken];
    if (deviceToken) {
        //AppType  ios默认为1
        NSDictionary *req = @{
                              @"PushId":STRINGHASVALUE(deviceToken)?deviceToken:@"",
                              @"UserId":STRINGHASVALUE(self.cardNo)?self.cardNo:@"",
                              @"AppType":APPTYPE
                              };
        NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"user/bindUserPush"
                                                                           params:req
                                                                           method:eLongNetworkRequestMethodPOST];

        [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *op,id object){
            NSLog(@"PushToken-Binding is %@",object);
        }failure:^(eLongHTTPRequestOperation *op,NSError *error){
        }];
    }
}
-(void)requestUnBindingPush{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:Keys_UserDefault_DeviceToken];
    if (deviceToken) {
        //AppType  ios默认为1
        NSDictionary *req = @{
                              @"PushId":STRINGHASVALUE(deviceToken)?deviceToken:@"",
                              @"UserId":STRINGHASVALUE(self.cardNo)?self.cardNo:@"",
                              @"AppType":APPTYPE
                              };
        NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"user/unBindUserPush"
                                                                           params:req
                                                                           method:eLongNetworkRequestMethodPOST];
        
        [eLongHTTPRequest startRequest:request success:^(eLongHTTPRequestOperation *op,id object){
            NSLog(@"PushToken-UnBinding is %@",object);
        }failure:^(eLongHTTPRequestOperation *op,NSError *error){
        }];
    }
}

#pragma mark
#pragma mark ------修改个人信息

-(eLongHTTPRequestOperation *)modifyElongUserWithModifyUserModel:(eLongAccountModifyUserRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountModifyUserRequestModel bussinessURL]
                             params:[model toDictionary] method:eLongNetworkRequestMethodPOST];
    return [eLongHTTPRequest startRequest:request success:success failure:failed];
}


-(eLongHTTPRequestOperation *)getAreaCodeSuccess:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSDictionary *jsonDict = [NSDictionary  dictionaryWithObject:@"1" forKey:@"language"];
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"mtools/getAreaCode" params:jsonDict method:eLongNetworkRequestMethodGET];
    return [eLongHTTPRequest startRequest:request success:success failure:failed];
}

#pragma mark
#pragma mark ------发票抬头相关（增删改查）

-(void)addInvoiceWithInvoiceID:(NSString *)invoiceID Content:(NSString *)value Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{

    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountInvoiceRequestModel addInvoiceBusiness]
                             params:[eLongAccountInvoiceRequestModel addInvoiceWithTitleID:invoiceID Value:value]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)deleteInvoiceWithInvoiceID:(NSString *)invoiceID Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountInvoiceRequestModel deleteInvoiceBusiness]
                            params:[eLongAccountInvoiceRequestModel deleteInvoiceWithID:invoiceID]
                            method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)modifyInvoiceWithInvoiceID:(NSString *)invoiceID Value:(NSString *)value Default:(BOOL)defaultOrNot Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request  = [[eLongNetworkRequest sharedInstance]
                              javaRequest:[eLongAccountInvoiceRequestModel modifyInvoiceBusiness]
                              params:[eLongAccountInvoiceRequestModel modifyInvoiceWithID:invoiceID Value:value default:defaultOrNot]
                              method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)getInvoicelistSuccess:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{

    NSURLRequest *request  = [[eLongNetworkRequest sharedInstance]
                              javaRequest:[eLongAccountInvoiceRequestModel invoiceListBusiness]
                              params:[eLongAccountInvoiceRequestModel getInvoiceList]
                              method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

#pragma mark
#pragma mark ------邮寄地址相关

-(void)addAddressWithModel:(eLongAccountAddressRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[model addAddressRequestBusiness]
                             params:[model addAddressRequestParameters]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)deleteAddressWithAddressID:(NSNumber *)ID Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountAddressRequestModel deleteAddressRequestBusiness]
                             params:[eLongAccountAddressRequestModel deleteAddressWithID:ID]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)modifyAddressWithModel:(eLongAccountAddressRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[model modifyAddressRequestBusiness]
                             params:[model modifyAddressRequestParameter]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)getAddressListWithCardNo:(NSString *)cardNo PageIndex:(NSInteger)index PageSize:(NSInteger)size Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountAddressRequestModel getAddressListRequestBusiness]
                             params:[eLongAccountAddressRequestModel getAddressListWithCardNo:cardNo PageIndex:index PageSize:size]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

#pragma mark
#pragma mark ------联系人相关

-(void)addCustomerWithModel:(eLongAccountCustomerRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[model addCustomerRequestBusiness]
                             params:[model addCustomerRequestParameters]
                             method:eLongNetworkRequestMethodPOST];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)deleteCustomerWithAddressID:(NSNumber *)ID CardNo:(NSString *)cardNo Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountCustomerRequestModel deleteCustomerRequestBusiness]
                             params:[eLongAccountCustomerRequestModel deleteCustomerWithID:ID andCarNo:cardNo]
                             method:eLongNetworkRequestMethodDELETE];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)modifyCustomerWithModel:(eLongAccountCustomerRequestModel*)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[model modifyCustomerRequestBusiness]
                             params:[model modifyCutomerRequestParameter]
                             method:eLongNetworkRequestMethodPUT];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)getCustomersListWithCustomerType:(CustomerType)type CardNo:(NSString *)cardNo  PageIndex:(NSInteger)index PageSize:(NSInteger)size Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed{
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[eLongAccountCustomerRequestModel getCustomersRequestBusiness]
                             params:[eLongAccountCustomerRequestModel getCustomersWithCardNo:cardNo CustomerType:type PageIndex:index PageSize:size]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)setVerifyStatus:(BOOL)status{

    if (status) {
        self.userModel.verifyStatus = @"1";
    }else{
        self.userModel.verifyStatus = @"0";
    }
}

-(NSString *)verifyStatus{
    return self.userModel.verifyStatus;
}

#pragma mark
#pragma mark ------ReadOnly IMP
// 非会员卡号返回nil
-(NSString *)cardNo{
    if (numberFormatter) {
        if (self.userModel.CardNo) {
            return [self.userModel.CardNo stringValue];
        }else{
            NSString *cardNo = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_NUMBER];
            return (cardNo)?cardNo:nil;
        }
    }else{
        if (self.userModel.CardNo) {
            return [self.userModel.CardNo stringValue];
        }else{
            NSString *cardNo = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_NUMBER];
            return (cardNo)?cardNo:nil;
        }
    }
}

// 非会员卡号返回“0”
-(NSString *)getUserElongCardNO{
    NSString *cardNO = [self cardNo];
    return cardNO ? cardNO : @"0";
}

-(NSString *)phoneNo{
    return self.userModel.PhoneNo;
}

-(void)setName:(NSString *)name{
    self.userModel.Name = name;
}

-(NSString *)name{
    return self.userModel.Name;
}

-(void)setEmail:(NSString *)email{
    self.userModel.Email  = email;
}

-(NSString *)email{
    return self.userModel.Email;
}

-(NSInteger)cumulativePoints{
    return points;
}

-(void)setSex:(NSString *)sex{
    self.userModel.Sex = sex;
}

-(NSString *)sex{
    return self.userModel.Sex;
}

- (void)setNickName:(NSString *)nickName {
    self.userModel.NickName = nickName;
}

- (NSString *)nickName {
    return self.userModel.NickName;
}

- (void)setBirthday:(NSString *)birthday {
    self.userModel.Birthday = birthday;
}

- (NSString *)birthday {
    return self.userModel.Birthday;
}

- (void)setImageUrl:(NSString *)imageUrl {
    self.userModel.ImageUrl = imageUrl;
}

- (NSString *)imageUrl {
    return self.userModel.ImageUrl;
}



-(BOOL)isDragonMember{
    
    if (_userLevel == 2) {
        return YES;
    }else{
        if ([self cardNo]) {
            id object = [[NSUserDefaults standardUserDefaults] objectForKey:[self cardNo]];
            if (object && [object integerValue] == 2) {
                return YES;
            }
        }
        return NO;
    }
}

-(BOOL)isLogin{
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults] objectForKey:SESSION_TOKEN];
    NSString *cardNo = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_NUMBER];
    return ([cardNo notEmpty] && [sessionToken notEmpty]) ? YES : NO;
}

-(BOOL)isAdjustLogin{
    BOOL islogin = [self isLogin];
    if (islogin){
        if (_isNonmemberFlow){
            return NO;
        }else{
            return YES;
        }
    }else{
        return NO;
    }
}

#pragma mark - 用户等级信息
/**
 *  等级Id
 */
- (NSString *)gradeId {
    return self.userRankInfoModel.gradeId;
}

/**
 *  等级名称
 */
- (NSString *)gradeName {
    return self.userRankInfoModel.gradeName;
}

/**
 *  等级昵称
 */
- (NSString *)gradeNickname {
    return self.userRankInfoModel.gradeNickname;
}

/**
 *  总共的经验值
 */
- (long)expTotal {
    return self.userRankInfoModel.expTotal;
}

/**
 *  总共可用的经验值
 */
- (long)expAvailiable {
    return self.userRankInfoModel.expAvailiable;
}

/**
 *  该等级最大经验值
 */
- (long)maxExp {
    return self.userRankInfoModel.maxExp;
}

/**
 *  代理信息 该字段请app保存，签到等接口会需要其作为入参
 */
- (NSString *)proxy {
    if (self.userRankInfoModel.proxy) {
        return self.userRankInfoModel.proxy;
    }
    else {
        return self.userModel.Proxy;
    }
}

/**
 *  是否是代理用户 该字段用于判断是否显示会员俱乐部入口
 */
- (BOOL)isProxyType {
    return self.userRankInfoModel.isProxy;
}

- (BOOL)isHasUserRankInfo {
    if (self.userRankInfoModel) {
        return YES;
    }
    return NO;
}
- (NSInteger)giftSet {
    return self.userRankInfoModel.giftSet;
}

@end
