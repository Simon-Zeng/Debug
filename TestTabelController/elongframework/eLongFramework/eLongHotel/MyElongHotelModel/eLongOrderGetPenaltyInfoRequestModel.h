//
//  eLongOrderGetPenaltyInfoRequestModel.h
//  ElongClient
//
//  Created by zhaolina on 15/7/9.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongOrderGetPenaltyInfoRequestModel : eLongRequestBaseModel
/**
 *  订单号
 */
@property (nonatomic,copy) NSString *orderId;
/**
 *  取消的时间, yyyy-MM-dd HH:mm:ss（如果不传则取服务器当前时间）
 */
@property (nonatomic,copy) NSString *cancelTime;
/**
 *  0 现付；1 预付
 */
@property (nonatomic,assign) NSInteger payment;
/**
 *  担保类型（将可取消订单列表中的vouchSetCode传回即可）
 */
@property (nonatomic,assign) NSInteger vouchSetCode;
/**
 *  订单状态（将可取消订单列表中的stateCode传回即可）
 */
@property (nonatomic,copy) NSString *stateCode;
@end
