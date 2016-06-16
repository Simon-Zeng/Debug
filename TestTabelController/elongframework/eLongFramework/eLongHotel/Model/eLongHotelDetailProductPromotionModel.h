//
//  HotelDetailProductPromotion.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongHotelDetailFullCutModel.h"
#import <UIKit/UIKit.h>


@protocol eLongHotelDetailProductPromotionModel @end
@interface eLongHotelDetailProductPromotionModel : eLongResponseBaseModel
/**
 *  Id
 */
@property (nonatomic,assign) NSInteger Id;
/**
 *  促销类型1:coupon 9:coupon立减 10:红包返现 11:红包立减 13:如家红包 14、15:首晚五折
 */
@property (nonatomic,assign) NSInteger Type;
/**
 *  使用上限
 */
@property (nonatomic,assign) CGFloat UpperLimit;
/**
 *  真实消费券上线每个间夜这个数值为真实的消费券上线值
 */
@property (nonatomic,assign) CGFloat TrueUpperlimit;

/**
 *  首晚五折折扣率，如50代表5折，60代表6折
 */
@property (nonatomic,assign) CGFloat DiscountRate;
/**
 *  满减信息
 */
@property (nonatomic,strong) eLongHotelDetailFullCutModel<eLongHotelDetailFullCutModel> *FullCutDesc;
@end
