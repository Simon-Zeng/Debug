//
//  eLongOrderHotelContactorModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongOrderHotelContactorModel @end

@interface eLongOrderHotelContactorModel : eLongResponseBaseModel
/**
 *  酒店联系人姓名
 */
@property (nonatomic, copy) NSString * Name;
/**
 *  酒店联系人电话
 */
@property (nonatomic, copy) NSString * MobilePhone;
/**
 *  酒店联系人email
 */
@property (nonatomic, copy) NSString * Email;
@end
