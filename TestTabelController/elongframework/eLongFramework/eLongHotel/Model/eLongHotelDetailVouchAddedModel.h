//
//  eLongHotelDetailVouchAddedModel.h
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>

@interface eLongHotelDetailVouchAddedModel : eLongResponseBaseModel
/**
 *  罚金金额
 */
@property (nonatomic,assign) CGFloat PunishAmount;
/**
 *  简化担保信息
 */
@property (nonatomic,copy) NSString *ShortedDescription;
/**
 *  罚金金额(计算汇率后RMB)
 */
@property (nonatomic,assign) CGFloat PunishAmountRmb;

@end
