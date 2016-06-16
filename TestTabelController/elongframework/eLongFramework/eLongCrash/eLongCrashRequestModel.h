//
//  eLongCrashRequestModel.h
//  ElongClient
//
//  Created by 张馨允 on 15/4/17.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongCrashRequestModel : eLongRequestBaseModel

/**
 *  页面名称
 */
@property (nonatomic,copy) NSString *pageName;

/**
 *  异常名称
 */
@property (nonatomic,copy) NSString *exceptionName;

/**
 *  异常类型：0，捕获的异常；1 crash
 */
@property (nonatomic,assign) NSInteger exceptionType;

/**
 *  异常堆栈详细信息
 */
@property (nonatomic,copy) NSString *exceptionsStackDetail;

/**
 *  应用版本号
 */
@property (nonatomic,copy) NSString *appVersion;

/**
 *  系统版本号
 */
@property (nonatomic,copy) NSString *osVersion;

/**
 *  设备型号
 */
@property (nonatomic,copy) NSString *deviceModel;

/**
 *  网络类型 ex：0：3G；1：2G；3：WIFI
 */
@property (nonatomic,assign) NSInteger netWorkType;

/**
 *  设备状态，记录CPU及内存等信息
 */
@property (nonatomic,copy) NSString *deviceStatus;

/**
 *  渠道号
 */
@property (nonatomic,copy) NSString *channelId;

/**
 *  客户端类型
 */
@property (nonatomic,assign) NSInteger clientType;

/**
 *  通讯运营商
 */
@property (nonatomic,copy) NSString *netWorkCarrier;

/**
 *  crash时间
 */
@property (nonatomic,strong) NSString * crashTime;

/**
 *  应用名称
 */
@property (nonatomic,copy) NSString *appName;

/**
 *  elong帐户
 */
@property (nonatomic,copy) NSString *eLongAccount;

/**
 *  手机号码
 */
@property (nonatomic,copy) NSString *phoneNumber;

/**
 *  设备ID
 */
@property (nonatomic,copy) NSString *deviceId;

@end
