//
//  eLongHotelDetailPriceModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>

@interface eLongHotelDetailPriceModel : eLongResponseBaseModel
/**
 *  均价
 */
@property (nonatomic,assign) CGFloat AveragePrice;
/**
 *  减后价的均价
 */
@property (nonatomic,assign) CGFloat AveragePriceSubTotal;
/**
 *  首日价
 */
@property (nonatomic,assign) CGFloat FirstDayPrice;
/**
 *  总价
 */
@property (nonatomic,assign) CGFloat TotalPrice;
/**
 *  原价
 */
@property (nonatomic,assign) CGFloat OriginalPrice;
/**
 *  龙翠原价
 */
@property (nonatomic,assign) CGFloat LongCuiOriginalPrice;
/**
 *  客人类型: 1:统一价、2:内宾价、 3:外宾价 、4:港澳台客人价、5:日本客人价
 */
@property (nonatomic,assign) NSInteger GuestType;
/**
 *  币种
 */
@property (nonatomic,copy) NSString *Currency;
/**
 *  转换成人民币的汇率, -1,0: 汇率异常 这种情况建议还是展示原币种 >0:当前币种转换成人民币的汇率 计算方式：当前价格X汇率
 */
@property (nonatomic,assign) CGFloat ExchangeRate;
/**
 *  首日价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat FirstDayPriceRmb;
/**
 *  均价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat AveragePriceRmb;
/**
 *  总价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat TotalPriceRmb;
/**
 *  原价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat OriginalPriceRmb;
/**
 *  龙翠原价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat LongCuiOriginalPriceRmb;
@end
