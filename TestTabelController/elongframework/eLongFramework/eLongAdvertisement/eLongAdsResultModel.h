//
//  eLongAdsResultModel.h
//  eLongFramework
//
//  Created by Ning.liu on 15/8/17.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//


#import "eLongResponseBaseModel.h"
#import "eLongAdvInfoModel.h"
#import "eLongAdPageResultModel.h"


@interface eLongAdsResultModel : eLongResponseBaseModel
/**
 *  轮播广告
 */
@property (nonatomic,strong) NSArray<eLongAdvInfoModel> *arounds;
/**
 *  酒店磁贴
 */
@property (nonatomic,strong) eLongAdvInfoModel *hotelStick;
/**
 *  机票磁贴
 */
@property (nonatomic,strong) eLongAdvInfoModel *flightStick;
/**
 *  团购磁贴
 */
@property (nonatomic,strong) eLongAdvInfoModel *tuanStick;
/**
 *  页面(一般情况都是从这里取)
 */
@property (nonatomic,strong) NSArray<eLongAdPageResultModel> *pages;


@end
