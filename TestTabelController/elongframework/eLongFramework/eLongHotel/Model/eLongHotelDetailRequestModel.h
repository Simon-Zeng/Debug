//
//  eLongHotelDetailRequestModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongHotelDetailRequestModel : eLongRequestBaseModel
/**
 *  酒店 Id
 */
@property (nonatomic,copy) NSString *hotelId;
/**
 *  入住日期
 */
@property (nonatomic,copy) NSString *checkInDate;
/**
 *  离店日期
 */
@property (nonatomic,copy) NSString *checkOutDate;
/**
 *  是否是未签约酒店
 */
@property (nonatomic,assign) BOOL isUnsigned;
/**
 *  是否周边特价
 */
@property (nonatomic,assign) BOOL isAroundSale;

@end
