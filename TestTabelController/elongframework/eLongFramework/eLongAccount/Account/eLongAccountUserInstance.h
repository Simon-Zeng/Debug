//
//  eLongAccountUserInstance.h
//  ElongClient
//  用户基本信息模块
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "elongAccountDefine.h"
@class elongAccountUserRankInfoModel;
@class eLongAccountCustomerRequestModel,eLongAccountAddressRequestModel,eLongAccountModifyUserRequestModel;
@interface eLongAccountUserInstance : eLongAccountInstanceBase
/**
 *  会员卡号
 */
@property (nonatomic,readonly) NSString *cardNo;
/**
 *  会员手机号
 */
@property (nonatomic,readonly) NSString *phoneNo;
/**
 *  用户名字（可修改、但仅限于修改个人信息使用）
 */
@property (nonatomic,copy) NSString *name;
/**
 *  会员邮箱（可修改、但仅限于修改个人信息使用）
 */
@property (nonatomic,copy) NSString *email;
/**
 *  会员性别（可修改、但仅限于修改个人信息使用）
 */
@property (nonatomic,copy) NSString *sex;

/**
 *  会员昵称（可修改、但仅限于修改个人信息使用，9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *nickName;
/**
 *  会员生日（可修改、但仅限于修改个人信息使用，9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *birthday;
/**
 *  会员头像地址（可修改、但仅限于修改个人信息使用，9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *imageUrl;

/**
 *  代理信息（9.7.0版本添加）
 */
@property (nonatomic,readonly) NSString *user;

/**
 *  积分
 */
@property (nonatomic,readonly) NSInteger cumulativePoints;
/**
 *  是否是龙翠会员
 */
@property (nonatomic,readonly) BOOL isDragonMember;

/**
 *  用户是否登录
 */
@property (nonatomic,readonly) BOOL isLogin;

/**
 *  用户是非会员&登陆判断
 */
@property (nonatomic,readonly) BOOL isAdjustLogin;

/**
 *  是否是非会员下单流程，可赋值
 */
@property (nonatomic,assign) BOOL isNonmemberFlow;

/**
 *  会员等级
 */
@property (nonatomic,assign) NSInteger userLevel;

#pragma mark - 用户等级信息（9.7.0添加）
/**
 *  等级Id
 */
@property (nonatomic,copy,readonly) NSString *gradeId;

/**
 *  等级名称
 */
@property (nonatomic,copy,readonly) NSString *gradeName;

/**
 *  等级昵称
 */
@property (nonatomic,copy,readonly) NSString *gradeNickname;

/**
 *  总共的经验值
 */
@property (nonatomic,assign,readonly) long expTotal;

/**
 *  总共可用的经验值
 */
@property (nonatomic,assign,readonly) long expAvailiable;

/**
 *  该等级最大经验值
 */
@property (nonatomic,assign,readonly) long maxExp;

/**
 *  代理信息 该字段请app保存，签到等接口会需要其作为入参
 */
@property (nonatomic,copy,readonly) NSString *proxy;

/**
 *  是否是代理用户 该字段用于判断是否显示会员俱乐部入口
 */
@property (nonatomic,assign,readonly) BOOL isProxyType;

/**
 *  用户等级信息
 */
@property (nonatomic,strong) elongAccountUserRankInfoModel *userRankInfoModel;

/**
 *  是否有用户等级
 */
@property (nonatomic, assign, readonly) BOOL isHasUserRankInfo;


/**
 *  设置用户手机验证
 *
 *  @param status 是否验证过
 */
-(void)setVerifyStatus:(BOOL)status;
/**
 *  获取用户手机验证状态
 *
 *  @return 1 验证过  0未验证过
 */
-(NSString *)verifyStatus;

/**
 *  获取最近一次登录的用户信息
 *
 *  @return 字典
 */
-(NSDictionary *)getLastLoginSavedUserInfo;

/**
 *  登录成功后调用,设置账户系统初始值
 *
 *  @param root 登录返回的字典
 */
-(void)setOriginalDataByLoginReturnDic:(NSDictionary *)root;

