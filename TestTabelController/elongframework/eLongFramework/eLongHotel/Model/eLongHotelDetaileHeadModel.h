//
//  eLongHotelDetaileHeadModel.h
//  ElongClient
//
//  Created by nieyun on 15-1-23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>
#import "eLongLocation.h"

@interface eLongHotelDetaileHeadModel : eLongResponseBaseModel

/**
 *  存储需要在详情页提前展示的信息，在酒店详情尚未获取之前可以展示在详情页的信息
 */
/**
 *  酒店图片
 */
@property (nonatomic,copy) NSString *PicUrl;
/**
 *  酒店名
 */
@property (nonatomic,copy) NSString *HotelName;
/**
 *  酒店星级
 */


@property (nonatomic,assign) NSInteger NewStarCode;
/**
 *  酒店地址
 */
@property (nonatomic,copy) NSString *Address;
/**
 *  酒店地理坐标
 */

@property  (nonatomic,assign) CGFloat  Latitude;

@property  (nonatomic,assign) CGFloat  Longitude;
/**
 *  自己算出来的属性
 */
@property (nonatomic,assign) CLLocationCoordinate2D hotelLocation;
/**
 *  酒店设施编码
 */
@property (nonatomic,assign) long HotelFacilityCode;
/**
 *  酒店好评率
 */
@property (nonatomic,assign) CGFloat CommentPoint;
/**
 *  酒店好评数量
 */
@property (nonatomic,assign) NSInteger GoodCommentCount;
/**
 *  酒店差评数
 */
@property (nonatomic,assign) NSInteger BadCommentCount;
/**
 *  PSG推荐信息，如果没有请设置为nil
 */
@property (nonatomic,copy) NSString *PSGRecommendReason;
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
@end
