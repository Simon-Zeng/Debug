//
//  eLongAccountModifyUserRequestModel.h
//  ElongClient
//  修改个人信息的Model类
//  Created by Janven Zhao on 15/3/30.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongAccountModifyUserRequestModel : eLongRequestBaseModel

/**
 *  卡号
 */
@property (nonatomic,copy) NSString *cardNo;
/**
 *  再次确认密码的密码
 */
@property (nonatomic,copy) NSString <Optional>*confirmPassword;
/**
 *  邮箱
 */
@property (nonatomic,copy) NSString <Optional>*email;
/**
 *  是否是龙萃会员
 */
//@property (nonatomic,copy) NSString  *IsDragon_VIP;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString <Optional>*name;
/**
 *  密码
 */
@property (nonatomic,copy) NSString <Optional>*password;
/**
 *  电话号码
 */
@property (nonatomic,copy) NSString <Optional>*phoneNo;
/**
 *  姓名
 */
@property (nonatomic,copy) NSString <Optional>*sex;
/**
 *  旧密码
 */
@property (nonatomic,copy) NSString <Optional>*oldPassword;
/**
 *  SessionToken
 */
@property (nonatomic,copy) NSString *sessionToken;

/**
 *  token
 */
@property (nonatomic,copy) NSString <Optional>*accessToken;

/**
 *  是否是修改绑定手机号请求
 */
@property (nonatomic, assign) BOOL isChangeBindingMobile;

/**
 *  短信验证码（仅为修改绑定手机号时有效）
 */
@property (nonatomic,copy) NSString <Optional>*checkcode;

/**
 *  昵称
 */
@property (nonatomic,copy) NSString <Optional>*nickName;

/**
 *  生日
 */
@property (nonatomic,copy) NSString <Optional>*birthday;

/**
 *  头像地址
 */
@property (nonatomic,copy) NSString <Optional>*imageUrl;

//@property (nonatomic,assign) BOOL NeedVerifyCode;
//@property (nonatomic,copy) NSString *AuthCode;
//@property (nonatomic,copy) NSString *ErrorCode;
/**
 *  修改个人信息的URL
 *
 *  @return 请求URL
 */
+(NSString *)bussinessURL;
@end
