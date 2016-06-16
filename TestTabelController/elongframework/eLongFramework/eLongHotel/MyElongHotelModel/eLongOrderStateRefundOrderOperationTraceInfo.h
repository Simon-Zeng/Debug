//
//  eLongOrderStateRefundOrderOperationTraceInfo.h
//  ElongClient
//
//  Created by lvyue on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongResponseBaseModel.h"
#import "eLongOrderRefundOperationTraceGroup.h"

@protocol eLongOrderStateRefundOrderOperationTraceInfo@end
@interface eLongOrderStateRefundOrderOperationTraceInfo : eLongResponseBaseModel
/**
 *  退款状态描述
 */
@property (nonatomic,copy) NSString *RefundStatusDesc;
/**
 *  退款金额差异小提示
 */
@property (nonatomic,copy) NSString *AmountTips;
/**
 *  退款交易明细列表,退款状态可视化中交易明细
 */
@property (nonatomic,copy) NSArray <eLongOrderRefundOperationTraceGroup>*RefundOperationTraceGroupList;

/**
 *  ("是否担保,true为担保，false为退款")
 */
@property (nonatomic, assign)BOOL IsVouch;
@end
