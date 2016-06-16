//
//  eLongHotelDetailProductDayPriceModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>


@protocol eLongHotelDetailProductDayPriceModel @end
@interface eLongHotelDetailProductDayPriceModel : eLongResponseBaseModel
/**
 *  日期
 */
@property (nonatomic,copy) NSString *Date;
/**
 *  价格
 */
@property (nonatomic,assign) CGFloat Price;
/**
 *  早餐
 */
@property (nonatomic,assign) BOOL HasBreakFast;
/**
 *  早餐数量
 */
@property (nonatomic,assign) NSInteger BreakFastNumber;
/**
 *  价格（计算汇率后RMB）
 */
@property (nonatomic,assign) CGFloat RmbPrice;
@end
