//
//  eLongRedPacketModel.h
//  eLongFramework
//
//  Created by 吕月 on 15/8/31.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongBaseModel.h"
#import "eLongResponseBaseModel.h"
@interface eLongRedPacketModel : eLongResponseBaseModel

/**
 *  酒店可用的激活红包数量
 */
@property (nonatomic,assign) NSInteger hotelActiveNumber;
/**
 *  酒店可用的激活红包金额
 */
@property (nonatomic,assign) CGFloat hotelActiveAmount;
/**
 *  如家可用的激活红包数量
 */
@property (nonatomic,assign) NSInteger rujiaHotelActiveNumber;
/**
 *  如家可用的激活红包金额
 */
@property (nonatomic,assign) CGFloat rujiaHotelActiveAmount;
/**
 *  铂涛可用的激活红包数量
 */
@property (nonatomic, assign) NSInteger boTaoHotelActiveNumber;
/**
 *  铂涛可用的激活红包金额
 */
@property (nonatomic, assign) CGFloat boTaoHotelActiveAmount;
/**
 *  火车票可用的激活红包数量
 */
@property (nonatomic,assign) NSInteger trainActiveNumber;
/**
 *  火车票可用的激活红包金额
 */
@property (nonatomic,assign) CGFloat trainActiveAmount;
/**
 *  未激酒店活红包数量
 */
@property (nonatomic,assign) NSInteger hotelUnactiveNumber;
/**
 *  未激酒店活红包金额
 */
@property (nonatomic,assign) CGFloat hotelUnactiveAmount;
/**
 *  未激活火车票活红包数量
 */
@property (nonatomic,assign) NSInteger trainUnactiveNumber;
/**
 *  未激活火车票红包金额
 */
@property (nonatomic,assign) CGFloat trainUnactiveAmount;
/**
 *  通用的激活红包数量
 */
@property (nonatomic,assign) NSInteger generalActiveNumber;
/**
 *  通用的激活红包金额
 */
@property (nonatomic,assign) CGFloat generalActiveAmount;
/**
 *  通用的未激活红包数量
 */
@property (nonatomic,assign) NSInteger generalUnactiveNumber;
/**
 *  通用的未激活红包金额
 */
@property (nonatomic,assign) CGFloat generalUnactiveAmount;
/**
 *  未登录用户是否有红包
 */
@property (nonatomic,assign) BOOL hasPrivilege;
/**
 *  将要过期的通用红包总金额
 */
@property (nonatomic,assign) CGFloat soonExpireAmountFee;
/**
 *  计算将要过期通用总金额的天数
 */
@property (nonatomic,assign) NSInteger days;
/**
 *  将要过期的酒店红包总金额
 */
@property (nonatomic,assign) CGFloat hotelSoonExpireAmountFee;
/**
 *  计算将要过期酒店总金额的天数
 */
@property (nonatomic,assign) NSInteger hotelDays;
/**
 *  将要过期的火车票红包总金额
 */
@property (nonatomic,assign) CGFloat trainSoonExpireAmountFee;
/**
 *  计算将要过期火车票红包的天数
 */
@property (nonatomic,assign) NSInteger trainDays;

- (void) reset;
- (id) initWithHongbaos:(NSDictionary *)hongbao;
@end


@interface elongHongBaoCountResponseModel : eLongResponseBaseModel

/**
 *  资产个数
 */
@property (nonatomic, assign) NSInteger count;

/**
 *  积分数
 */
@property (nonatomic, assign) NSInteger creditCount;

@end
