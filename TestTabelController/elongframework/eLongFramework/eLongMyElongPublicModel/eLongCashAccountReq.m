//
//  MyElongCashAccountReq.m
//  ElongClient
//  现金账户请求
//
//  Created by 赵 海波 on 13-7-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "eLongCashAccountReq.h"
#import "eLongPostHeader.h"
#import "eLongCashAccountConfig.h"
#import "eLongHTTPEncryption.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
#import "eLongAccountManager.h"
#import "eLongDefine.h"
#import "eLongCommonDefine.h"
#import "eLongFileDefine.h"

static eLongCashAccountReq *request = nil;
#define orderPrice_API                  @"orderPrice"

@implementation eLongCashAccountReq

+ (id)shared
{
    @synchronized(request)
    {
		if (!request)
        {
			request = [[eLongCashAccountReq alloc] init];
		}
	}
	
	return request;
}


+ (NSString *)javaCashAmountByBizType:(BizType)type{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
	[content safeSetObject:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)RequestDicCashAmountByBizType:(BizType)type{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
    [content safeSetObject:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
    return content;
}

+(NSDictionary *)dicCashAmountByBizType:(BizType)type
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
    [content safeSetObject:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
    return content;
}

+ (NSString *)javaCashAmountByBizType:(BizType)type andOrderPrice:(NSString *)price{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
	[content safeSetObject:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
    [content safeSetObject:price forKey:orderPrice_API];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaDictCashAmountByBizeType:(BizType)type{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
    [content safeSetObject:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
    return content;
}

+ (NSString *)javaRechargeVCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaDictionaryRechargeVCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    return content;
}

+ (NSString *)verifyRechargeCheckCodeWithCode:(NSString *)code
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[eLongPostHeader header] forKey:Resq_Header];
	[content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    [content safeSetObject:code forKey:CODE];
	
	return [NSString stringWithFormat:@"action=VerifyRechargeCheckCode&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)javaNewGiftCardRecharge:(NSString *)cardNO GiftCardPwd:(NSString *)password GraphCode:(NSString *)checkCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:[eLongHTTPEncryption encryptString:cardNO] forKey:GIFT_CARD_NO];
    [content safeSetObject:[eLongHTTPEncryption encryptString:password] forKey:GIFT_CARD_PWD];
    [content safeSetObject:checkCode forKey:GRAPH_CODE];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
	
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaDictionaryNewGiftCardRecharge:(NSString *)cardNO GiftCardPwd:(NSString *)password GraphCode:(NSString *)checkCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[eLongHTTPEncryption encryptString:cardNO] forKey:GIFT_CARD_NO];
    [content safeSetObject:[eLongHTTPEncryption encryptString:password] forKey:GIFT_CARD_PWD];
    [content safeSetObject:checkCode forKey:GRAPH_CODE];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
    
    return content;
}


+ (NSString *)javaVerifyCashAccountPwdWithPwd:(NSString *)password
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[eLongHTTPEncryption encryptString:password] forKey:PWD];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}


+ (NSString *)javaIncomeRecord
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    [content safeSetObject:@"256" forKey:@"PageSize"];
    [content safeSetObject:@"0" forKey:@"PageIndex"];
    [content safeSetObject:[NSNull null] forKey:@"Pwd"];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+(NSString *)getAccountRecordByType:(NSString *)type SubType:(NSString *)subType
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:type forKey:@"accountType"];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"cardNumber"];
    [content safeSetObject:subType forKey:@"incomeAndExpensesType"];
    [content safeSetObject:@"256" forKey:@"pageSize"];
    [content safeSetObject:@"0" forKey:@"pageIndex"];
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+(NSDictionary *)getAccountRecordDictionaryByType:(NSString *)type SubType:(NSString *)subType
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:type forKey:@"accountType"];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"cardNumber"];
    [content safeSetObject:subType forKey:@"incomeAndExpensesType"];
    [content safeSetObject:@"256" forKey:@"pageSize"];
    [content safeSetObject:@"0" forKey:@"pageIndex"];
    return content;
}

+ (NSString *)javaSendCheckCodeSmsWithMobileNo:(NSString *)mobile
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:mobile forKey:MOBILE_NO];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
	
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaSendCheckCodeSmsDictionaryWithMobileNo:(NSString *)mobile
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:mobile forKey:MOBILE_NO];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    
    return content;
}

+ (NSString *)javaVerifySmsCheckCodeWithMobileNo:(NSString *)mobile Code:(NSString *)code
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
	[content safeSetObject:mobile forKey:MOBILE_NO];
    [content safeSetObject:code forKey:CODE];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
	
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaVerifySmsCheckCodeDictionaryWithMobileNo:(NSString *)mobile Code:(NSString *)code
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:mobile forKey:MOBILE_NO];
    [content safeSetObject:code forKey:CODE];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    
    return content;
}

+ (NSString *)javaSetCashAccountPwdWithPwd:(NSString *)password NewPwd:(NSString *)newPassword SetType:(int)type
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[NSString stringWithFormat:@"%d", type] forKey:SETTYPE];
    [content safeSetObject:[eLongHTTPEncryption encryptString:password] forKey:PWD];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    
    return [eLongNetworkSerialization jsonStringWithObject:content];
}

+ (NSDictionary *)javaSetCashAccountPwdDictionaryWithPwd:(NSString *)password NewPwd:(NSString *)newPassword SetType:(int)type
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[NSString stringWithFormat:@"%d", type] forKey:SETTYPE];
    [content safeSetObject:[eLongHTTPEncryption encryptString:password] forKey:PWD];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:CARD_NUMBER];
    
    return content;
}


+ (NSString *)getCashAmountUsageDetailReq
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[eLongPostHeader header] forKey:Resq_Header];
    [content safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:MEMBER_CARD_NO];
	
	return [NSString stringWithFormat:@"action=GetCashAmountUsageDetail&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


@end
