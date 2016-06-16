//
//  eLongAccountCustomerRequestModel.h
//  ElongClient
//  个人中心常用联系人的增删改查封装类
//  Created by Janven Zhao on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"
#import "elongAccountDefine.h"
@interface eLongAccountCustomerRequestModel : eLongRequestBaseModel
/**
*  邮箱
*/
@property (nonatomic,copy) NSString <Optional>*Email;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString *Name;
/**
 *  ID
 */
@property (nonatomic,strong) NSNumber *Id;
/**
 *  生日
 */
@property (nonatomic,copy) NSString <Optional>*BirthDay;
/**
 *  证件类型枚举
 */
@property (nonatomic,strong) NSNumber *IdType;
@property (nonatomic,copy) NSString <Optional>*OperatorName;
/**
 *  关联卡号
 */
@property (nonatomic,copy) NSString *CardNO;
/**
 *  证件类型名字
 */
@property (nonatomic,copy) NSString *IdTypeName;
@property (nonatomic,copy) NSString <Optional>*OperatorIP;
/**
 *  手机号
 */
@property (nonatomic,copy) NSString <Optional>*PhoneNo;
/**
 *  性别
 */
@property (nonatomic,copy) NSString <Optional>*Sex;
/**
 *  证件号（需要加密）
 */
@property (nonatomic,copy) NSString *IdNumber;

/**
 *  由于后台有bug，修改客史需要先删除。这个字段标识是否需要先删除客史
 */
@property (nonatomic,assign) BOOL isDeleteFirst;

/**
 *  添加客史请求参数
 *
 *  @return 请求字典
 */
-(NSDictionary *)addCustomerRequestParameters;
/**
 *  添加客史请求URL
 *
 *  @return 请求URL
 */
-(NSString *)addCustomerRequestBusiness;
/**
 *  删除客史请求参数
 *
 *  @param customerID 客史ID
 *  @param cardNo     关联卡号
 *
 *  @return 请求字典
 */
+(NSDictionary *)deleteCustomerWithID:(NSNumber *)customerID andCarNo:(NSString *)cardNo;
/**
 *  删除客史请求URL
 *
 *  @return 请求URL
 */
+(NSString *)deleteCustomerRequestBusiness;
/**
 *  修改客史请求参数
 *
 *  @return 请求字典
 */
-(NSDictionary *)modifyCutomerRequestParameter;
/**
 *  修改客史请求URL
 *
 *  @return 请求URL
 */
-(NSString *)modifyCustomerRequestBusiness;
/**
 *  客史列表请求参数
 *
 *  @param cardNo 用户卡号
 *  @param type   客史类型枚举 CustomerType
 *  @param index  索引页码
 *  @param size   每页记录条数
 *
 *  @return 请求字典
 */
+(NSDictionary *)getCustomersWithCardNo:(NSString *)cardNo CustomerType:(CustomerType)type PageIndex:(NSInteger)index PageSize:(NSInteger)size;
/**
 *  客史列表请求URL
 *
 *  @return 请求URL
 */
+(NSString *)getCustomersRequestBusiness;

@end
