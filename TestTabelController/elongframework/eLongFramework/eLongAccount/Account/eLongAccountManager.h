//
//  eLongAccountManager.h
//  ElongClient
//  艺龙账户系统管理类
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongAccountUserInstance.h"
#import "eLongAccountCAInstance.h"
#import "eLongAccountHongBaoInstance.h"
#import "eLongAccountOrdersInstance.h"
#import "eLongAccountredDotInstace.h"
#import "eLongAccountCustomerInfoListInstance.h"


@interface eLongAccountManager : NSObject
/**
 *  账户系统之用户基本信息
 *
 *  @return eLongAccountUserInstance
 */
+(eLongAccountUserInstance *)userInstance;
/**
 *  用户自身拥有的旅客信息，银行卡，发票抬头，邮寄地址，收藏信息，优惠信息列表，操作和获取类
 *
 *  @return eLongAccountCustomerInfoListInstance
 */
+(eLongAccountCustomerInfoListInstance *)customerInfoListInstance;
/**
 *  账户系统之用户CA账户
 *
 *  @return eLongAccountCAInstance
 */
+(eLongAccountCAInstance *)CAInstance;
/**
 *  账户系统之用户红包账户
 *
 *  @return eLongAccountHongBaoInstance
 */
+(eLongAccountHongBaoInstance *)hongBaoInstance;
/**
 *  账户系统之订单系统
 *
 *  @return eLongAccountOrdersInstance
 */
+(eLongAccountOrdersInstance *)ordersInstance;

/**
 *  系统内未读红点
 *
 *  @return redDotInstance
 */
+(eLongAccountredDotInstace *)redDotInstance;

@end
