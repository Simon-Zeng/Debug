//
//  MyElongCashAccountReq.h
//  ElongClient
//
//  Created by 赵 海波 on 13-7-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum
{
    BizTypeMyelong = 0,                     // myelong
    BizTypeWithdraw = 1,                    // 提现
    BizTypeMobileCharges = 2,               // 手机充值
    BizTypeDomesticGuaranteeHotel = 1001,   // 国内担保酒店
    BizTypeFilghts = 1002,                  // 机票
    BizTypeInternationalHotel = 1003,       // 国际酒店
    BizTypeDomesticPrepayHotel = 1005,      // 预付酒店
    BizTypeGroupon = 1006,                  // 团购
    BizTypeTrain = 1022                     // 火车票
}BizType;       // 业务类型

@interface eLongCashAccountReq : NSObject

@property (nonatomic, assign) BOOL needPassword;            // 现金账户是否需要支付密码
@property (nonatomic, assign) CGFloat cashAccountRemain;    // 现金账户余额

+ (id)shared;
+ (NSString *)javaCashAmountByBizType:(BizType)type;         // 请求现金账户余额，是否可用
//+ (NSDictionary *)RequestDicCashAmountByBizType:(BizType)type;

+ (NSDictionary *)javaDictCashAmountByBizeType:(BizType)type;
//+ (NSDictionary *)RequestictCashAmountByBizeType:(BizType)type;

+ (NSString *)javaCashAmountByBizType:(BizType)type andOrderPrice:(NSString *)price;     // 请求现金账户余额（可返回红包余额）

+ (NSString *)javaRechargeVCode;                             // 请求礼品卡充值验证码
+ (NSDictionary *)javaDictionaryRechargeVCode;               // 请求礼品卡充值验证码字典

+ (NSString *)verifyRechargeCheckCodeWithCode:(NSString *)code;         // 验证礼品卡充值验证码

+ (NSString *)javaNewGiftCardRecharge:(NSString *)cardNO
                          GiftCardPwd:(NSString *)password
                            GraphCode:(NSString *)checkCode;      // 礼品卡充值
+ (NSDictionary *)javaDictionaryNewGiftCardRecharge:(NSString *)cardNO
                                        GiftCardPwd:(NSString *)password
                                          GraphCode:(NSString *)checkCode;// 礼品卡充值字典

+ (NSString *)javaVerifyCashAccountPwdWithPwd:(NSString *)password;         // 验证CA支付密码
+ (NSString *)javaIncomeRecord;

+ (NSString *)javaSendCheckCodeSmsWithMobileNo:(NSString *)mobile;          // 发送短信验证码
+ (NSDictionary *)javaSendCheckCodeSmsDictionaryWithMobileNo:(NSString *)mobile;

+ (NSString *)javaVerifySmsCheckCodeWithMobileNo:(NSString *)mobile Code:(NSString *)code;  // 校验短信验证码
+ (NSDictionary *)javaVerifySmsCheckCodeDictionaryWithMobileNo:(NSString *)mobile Code:(NSString *)code;

+ (NSString *)javaSetCashAccountPwdWithPwd:(NSString *)password
                                    NewPwd:(NSString *)newPassword
                                   SetType:(int)type;                // 设置支付密码
+ (NSDictionary *)javaSetCashAccountPwdDictionaryWithPwd:(NSString *)password
                                                  NewPwd:(NSString *)newPassword
                                                 SetType:(int)type;


+ (NSString *)getCashAmountUsageDetailReq;                       // 获取ca余额详情
+(NSDictionary *)dicCashAmountByBizType:(BizType)type;  // // 请求现金账户余额，是否可用，适应新的网络框架，返回字典
/*!
 *  获取账户详情
 *
 *  @param type    主类型      0:全部 1:CA 2:预付卡 3:红包
 *  @param subType 子类型   0:全部 1:收入 2:支出
 *
 *  @return json 字符串
 */
+(NSString *)getAccountRecordByType:(NSString *)type SubType:(NSString *)subType;
+(NSDictionary *)getAccountRecordDictionaryByType:(NSString *)type SubType:(NSString *)subType;

@end
