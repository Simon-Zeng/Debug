//
//  eLongAccountRedDotModel.h
//  ElongClient
//
//  Created by lvyue on 15/4/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "eLongRequestBaseModel.h"

@interface eLongAccountRedDotModel : eLongRequestBaseModel

/**
 *  酒店待付款订单数量判断值
 */
@property (nonatomic, assign) NSInteger baseNum;

/**
 *  酒店待付款订单数量
 */
@property (nonatomic, assign) NSInteger hotelPendingPaymentOrderNum;

/**
 *  有酒店订单反现按钮数量
 */
@property (nonatomic, assign) NSInteger hotelBackOrderNum;

/**
 *  可点评酒店订单数量
 */
@property (nonatomic, assign) NSInteger hotelCommentOrderNum;

/**
 *  未查看的点评数量
 */
@property (nonatomic, assign) NSInteger hotelNotCliekedCommentOrderNum;


@end
