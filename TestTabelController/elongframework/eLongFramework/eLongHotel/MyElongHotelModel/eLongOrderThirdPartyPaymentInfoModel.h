//
//  eLongOrderThirdPartyPaymentInfoModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongOrderThirdPartyPaymentInfoModel @end

@interface eLongOrderThirdPartyPaymentInfoModel : eLongResponseBaseModel
/**
 *  交易提供商
 */
@property (nonatomic, assign) NSInteger PaymentProviderId;
/**
 *  交易金额
 */
@property (nonatomic, assign) double PaymentAmount;
/**
 *  操作类型（3：退款 4：扣款）
 */
@property (nonatomic, assign) NSInteger OperationType;
/**
 *  状态（0：未处理 1：成功 2：处理中 3：失败）
 */
@property (nonatomic, assign) NSInteger Status;
/**
 *  客人手续费
 */
@property (nonatomic, assign) double CustomerServiceAmount;
/**
 *  第三方支付交易币种
 */
@property (nonatomic, assign) NSInteger Currency;
/**
 *  支付类型
 */
@property (nonatomic, assign) NSInteger PaymentMethod;
/**
 *  扣款成功回调URL
 */
@property (nonatomic, copy) NSString * ReturnUrl;
/**
 *  取消支付URL
 */
@property (nonatomic, copy) NSString * CancelUrl;
/**
 *  预订的产品名称
 */
@property (nonatomic, copy) NSString * Subject;
/**
 *  预订的产品说明
 */
@property (nonatomic, copy) NSString * Body;
/**
 *  请求时间
 */
@property (nonatomic, copy) NSString * Requestdate;

@end
