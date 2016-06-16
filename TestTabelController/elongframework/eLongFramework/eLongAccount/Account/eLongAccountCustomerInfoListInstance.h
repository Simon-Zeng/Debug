//
//  eLongAccountCustomerInfoListInstance.h
//  eLongFramework
//
//  Created by 吕月 on 15/9/22.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongAccountInstanceBase.h"

@interface eLongAccountCustomerInfoListInstance : eLongAccountInstanceBase
/**
 *  修改的Index
 */
@property (nonatomic, assign) NSInteger customerIndex;
/**
 *  可修改可取值的常用旅客信息
 */
@property (nonatomic, copy) NSMutableArray *allUserInfo;

/**
 *  地址列表信息列表
 */
@property (nonatomic, copy)NSMutableArray *allAddressInfo;
/**
 *  发票抬头信息列表
 */
@property (nonatomic, copy)NSMutableArray *allInvoiceTitleInfo;

/**
 *  银行卡信息列表
 */
@property (nonatomic, copy)NSMutableArray *allCardsInfo;

/**
 *  Coupon信息列表
 */
@property (nonatomic, copy)NSMutableArray *allCouponInfo;
/**
 *  酒店收藏信息列表
 */
@property (nonatomic, copy)NSMutableArray *allHotelFInfo;

@end
