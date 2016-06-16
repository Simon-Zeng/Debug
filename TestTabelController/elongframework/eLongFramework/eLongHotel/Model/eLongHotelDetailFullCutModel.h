//
//  HotelDetailFullCutModel.h
//  ElongClient
//
//  Created by Ligang.Jing on 15/4/17.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import <UIKit/UIKit.h>

@protocol eLongHotelDetailFullCutModel @end
@interface eLongHotelDetailFullCutModel : eLongResponseBaseModel

// 满多少金额
@property (nonatomic,assign) CGFloat FullAmount;

// 减多少的金额
@property (nonatomic,assign) CGFloat CutAmount;

// 上限值
@property (nonatomic,assign) CGFloat UpperLimit;

// 优惠金额
@property (nonatomic,assign) CGFloat OffAmount;


@end
