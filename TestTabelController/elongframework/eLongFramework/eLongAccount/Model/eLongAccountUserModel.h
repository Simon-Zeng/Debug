//
//  eLongAccountUserModel.h
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@interface eLongAccountUserModel : eLongResponseBaseModel
/**
 *  用户名字
 */
@property (nonatomic,copy) NSString *Name;
/**
 *  用户会员卡
 */
@property (nonatomic,retain) NSNumber *CardNo;
/**
 *  用户手机号
 */
@property (nonatomic,copy) NSString *PhoneNo;
/**
 *  用户性别
 */
@property (nonatomic,copy) NSString *Sex;
/**
 *  用户邮箱
 */
@property (nonatomic,copy) NSString *Email;
/**
 *  账户是否验证过
 */
@property (nonatomic,copy) NSString <Ignore>*verifyStatus;

/**
 *  用户昵称（9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *NickName;
/**
 *  用户生日（9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *Birthday;
/**
 *  用户头像地址（9.6.0版本添加）
 */
@property (nonatomic,copy) NSString *ImageUrl;

/**
 *  代理信息（9.7.0版本添加）
 */
@property (nonatomic, copy) NSString *Proxy;

@end
