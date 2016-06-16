//
//  eLongHotelDetailPartialModel.h
//  ElongClient
//
//  Created by Kirn on 14-10-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//  存储需要在详情页提前展示的信息，在酒店详情尚未获取之前可以展示在详情页的信息 by 王曙光

#import <Foundation/Foundation.h>
#import "eLongLocation.h"

/**
 *  存储需要在详情页提前展示的信息，在酒店详情尚未获取之前可以展示在详情页的信息
 */
@interface eLongHotelDetailPartialModel : NSObject
/**
 *  酒店图片
 */
@property (nonatomic,copy) NSString *imageUrl;
/**
 *  酒店名
 */
@property (nonatomic,copy) NSString *hotelName;
/**
 *  酒店星级
 */
@property (nonatomic,assign) NSInteger starCode;
/**
 *  酒店地址
 */
@property (nonatomic,copy) NSString *hotelAddress;
/**
 *  酒店地理坐标
 */
@property (nonatomic,assign) CLLocationCoordinate2D hotelLocation;
/**
 *  酒店设施编码
 */
@property (nonatomic,assign) long hotelFacilityCode;
/**
 *  酒店好评率
 */
@property (nonatomic,assign) float commentPoint;
/**
 *  酒店好评数量
 */
@property (nonatomic,assign) NSInteger goodCommentCount;
/**
 *  酒店差评数
 */
@property (nonatomic,assign) NSInteger badCommentCount;
/**
 *  PSG推荐信息，如果没有请设置为nil
 */
@property (nonatomic,copy) NSString *psgInfo;

/**
 *  PSG图片展示标签
 */
@property (nonatomic,copy) NSString *psgTagInfo;

/**
 *  该酒店在列表中的位置，如果无法统计请设置为-1
 */
@property (nonatomic,assign) NSInteger positionIndex;
/**
 *  五折限购
 */
@property (nonatomic,copy) NSString* priceHalfTag;

/*
    公寓模块添加的icon展示
 */
@property (nonatomic, copy) NSString *apartmentMarkString;

/**
 *  酒店是否存在返现标志
 */
@property (nonatomic, assign) BOOL couponFlag;

/**
 *  折后价开关标识
 */
@property (nonatomic, assign) BOOL isShowCouponPrice;


@end
