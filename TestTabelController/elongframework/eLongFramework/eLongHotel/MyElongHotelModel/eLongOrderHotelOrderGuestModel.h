//
//  eLongOrderHotelOrderGuestModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongOrderHotelOrderGuestModel @end

@interface eLongOrderHotelOrderGuestModel : eLongResponseBaseModel
/**
 *  入住人
 */
@property (nonatomic, copy) NSString * Name;
/**
 *  国家
 */
@property (nonatomic, copy) NSString * Country;
/**
 *  房间ID
 */
@property (nonatomic, assign) NSInteger OrderItemID;

@end
