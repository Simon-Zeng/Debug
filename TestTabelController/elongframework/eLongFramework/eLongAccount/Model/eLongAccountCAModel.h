//
//  eLongAccountCAModel.h
//  ElongClient
//
//  Created by Janven Zhao on 15/3/19.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@interface eLongAccountCAModel : eLongResponseBaseModel
/**
*  是否存在支付密码
*/
@property (nonatomic,assign) BOOL ExistPaymentPassword;
/**
 *  是否可用现金账户支付
 */
@property (nonatomic,assign) BOOL CacheAccountAvailable;
/**
*  总共返还金额
*/
@property (nonatomic,strong) NSNumber *BackAmount;
/**
 *  总共可支取金额
 */
@property (nonatomic,strong) NSNumber *Remainingamount;
/**
 *  总共已支取金额
 */
@property (nonatomic,strong) NSNumber *ExpenditureAmount;
/**
 *  总共被锁定的金额
 */
@property (nonatomic,strong) NSNumber *LockedAmount;
/**
 *  总过将过期的金额
 */
@property (nonatomic,strong) NSNumber *WillExpireAmount;
/**
 *  返现金额
 */
@property (nonatomic,strong) NSNumber *BackCashAmount;
/**
 *  通用预付卡金额(酒店、机票、团购)
 */
@property (nonatomic,strong) NSNumber *UniversalAmount;
/**
 *  专用预付卡金额(不包括机票)
 */
@property (nonatomic,strong) NSNumber *SpecifiedAmount;
/**
 *  卡券余额
 */
@property (nonatomic,strong) NSNumber *GiftCardAmount;
/**
 *  是否可用红包
 */
@property (nonatomic,assign) BOOL isHongBaoAvailable;
/**
 *  可用红包金额
 */
@property (nonatomic,strong) NSNumber *availableHongBaoPrice;
/**
 *  过期时间
 */
@property (nonatomic,strong) NSString <Optional>*OverDueDate;
@end
