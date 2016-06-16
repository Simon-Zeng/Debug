//
//  eLongInvoiceListContentModel.h
//  ElongClient
//
//  Created by myiMac on 15/3/12.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongInvoiceListContentModel @end

@interface eLongInvoiceListContentModel : eLongResponseBaseModel
/**
 *  酒店名
 */
@property (nonatomic,copy) NSString *hotelName;
/**
 *  订单金额
 */
@property (nonatomic,assign) float payMoney;
/**
 *  可开具发票金额
 */
@property (nonatomic,assign) float invoiceMoney;
/**
 *  入住日期
 */
@property (nonatomic,copy) NSString *checkInDate;
/**
 *  离店日期
 */
@property (nonatomic,copy) NSString *checkOutDate;
/**
 *  房间数
 */
@property (nonatomic,assign) NSInteger roomNum;
/**
 *  订单号
 */
@property (nonatomic,copy) NSString *orderNo;
/**
 *  卡号
 */
@property (nonatomic,copy) NSString *CardNo;
/**
 *  每页记录数
 */
@property (nonatomic,assign) NSInteger pageSize;
/**
 *  当前页数
 */
@property (nonatomic,assign) NSInteger pageIndex;
/**
 *  是否隐藏头部信息
 */
@property (nonatomic,assign) BOOL isHiddeInvoiceHeadTip;

@end
