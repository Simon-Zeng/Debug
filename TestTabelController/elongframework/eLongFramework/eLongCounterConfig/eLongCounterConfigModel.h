//
//  eLongCounterConfigModel.h
//  eLongFramework
//
//  Created by zhaoyingze on 15/11/10.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCounterConfigModel : NSObject

/**
 *  渠道号，默认为9106，9103-安卓艺龙旅行, 9106-IPHONE艺龙旅行, 9108-手机HTML5, 9110-Winphone艺龙旅行
 */
@property (nonatomic, retain) NSNumber *channelType;

/**
 *  语言，默认为7801，7801：中文；7802：英文
 */
@property (nonatomic, retain) NSNumber *language;

/**
 *  会员类型，默认为0， 0:艺龙会员 1:公寓会员
 */
@property (nonatomic, retain) NSNumber *memberSource;


/*************************** 微信支付相关配置 ************************/
/**
 *  强制隐藏微信支付，默认值为NO
 */
@property (nonatomic, assign) BOOL disableWeChatPay;

/**
 *  app的URL Scheme，调用微信SDK时使用，默认值为：elongIPhone
 */
@property (nonatomic, copy) NSString *schemeForWeChat;

/**
 *  微信支付产品的productSubCode，需从payment获取，默认值为4311
 */
@property (nonatomic, copy) NSString *subCodeForWechat;

/**
 *  强制隐藏微信朋友代付，默认值为NO
 */
@property (nonatomic, assign) BOOL disableWeChatFriendPay;

/**
 *  微信朋友代付产品的productSubCode，需从payment获取，默认值为4316
 */
@property (nonatomic, copy) NSString *subCodeForWechatFriendPay;


/*************************** 支付宝支付相关配置 ************************/
/**
 *  app的URL Scheme，调用支付宝SDK时使用，默认值为：elongIPhone
 */
@property (nonatomic, copy) NSString *appScheme;

/**
 *  强制隐藏支付宝支付，默认值为NO
 */
@property (nonatomic, assign) BOOL disableAliPay;


/*************************** QQ钱包支付相关配置 ************************/
/**
 *  app的URL Scheme，调用QQ钱包SDK时使用，默认值为：eLongForQQWallet
 */
@property (nonatomic, copy) NSString *schemeForQQWallet;

/**
 *  强制隐藏QQ钱包支付，默认值为NO
 */
@property (nonatomic, assign) BOOL disableQQWalletPay;

/*************************** 一网通支付相关配置 ************************/

/**
 *  强制隐藏一网通支付，默认值为NO
 */
@property (nonatomic, assign) BOOL disableCMBPay;

/*************************** ApplePay相关配置 ************************/
/**
 *  ApplePay的merchantId
 */
@property (nonatomic, copy) NSString *merchantId;

/**
 *  强制隐藏ApplePay，默认值为NO
 */
@property (nonatomic, assign) BOOL disableApplePay;


+ (id)shared;

@end
