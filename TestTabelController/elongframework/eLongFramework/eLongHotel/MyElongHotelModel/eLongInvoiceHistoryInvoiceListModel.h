//
//  eLongInvoiceHistoryInvoiceListModel.h
//  ElongClient
//
//  Created by lvyue on 15/3/19.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongResponseBaseModel.h"


@protocol eLongInvoiceHistoryOrderInfoModel
@end
@interface eLongInvoiceHistoryOrderInfoModel : eLongResponseBaseModel
/**
 *  订单号
 */
@property (strong , nonatomic) NSString *orderId;
/**
 *  订单发票金额
 */
@property (assign) float orderInvoiceMoney;
@end


@protocol eLongInvoiceHistoryInvoiceRemarkInfoModel
@end
@interface eLongInvoiceHistoryInvoiceRemarkInfoModel : eLongResponseBaseModel
/**
 *  入住日期
 */
@property (strong , nonatomic) NSString *checkInDate;

/**
 *  离店日期
 */
@property (strong , nonatomic) NSString *checkOutDate;

/**
 *  房间数
 */
@property (assign) NSInteger roomNum;

/**
 *  酒店名称
 */
@property (strong , nonatomic) NSString *hotelName;

@end


@interface eLongInvoiceHistoryInvoiceListModel : eLongResponseBaseModel
/**
 *  发票物流状态
 */
@property (strong , nonatomic) NSString *deliveryStatus;
/**
 *  发票物流详情显示按钮开关,true显示发票详情按钮,false不显示
 */
@property (assign) BOOL deliveryDetailFlag;
/**
 *  发票金额
 */
@property (assign) float invoiceMoney;
/**
 *  发票抬头
 */
@property (strong , nonatomic) NSString *invoiceTitle;
/**
 *  发票类型
 */
@property (strong , nonatomic) NSString *invoiceType;
/**
 *  收件人姓名
 */
@property (strong , nonatomic) NSString *deliveryName;
/**
 *  收件人电话
 */
@property (strong , nonatomic) NSString *deliveryPhone;
/**
 *  收件人地址
 */
@property (strong , nonatomic) NSString *deliveryAddr;
/**
 *  发票Id
 */
@property (strong , nonatomic) NSString *invoiceId;
/**
 *  发票是否可修改,true可修改,false不可修改
 */
@property (assign) BOOL invoiceModifyFlag;
/**
 *  显示不显示明细信息,true可显示,false不可显示
 */
@property (assign) BOOL isInvoiceHoldRemark;
/**
 *  发票对应的订单列表，合开发票时一张发票会对应多个订单
 */
@property (strong , nonatomic) NSArray<eLongInvoiceHistoryOrderInfoModel> *orderList;
/**
 *  发票备注，这里为备注数据，塞入模板中；合开发票时会有多个备注信息
 */
@property (strong , nonatomic) NSArray<eLongInvoiceHistoryInvoiceRemarkInfoModel> *invoiceRemark;

- (BOOL)isEqualtoHistoryListModel:(eLongInvoiceHistoryInvoiceListModel *)anOtherModel;

@end



