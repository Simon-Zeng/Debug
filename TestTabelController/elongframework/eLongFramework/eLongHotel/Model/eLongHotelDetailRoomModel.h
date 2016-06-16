//
//  eLongHotelDetailRoomModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongHotelDetailRoomAdditionModel.h"

@interface eLongHotelDetailRoomModel : eLongResponseBaseModel
/**
 *  房型Id
 */
@property (nonatomic,copy) NSString *RoomId;
/**
 *  房型名称
 */
@property (nonatomic,copy) NSString *Name;
/**
 *  房型封面图
 */
@property (nonatomic,copy) NSString *CoverImageUrl;
/**
 *  房型图列表
 */
@property (nonatomic,strong) NSArray *ImageList;
/**
 *  房型附加信息清单 personnum :可入住人数,roomtype:房间类型
 */
@property (nonatomic,strong) NSArray<eLongHotelDetailRoomAdditionModel> *AdditionInfoList;
@end