/**
 *  解除绑定
 */
-(void)requestUnBindingPush;
/**
 *  为了兼容老的publicMethod中的方法，这个方法内如果cardNo是空，会返回@“0”
 */
-(NSString *)getUserElongCardNO;
/**
 *  0,没有礼包, 第一位代表升级礼包(即1)
 */
- (NSInteger)giftSet;
#pragma mark
#pragma mark ------发票抬头相关（增删改查）
/**
 *  增加发票抬头
 *
 *  @param invoiceID 发票抬头ID
 *  @param value     发票抬头内容
 *  @param success   成功回调
 *  @param failed    失败回调
 */
-(void)addInvoiceWithInvoiceID:(NSString *)invoiceID Content:(NSString *)value Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  删除发票抬头
 *
 *  @param invoiceID 发票抬头ID
 *  @param success   成功回调
 *  @param failed    失败回调
 */
-(void)deleteInvoiceWithInvoiceID:(NSString *)invoiceID Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  修改发票抬头
 *
 *  @param invoiceID    发票抬头ID
 *  @param value        发票内容
 *  @param defaultOrNot 是否是默认发票抬头
 *  @param success      成功回调
 *  @param failed       失败回调
 */
-(void)modifyInvoiceWithInvoiceID:(NSString *)invoiceID Value:(NSString *)value Default:(BOOL)defaultOrNot Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  获取发票抬头
 *
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)getInvoicelistSuccess:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;

#pragma mark
#pragma mark ------邮寄地址相关

/**
 *  新增邮寄地址
 *
 *  @param model   邮寄地址Model类
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)addAddressWithModel:(eLongAccountAddressRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  删除邮寄地址
 *
 *  @param ID      邮寄地址的ID
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)deleteAddressWithAddressID:(NSNumber *)ID Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  修改邮寄地址
 *
 *  @param model   邮寄地址的Model
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)modifyAddressWithModel:(eLongAccountAddressRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  邮寄地址列表
 *
 *  @param cardNo  用户卡号
 *  @param index   索引页码
 *  @param size    每页记录条数
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)getAddressListWithCardNo:(NSString *)cardNo PageIndex:(NSInteger)index PageSize:(NSInteger)size Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;

#pragma mark
#pragma mark ------客史相关

/**
 *  添加客史
 *
 *  @param model   客史请求Model eLongAccountCustomerRequestModel
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)addCustomerWithModel:(eLongAccountCustomerRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  删除客史
 *
 *  @param ID      客史ID
 *  @param cardNo  用户卡号
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)deleteCustomerWithAddressID:(NSNumber *)ID CardNo:(NSString *)cardNo Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  修改客史
 *
 *  @param model   客史Model eLongAccountCustomerRequestModel
 *  @param success 成功回调
 *  @param failed  失败回调
 */
-(void)modifyCustomerWithModel:(eLongAccountCustomerRequestModel*)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;
/**
 *  获取客史列表
 *
 *  @param type    客史类型 CustomerType
 *  @param cardNo  用户卡号
 *  @param index   索引页码
 *  @param size    页码中记录条数
 *  @param success 成功回调
 *  @param failed  失败回调
 */

-(void)getCustomersListWithCustomerType:(CustomerType)type CardNo:(NSString *)cardNo PageIndex:(NSInteger)index PageSize:(NSInteger)size Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;

#pragma mark
#pragma mark ------修改个人信息
/**
 *  修改个人信息
 *
 *  @param model   修改个人信息的RequestModel
 *  @param success 成功回调
 *  @param failed  失败回调
 *
 *  @return eLongHTTPRequestOperation
 */

-(eLongHTTPRequestOperation *)modifyElongUserWithModifyUserModel:(eLongAccountModifyUserRequestModel *)model Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;




/**
 *  获取区域信息
 *
 *  @param model   获取区域信息
 *  @param success 成功回调
 *  @param failed  失败回调
 *
 *  @return eLongHTTPRequestOperation
 */

-(eLongHTTPRequestOperation *)getAreaCodeSuccess:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;

@end
