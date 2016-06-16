//
//  eLongAccountInvoiceRequestModel.m
//  ElongClient
//
//  Created by Janven Zhao on 15/4/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInvoiceRequestModel.h"
#import "eLongAccountManager.h"

@implementation eLongAccountInvoiceRequestModel

+(NSString *)addInvoiceBusiness{
    return @"myelong/addInvoiceTitle";
}
+(NSString *)deleteInvoiceBusiness{
    return @"myelong/deleteInvoiceTitle";
}
+(NSString *)modifyInvoiceBusiness{
    return @"myelong/updateInvoiceTitle";
}
+(NSString *)invoiceListBusiness{
    return @"myelong/getInvoiceTitles";
}

+(NSDictionary *)addInvoiceWithTitleID:(NSString *)titleID Value:(NSString *)value{
    NSDictionary *req = @{@"CardNo":[eLongAccountManager userInstance].cardNo,@"titleId":titleID,@"value":value};
    return req;
}

+(NSDictionary *)deleteInvoiceWithID:(NSString *)titleID{
    NSDictionary *req = @{@"CardNo":[eLongAccountManager userInstance].cardNo,@"titleId":titleID};
    return req;
}
+(NSDictionary *)modifyInvoiceWithID:(NSString *)titleID Value:(NSString *)value default:(BOOL)defaut{

    NSDictionary *req = @{@"CardNo":[eLongAccountManager userInstance].cardNo,
                          @"titleId":titleID,
                          @"value":value,
                          @"defTitle":@(defaut)};
    return req;
}
+(NSDictionary *)getInvoiceList{
    NSDictionary *req = @{@"CardNo":[eLongAccountManager userInstance].cardNo};
    return req;
}
@end
