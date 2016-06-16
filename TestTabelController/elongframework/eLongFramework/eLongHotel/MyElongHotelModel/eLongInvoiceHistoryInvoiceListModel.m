//
//  eLongInvoiceHistoryInvoiceListModel.m
//  ElongClient
//
//  Created by lvyue on 15/3/19.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongInvoiceHistoryInvoiceListModel.h"
#import "eLongExtension.h"
#import "eLongDefine.h"

@implementation eLongInvoiceHistoryInvoiceListModel
- (BOOL)isEqualtoHistoryListModel:(eLongInvoiceHistoryInvoiceListModel *)anOtherModel{
    if ([_invoiceType isEqualToString:anOtherModel.invoiceType]) {
        NSLog(@"aaaa");
    }
    return  _deliveryDetailFlag == anOtherModel.deliveryDetailFlag
    && [_invoiceId isEqualToString:anOtherModel.invoiceId]
    && [_invoiceTitle isEqualToString:anOtherModel.invoiceTitle]
    && [_deliveryAddr isEqualToString:anOtherModel.deliveryAddr]
    && [_deliveryName isEqualToString:anOtherModel.deliveryName]
    && [_deliveryPhone isEqualToString:anOtherModel.deliveryPhone]
    && [_invoiceType isEqualToString:anOtherModel.invoiceType]
    && _invoiceModifyFlag == anOtherModel.invoiceModifyFlag
    && _isInvoiceHoldRemark == anOtherModel.isInvoiceHoldRemark
    && _invoiceMoney == anOtherModel.invoiceMoney
    && [self isEquelToRemarkInfoList:anOtherModel.invoiceRemark]
    && [self isEquelToOrdelList:anOtherModel.orderList];
}

- (BOOL)isEquelToOrdelList:(NSArray<eLongInvoiceHistoryOrderInfoModel> *)oderList_{
    BOOL ordeListSame = YES;
    if ([_orderList safeCount] == [oderList_ safeCount]) {
        for (int i = 0; i < [_orderList safeCount]; i++) {
            eLongInvoiceHistoryOrderInfoModel *aModel = [_orderList safeObjectAtIndex:i];
            if (!aModel || ![aModel isKindOfClass:[eLongInvoiceHistoryOrderInfoModel class]])
                continue;
            eLongInvoiceHistoryOrderInfoModel *bModel = [oderList_ safeObjectAtIndex:i];
            if (!bModel || ![bModel isKindOfClass:[eLongInvoiceHistoryOrderInfoModel class]])
                continue;
            if (![aModel isEqual:bModel]) {
                ordeListSame = NO;
                break;
            }
        }
    }else{
        ordeListSame = NO;
    }
    return ordeListSame;
}

- (BOOL)isEquelToRemarkInfoList:(NSArray<eLongInvoiceHistoryInvoiceRemarkInfoModel> *)remarkInfo{
    BOOL ordeListSame = YES;
    if ([_invoiceRemark safeCount] == [remarkInfo safeCount]) {
        for (int i = 0; i < [_invoiceRemark safeCount]; i++) {
            eLongInvoiceHistoryInvoiceRemarkInfoModel *aModel = [_invoiceRemark safeObjectAtIndex:i];
            if (!aModel || ![aModel isKindOfClass:[eLongInvoiceHistoryInvoiceRemarkInfoModel class]])
                continue;
            eLongInvoiceHistoryInvoiceRemarkInfoModel *bModel = [remarkInfo safeObjectAtIndex:i];
            if (!bModel || ![bModel isKindOfClass:[eLongInvoiceHistoryInvoiceRemarkInfoModel class]])
                continue;
            if (![aModel isEqual:bModel]) {
                ordeListSame = NO;
                break;
            }
        }
    }else{
        ordeListSame = NO;
    }
    return ordeListSame;
}

@end

@implementation eLongInvoiceHistoryOrderInfoModel
- (BOOL)isEqual:(id)object{
    BOOL isEqual = NO;
    if (object && [object isKindOfClass:[eLongInvoiceHistoryOrderInfoModel class]]) {
        eLongInvoiceHistoryOrderInfoModel *aModel = (eLongInvoiceHistoryOrderInfoModel *)object;
        isEqual = [aModel.orderId isEqualToString:_orderId]
        && _orderInvoiceMoney == aModel.orderInvoiceMoney;
    }
    return isEqual;
}

@end

@implementation eLongInvoiceHistoryInvoiceRemarkInfoModel

- (BOOL)isEqual:(id)object{
    BOOL isEqual = NO;
    if (object && [object isKindOfClass:[eLongInvoiceHistoryInvoiceRemarkInfoModel class]]) {
        eLongInvoiceHistoryInvoiceRemarkInfoModel *aModel = (eLongInvoiceHistoryInvoiceRemarkInfoModel *)object;
        isEqual = [aModel.checkInDate isEqualToString:_checkInDate]
        && [aModel.checkOutDate isEqualToString:_checkOutDate]
        && _roomNum == aModel.roomNum
        &&[_hotelName isEqualToString:aModel.hotelName];
    }
    return isEqual;
}

@end