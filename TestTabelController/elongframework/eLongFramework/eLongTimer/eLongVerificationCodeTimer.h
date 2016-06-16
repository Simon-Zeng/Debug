//
//  eLongVerificationCodeTimer.h
//  eLongFramework
//
//  Created by lvyue on 15/6/19.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongSingletonDefine.h"

@interface eLongVerificationCodeTimer : NSObject
@property (nonatomic,assign)  int remainSecondsRegister;//注册流程使用！
@property (nonatomic,assign)  int remainSecondsForgetPwd;//忘记密码流程使用！
@property (nonatomic,assign)  int remainSecondsDynamicLogin;//动态密码登录流程使用！
@property (nonatomic,assign)  int remainModifyCashPasswordSeconds;//修改支付密码流程倒计时使用！
/*!
 *  注册页面返回时调用
 *
 *  @param seconds 剩余秒数
 */
-(void)fireTheTimerAndCountWithLeftSecondsForRegister:(int)seconds;
-(void)destoryTimerForRegister;

/*!
 *  忘记密码页面返回时调用
 *
 *  @param seconds 剩余秒数
 */
-(void)fireTheTimerAndCountWithLeftSecondsForForgetPwd:(int)seconds;
-(void)destoryTimerForForgetPwd;

/*!
 *  动态密码登录页面返回时调用
 *
 *  @param seconds 剩余秒数
 */
-(void)fireTheTimerAndCountWithLeftSecondsForDynamicLogin:(int)seconds;
-(void)destoryTimerForDynamicLogin;

/*!
 *  我的钱包修改支付密码返回时调用
 *
 *  @param seconds 剩余秒数
 */
-(void)fireTheTimerAndCountWithLeftSecondsInModifyCashAccountPassword:(int)seconds;
-(void)destoryTimerInModifyCashAccountPassword;

AS_SINGLETON(eLongVerificationCodeTimer)

@end
