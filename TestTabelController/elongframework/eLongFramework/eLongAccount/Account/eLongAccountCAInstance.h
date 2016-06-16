//
//  eLongAccountCAInstance.h
//  ElongClient
//  CashAccount模块
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "elongAccountDefine.h"

@interface eLongAccountCAInstance : eLongAccountInstanceBase

/**
 *  总金额（可支取金额＋锁定金额）
 */
@property (nonatomic,readonly) double totalAccount;
/**
 *  现金总额（已锁定＋已返现）
 */
@property (nonatomic,readonly) double cashAmount;
/**
 *  红包余额
 */
@property (nonatomic,readonly) double hongBaoAmount;
/**
 *  预付卡余额
 */
@property (nonatomic,readonly) double prePayCardAmount;

/**
 *  根据业务线请求CA账户
 *
 *  @param cardNo  用户卡号
 *  @param type    业务线
 *  @param success 网络成功的回调
 *  @param faild   网络失败的回调
 */
-(void)requestTheCashAccountByCardNo:(NSString *)cardNo
                             BizType:(ElongCABizType)type
                           Successed:(NetSuccessCallBack)success
                               Failed:(NetFailedCallBack)Failed;

/**
 *  账户收支明细（全部、CA、预付卡、红包）
 *
 *  @param carNo      用户卡号
 *  @param type       账户类型
 *  @param _inOutType 全部/收入/支出
 *  @param index      索引页码
 *  @param size       每页记录数目
 *  @param success 网络成功的回调
 *  @param failed   网络失败的回调
 */
-(void)requestTheCAIncomeAndExpensesDetailWithCardNo:(NSString *)carNo
                                         AccountType:(ElongAccountType)type
                                             InOrOut:(InAndExpType)_inOutType
                                           PageIndex:(NSInteger)index
                                            PageSize:(NSInteger)size
                                           Successed:(NetSuccessCallBack )success
                                              Failed:(NetFailedCallBack )failed;

@end
