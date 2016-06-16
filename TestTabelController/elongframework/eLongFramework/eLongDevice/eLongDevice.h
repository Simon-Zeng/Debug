//
//  eLongDevice.h
//  eLongFramework
//
//  Created by zhaoyingze on 15/10/29.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface eLongDevice : NSObject

/**
 *  判断当前设备是否支持touch id功能
 *
 *  @return 支持返回YES，否则返回NO
 */
+ (BOOL)isSupportTouchID;

/**
 *  判断是否设置过touch id用于支付
 *
 *  @param cardNo   艺龙卡号
 *  @param callback 回调 已经设置，hasSet值为YES，否则为NO
 */
+ (void)hasSetTouchIdForPayment:(NSString *)cardNo callback:(void (^)(BOOL hasSet))callback;

/**
 *  获取touch id开关的状态（支付）
 *
 *  @param    cardNo 艺龙卡号
 *  @callback 回调 开关打开，isOpen值为YES，否则为NO，没设置过也为NO
 */
+ (void)getStatusOfTouchIdForPayment:(NSString *)cardNo callback:(void (^)(BOOL isOpen))callback;

/**
 *  设置touch id开关状态
 *
 *  @param status   开关状态，开传YES，否则传NO
 *  @param cardNo   艺龙卡号
 *  @param callback 回调，设置成功isSuccess为YES，否则为NO，isOpen为设置后开关状态，开关打开，isOpen值为YES，否则为NO，没设置过也为NO
 *
 */
+ (void)setStatusOfTouchIdForPayment:(BOOL)status cardNo:(NSString *)cardNo callback:(void (^)(BOOL isSuccess, BOOL isOpen))callback;

@end
