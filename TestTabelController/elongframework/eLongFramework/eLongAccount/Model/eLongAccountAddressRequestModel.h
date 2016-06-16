//
//  eLongAccountAddressRequestModel.h
//  ElongClient
//  个人中心邮寄地址增删改查的参数封装
//  Created by Janven Zhao on 15/3/23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongAccountAddressRequestModel : eLongRequestBaseModel
/**
 *  用户卡号
 */
@property (nonatomic,copy) NSString *CardNo;
/**
 *  用户手机号
 */
@property (nonatomic,copy) NSString <Optional>*PhoneNo;
/**
 *  ID
 */
@property (nonatomic,strong) NSNumber *Id;
@property (nonatomic,copy) NSString <Optional> *OperatorIP;
@property (nonatomic,copy) NSString <Optional> *OperatorName;
/**
 *  地址
 */
@property (nonatomic,copy) NSString  *Address;
/**
 *  联系人姓名
 */
@property (nonatomic,copy) NSString  *Name;
/**
 *  邮编
 */
@property (nonatomic,copy) NSString <Optional> *Postcode;

/**
 *  增加邮寄地址请求参数
 *
 *  @return 请求参数字典
 */
-(NSDictionary *)addAddressRequestParameters;
/**
 *  增加邮寄地址请求URL
 *
 *  @return 请求URL
 */
-(NSString *)addAddressRequestBusiness;
/**
 *  删除邮寄地址请求参数
 *
 *  @param addressID 删除的地址ID
 *
 *  @return 请求参数字典
 */
+(NSDictionary *)deleteAddressWithID:(NSNumber *)addressID;
/**
 *  删除邮寄地址请求URL
 *
 *  @return 请求URL
 */
+(NSString *)deleteAddressRequestBusiness;
/**
 *  修改邮寄地址请求参数
 *
 *  @return 请求参数字典
 */
-(NSDictionary *)modifyAddressRequestParameter;
/**
 *  修改邮寄地址的请求URL
 *
 *  @return 请求URL
 */
-(NSString *)modifyAddressRequestBusiness;
/**
 *  查询邮寄地址列表的请求参数
 *
 *  @param cardNo 会员卡号
 *  @param index  索引页码
 *  @param size   每页记录条数
 *
 *  @return 请求参数字典
 */
+(NSDictionary *)getAddressListWithCardNo:(NSString *)cardNo PageIndex:(NSInteger)index PageSize:(NSInteger)size;
/**
 *  查询邮寄地址URL
 *
 *  @return 请求URL
 */
+(NSString *)getAddressListRequestBusiness;

@end
