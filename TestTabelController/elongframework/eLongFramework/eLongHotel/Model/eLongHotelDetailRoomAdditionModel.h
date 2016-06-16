//
//  eLongHotelDetailRoomAdditionModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongHotelDetailRoomAdditionModel @end
@interface eLongHotelDetailRoomAdditionModel : eLongResponseBaseModel
/**
 *  索引
 */
@property (nonatomic,copy) NSString *Key;
/**
 *  描述
 */
@property (nonatomic,copy) NSString *Desp;
/**
 *  内容
 */
@property (nonatomic,copy) NSString *Content;
@end
