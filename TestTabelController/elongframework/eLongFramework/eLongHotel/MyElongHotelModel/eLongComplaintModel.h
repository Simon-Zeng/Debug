//
//  eLongComplaintModel.h
//  ElongClient
//
//  Created by dayu on 15/7/11.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>

@protocol eLongComplaintModel <NSObject>
@end

@interface eLongComplaintModel : eLongResponseBaseModel

/**
 *  入住时间（5月28日）
 */
@property (nonatomic,copy) NSString *arriveDate;
/**
 *  申请ID
 */
@property (nonatomic,copy) NSString *complaintID;
/**
 *  最新申请进度
 */
@property (nonatomic,copy) NSString *complaintStatusName;
/**
 *  酒店名称
 */
@property (nonatomic,copy) NSString *hotelName;
/**
 *  离店时间（5月30日）
 */
@property (nonatomic,copy) NSString *leaveDate;
/**
 *  MHotelId
 */
@property (nonatomic,copy) NSString *mHotelId;
/**
 *  订单号
 */
@property (nonatomic,copy) NSString *orderID;
/**
 *  现付：0；预付：1
 */
@property (nonatomic,assign) NSInteger payment;
/**
 *  房型名称
 */
@property (nonatomic,copy) NSString *roomTypeName;
/**
 *  订单金额（rmb
 */
@property (nonatomic,assign) CGFloat sumPrice;
/**
 *  订单总返现金额
 */
@property (nonatomic,assign) CGFloat totalCashBackAmount;
/**
 *  订单总立减金额
 */
@property (nonatomic,assign) CGFloat totalDirectDiscountAmount;
/**
 * 房间数量
 */
@property (nonatomic,assign) CGFloat validBonusAmount;
/**
 *  coupon金额
 */
@property (nonatomic,assign) CGFloat validCouponAmount;
/**
 * 折扣金额
 */
@property (nonatomic,assign) CGFloat validDiscountAmount;
/**
 *  五折/八折金额
 */
@property (nonatomic,assign) CGFloat validDiscountPromotionAmount;
/**
 *  "代理类型编号"
 */
@property (nonatomic, copy) NSString *oTAProductSourceType;
/**
 *  "代理类型名称"
 */
@property (nonatomic, copy) NSString *oTAProductSourceName;
@end
