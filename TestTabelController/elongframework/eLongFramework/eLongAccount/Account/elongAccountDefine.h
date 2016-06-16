//
//  elongAccountDefine.h
//  ElongClient
//
//  Created by Janven Zhao on 15/3/11.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#ifndef ElongClient_elongAccountDefine_h
#define ElongClient_elongAccountDefine_h
/**
 *  CA业务线枚举
 */
typedef NS_ENUM(NSInteger, ElongCABizType){
    /**
     *  Myelong
     */
    ElongCABizType_Myelong = 0,
    /**
     * 提现
     */
      ElongCABizType_Withdraw = 1,
    /**
     *  手机充值
     */
      ElongCABizType_MobileCharges = 2,
    /**
     *  国内担保酒店
     */
     ElongCABizType_DomesticGuaranteeHotel = 1001,
    /**
     *   机票
     */
     ElongCABizType_Filghts = 1002,
    /**
     *  国际酒店
     */
    ElongCABizType_InternationalHotel = 1003,
    /**
     *  预付酒店
     */
    ElongCABizType_DomesticPrepayHotel = 1005,
    /**
     *  团购
     */
    ElongCABizType_Groupon = 1006,
    /**
     *  火车票
     */
    ElongCABizType_Train = 1022
};

/**
 *  艺龙订单分类
 */
typedef NS_ENUM(NSInteger, ElongOrdersType){
    /**
     *  全部订单
     */
    ElongOrdersType_AllOrder = 0,
    /**
     *  待付款
     */
    ElongOrdersType_WaitingPay = 1,
    /**
     *  未出行
     */
    ElongOrdersType_NotEmbark,
    /**
     *  申请返现
     */
    ElongOrdersType_ApplyReturn,
    /**
     *  取消订单
     */
    ElongOrdersType_CancelOrder,
    /**
     *  退款
     */
    ElongOrdersType_Refund,
    /**
     *  待点评
     */
    ElongOrdersType_WaitingComments
};


/**
 *  账户明细中的账户类型枚举
 */
typedef NS_ENUM(NSInteger, ElongAccountType){
    /**
     *  全部
     */
    ElongAccountType_All = 0,
    /**
     *  CA
     */
    ElongAccountType_CA,
    /**
     *  预付卡
     */
    ElongAccountType_PrePay,
    /**
     *  红包
     */
    ElongAccountType_HongBao
};

/**
 *  收入支出类型
 */
typedef NS_ENUM(NSInteger, InAndExpType){
    /**
     *  全部
     */
    InAndExpType_All = 0,
    /**
     *  收入
     */
    InAndExpType_In,
    /**
     *  支出
     */
    InAndExpType_Exp
};

/**
 *  乘客类型枚举
 */
typedef NS_ENUM(NSInteger, CustomerType){
    /**
     *  MyElong 类型不限
     */
    CustomerType_MyElong = 0,
    /**
     *  国内机票
     */
    CustomerType_DomesticFlight,
    /**
     *  联系人
     */
    CustomerType_Contacts,
    /**
     *  国际机票
     */
    CustomerType_Hotels,
    /**
     *  国际机票
     */
    CustomerType_InternationalFlight
};


#pragma mark NSUserDefalut --- Keys
/**
 *  UserDefault中用户信息的Key
 */
static NSString *const Keys_UserDefault_UserInfo = @"USERDEFAULT_LOGINUSERINFO";
/**
 *  UserDefault中Push的DeviceToken
 */
static NSString *const Keys_UserDefault_DeviceToken = @"DeviceToken";

#pragma mark NSNotification ---Keys

/**
 *  龙翠会员通知
 */
static NSString *const Notification_User_IsDragonMember = @"NOTI_LONGVIP";

/**
 *  会员等级信息通知
 */
static NSString *const Notification_User_Rank_Info = @"NOTI_USER_RANK_INFO";
/**
 *  刷新个人账户信息的通知
 */
static NSString *const Notification_AccountCA_ReFresh = @"Notification_AccountCA_ReFresh";

#endif
