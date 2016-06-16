//
//  elongAccountUserRankInfoModel.h
//  MyElong
//
//  Created by yongxue on 15/12/16.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@interface elongAccountUserRankInfoModel : eLongResponseBaseModel
/**
 *  等级Id
 */
@property (nonatomic,copy) NSString *gradeId;

/**
 *  等级名称
 */
@property (nonatomic,copy) NSString *gradeName;

/**
 *  等级昵称
 */
@property (nonatomic,copy) NSString *gradeNickname;

/**
 *  新会员等级
 */
@property (nonatomic,assign) NSInteger newMemelevel;

/**
 *  总共的经验值
 */
@property (nonatomic,assign) long expTotal;

/**
 *  总共可用的经验值
 */
@property (nonatomic,assign) long expAvailiable;

/**
 *  该等级最大经验值
 */
@property (nonatomic,assign) long maxExp;

/**
 *  代理信息 该字段请app保存，签到等接口会需要其作为入参
 */
@property (nonatomic,copy) NSString *proxy;

/**
 *  是否是代理用户 该字段用于判断是否显示会员俱乐部入口
 */
@property (nonatomic,assign) BOOL isProxy;
/**
 *  0,没有礼包, 第一位代表升级礼包(即1)
 */
@property (nonatomic,assign) NSInteger giftSet;

@end
