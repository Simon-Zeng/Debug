//
//  eLongGetPenaltyInfoResponseModel.h
//  ElongClient
//
//  Created by zhaolina on 15/7/9.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongGetPenaltyInfoBtnModel.h"

@interface eLongGetPenaltyInfoResponseModel : eLongResponseBaseModel
/**
 *  订单号
 */
@property (nonatomic,copy) NSString *orderID;
/**
 *  按传入的时间取消产生的罚金
 */
@property (nonatomic,assign) double penaltyToCustomerForCancel;
/**
 *  结算类型，1 现付 2 预付 0 为现付非担保
 */
@property (nonatomic,assign) NSInteger settlementType;
/**
 *  支付状态，0 为不需要支付， 1为支付成功，2为支付未成功
 */
@property (nonatomic,assign) NSInteger paymentStatus;
/**
 *  点击取消按钮后弹出对话框话术
 */
@property (nonatomic,copy) NSString *message;
/**
 *  订单总价
 */
@property (nonatomic,copy) NSString *exchangeSumPrice;
/**
 *  按钮列表
 */
@property (nonatomic,strong) NSArray<eLongGetPenaltyInfoBtnModel> *btnList;
/**
 *  取消类型:0: 不扣款; 1 扣部分款; 2:扣全款
 */
@property (nonatomic,assign) NSInteger cancelOrderType;
/**
 *  是否使用toast提示
 */
@property (nonatomic,assign) BOOL isUseToast;
/**
 *  申请要回罚金页面tip提示
 */
@property (nonatomic,copy) NSString *complaintTip;
@end
