//
//  eLongHotelDetailVouchSetModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@interface eLongHotelDetailVouchSetModel : eLongResponseBaseModel
/**
 *  是否到店时间担保
 */
@property (nonatomic,assign) BOOL IsArriveTimeVouch;
/**
 *  是否房量担保
 */
@property (nonatomic,assign) BOOL IsRoomCountVouch;
/**
 *  是否日期担保:无0，预定日1，住店期间2，入住日3
 */
@property (nonatomic,assign) NSInteger DateType;
/**
 *  担保有效的最晚到店时间
 */
@property (nonatomic,copy) NSString *ArriveEndTime;
/**
 *  担保有效的最早到店时间
 */
@property (nonatomic,copy) NSString *ArriveStartTime;
/**
 *  担保有效的开始日期
 */
@property (nonatomic,copy) NSString *StartDate;
/**
 *  担保有效的结束日期
 */
@property (nonatomic,copy) NSString *EndDate;
/**
 *  担保有效的房量
 */
@property (nonatomic,assign) NSInteger RoomCount;
/**
 *  担保金额类型：首晚房间1，全部房价2
 */
@property (nonatomic,assign) NSInteger VouchMoneyType;
/**
 *  担保条件描述
 */
@property (nonatomic,copy) NSString *Descrition;
/**
 *  有效担保周，从周一到周日（注意底层接口是从周日到周六）
 */
@property (nonatomic,strong) NSArray *IsWeekEffective;

@end
