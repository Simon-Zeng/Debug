//
//  eLongAccountHongBaoInstance.h
//  ElongClient
//  红包模块
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "eLongRedPacketModel.h"

@interface eLongAccountHongBaoInstance : eLongAccountInstanceBase

/**
 *  请求用户红包列表（支持分页）
 *
 *  @param cardNo  用户卡号
 *  @param index   索引 从1开始
 *  @param size    每页大小（多少条记录）
 *  @param success 网络成功的回调
 *  @param failed  网络失败的回调
 */
-(void)requestTheHongBaoRecordsWithCardNo:(NSString *)cardNo
                                PageIndex:(NSInteger)index
                                 PageSize:(NSInteger)size
                                Successed:(NetSuccessCallBack)success
                                   Failed:(NetFailedCallBack)failed;
/**
 *  红包model
 */
@property (nonatomic,strong) eLongRedPacketModel *hongbaoModel;

@property (nonatomic,strong) elongHongBaoCountResponseModel *hongbaoCountModel;
@end
