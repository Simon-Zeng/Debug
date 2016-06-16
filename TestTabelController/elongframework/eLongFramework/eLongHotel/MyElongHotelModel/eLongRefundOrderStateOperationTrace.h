//
//  eLongRefundOrderStateOperationTrace.h
//  ElongClient
//
//  Created by lvyue on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

//1-现金，2-信用卡，3-网银，4-快捷
typedef NS_ENUM(NSInteger, RefundWay) {
    //以下是枚举成员
    RefundWayCreditCash = 1,
    RefundWayCreditCard = 2,
    RefundWayEbank = 3,
    RefundWayFaster = 4,
};

@protocol eLongRefundOrderStateOperationTrace@end

@interface eLongRefundOrderStateOperationTrace : eLongResponseBaseModel
/**
 *  操作时间
 */
@property (nonatomic,copy) NSString *OperationTime;
/**
 *  交易状态中文描述
 */
@property (nonatomic,copy) NSString *ResultStatusCn;
/**
 *  操作结果状态中文描述
 */
@property (nonatomic,copy) NSString *OperationResultDescCn;

/**
 *  支付类型,1-现金，2-信用卡，3-网银，4-快捷
 */
@property (nonatomic,assign) RefundWay OperationType;

@end
