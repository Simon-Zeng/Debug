//
//  eLongBackOrDiscount.h
//  MyElong
//
//  Created by lvyue on 15/6/16.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongResponseBaseModel.h"

@interface eLongBackOrDiscount : eLongResponseBaseModel
/*
 *  返现多少
 */
@property (nonatomic,assign) float BackMoney;
/*
 *  立减多少
 */
@property (nonatomic,assign) float DiscountMoney;

@end
