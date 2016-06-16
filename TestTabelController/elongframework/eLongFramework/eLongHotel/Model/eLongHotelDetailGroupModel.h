//
//  eLongHotelDetailGroupModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongHotelDetailRoomModel.h"
#import "eLongHotelDetailProductModel.h"

@protocol eLongHotelDetailGroupModel @end
@interface eLongHotelDetailGroupModel : eLongResponseBaseModel
/**
 *  房型信息
 */
@property (nonatomic,strong) eLongHotelDetailRoomModel *RoomInfo;
/**
 *  产品信息
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailProductModel> *Products;
/**
 *  房型最低价
 */
@property (nonatomic,assign) CGFloat MinAveragePrice;
/**
 *  房型最低价(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat MinAveragePriceRmb;
/**
 *  减后价的房型最低价
 */
@property (nonatomic,assign) CGFloat MinAveragePriceSubTotal;
/**
 *  最低价房型的币种
 */
@property (nonatomic,copy) NSString *MinAveragePriceCurrency;
/**
 *  最低价房型转换成人民币的汇率, -1,0: 汇率异常 这种情况建议还是展示原币种 >0:当前币种转换成人民币的汇率 计算方式：当前价格X汇率
 */
@property (nonatomic,assign) CGFloat minAveragePriceExchangeRate;
/**
 *  是否有效
 */
@property (nonatomic,assign) BOOL available;
/**
 *  是否首晚五折
 */
@property (nonatomic,assign) BOOL IsFirstTimeHalf;
/**
 *  首晚五折显示标签
 */
@property (nonatomic,copy) NSString *FirstTimeHalfTag;
@end
