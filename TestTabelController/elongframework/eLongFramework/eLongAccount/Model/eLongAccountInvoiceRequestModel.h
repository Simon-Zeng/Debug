//
//  eLongAccountInvoiceRequestModel.h
//  ElongClient
//
//  Created by Janven Zhao on 15/4/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongAccountInvoiceRequestModel : eLongRequestBaseModel
/**
 *  增加发票抬头URL
 *
 *  @return 请求URL
 */
+(NSString *)addInvoiceBusiness;
/**
 *  删除发票抬头URL
 *
 *  @return 请求URL
 */
+(NSString *)deleteInvoiceBusiness;
/**
 *  修改发票抬头URL
 *
 *  @return 请求URL
 */
+(NSString *)modifyInvoiceBusiness;
/**
 *  发票抬头列表URL
 *
 *  @return 请求URL
 */
+(NSString *)invoiceListBusiness;
/**
 *  增加发票抬头的请求参数
 *
 *  @param titleID 抬头ID
 *  @param value   抬头内容
 *
 *  @return 请求字典
 */
+(NSDictionary *)addInvoiceWithTitleID:(NSString *)titleID Value:(NSString *)value;
/**
 *  删除发票抬头的请求参数
 *
 *  @param titleID 抬头ID
 *
 *  @return 请求字典
 */
+(NSDictionary *)deleteInvoiceWithID:(NSString *)titleID;
/**
 *  修改发票抬头的请求参数
 *
 *  @param titleID 抬头ID
 *  @param value   抬头内容
 *  @param defaut  是否是默认 BOOL 类型
 *
 *  @return 请求字典
 */
+(NSDictionary *)modifyInvoiceWithID:(NSString *)titleID Value:(NSString *)value default:(BOOL)defaut;
/**
 *  获取发票抬头列表
 *
 *  @return 请求字典
 */
+(NSDictionary *)getInvoiceList;
@end
