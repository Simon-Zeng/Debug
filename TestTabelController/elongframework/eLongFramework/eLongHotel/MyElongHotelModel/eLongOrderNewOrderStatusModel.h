//
//  eLongOrderNewOrderStatusModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongOrderNewOrderStatusActionModel.h"

@protocol eLongOrderNewOrderStatusModel @end
@interface eLongOrderNewOrderStatusModel : eLongResponseBaseModel
/**
 *  该状态对应的操作
 */
@property (nonatomic, strong) NSArray<eLongOrderNewOrderStatusActionModel> * Actions;
/**
 *  该状态给用户的提示信息
 */
@property (nonatomic, copy) NSString * Tip;
/**
 *  是否为未支付订单
 */
@property (nonatomic, assign) BOOL isNonPaymentOrder;


@end
