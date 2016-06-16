//
//  eLongOrderRefundOperationTraceGroup.h
//  ElongClient
//
//  Created by lvyue on 15/4/7.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongRefundOrderStateOperationTrace.h"

@protocol eLongOrderRefundOperationTraceGroup@end
@interface eLongOrderRefundOperationTraceGroup : eLongResponseBaseModel
/**
 *  支付类型,1-现金，2-信用卡，3-网银，4-快捷
 */
@property (nonatomic, assign)RefundWay OperationType;
/**
 *  退款交易明细列表,退款状态可视化中交易明细
 */
@property (nonatomic, strong)NSArray <eLongRefundOrderStateOperationTrace>*RefundOperationTraceList;
@end
