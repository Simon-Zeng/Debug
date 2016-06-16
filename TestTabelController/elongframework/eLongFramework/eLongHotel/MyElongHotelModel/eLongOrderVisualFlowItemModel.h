//
//  eLongOrderVisualFlowItemModel.h
//  ElongClient
//
//  Created by yangfan on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongOrderVisualFlowItemModel @end

@interface eLongOrderVisualFlowItemModel : eLongResponseBaseModel
/**
 *  订单流阶段
 */
@property (nonatomic, copy) NSString * FlowDesc;
/**
 *  订单当前所在的阶段
 */
@property (nonatomic, assign) BOOL IsCurrentFlow;
@end
