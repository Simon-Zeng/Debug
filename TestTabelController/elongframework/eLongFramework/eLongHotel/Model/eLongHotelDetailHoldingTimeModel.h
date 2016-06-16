//
//  eLongHotelDetailHoldingTimeModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongHotelDetailHoldingTimeModel @end
@interface eLongHotelDetailHoldingTimeModel : eLongResponseBaseModel
/**
 *  显示时间
 */
@property (nonatomic,copy) NSString *ShowTime;
/**
 *  最早到店时间
 */
@property (nonatomic,copy) NSString *ArriveTimeEarly;
/**
 *  最晚到店时间
 */
@property (nonatomic,copy) NSString *ArriveTimeLate;
/**
 *  所选的时间段是否需要担保
 */
@property (nonatomic,assign) BOOL NeedVouch;
/**
 *  无风险取消订单时间
 */
@property (nonatomic,copy) NSString *NoPunishmentCancelTime;
/**
 *  是否默认选项
 */
@property (nonatomic,assign) BOOL IsDefault;
@end
