//
//  eLongCounterConfigModel.m
//  eLongFramework
//
//  Created by zhaoyingze on 15/11/10.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongCounterConfigModel.h"

@implementation eLongCounterConfigModel

+ (id)shared
{
    static eLongCounterConfigModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        model = [[self alloc] init];
        model.channelType = [NSNumber numberWithInteger:9106];
        model.language = [NSNumber numberWithInteger:7801];
        model.memberSource = [NSNumber numberWithInteger:0];
        model.appScheme = @"elongIPhone";
        model.schemeForQQWallet = @"eLongForQQWallet"; 
        model.schemeForWeChat = @"elongIPhone";
        model.merchantId = @"merchant.com.elong.travel";
        model.subCodeForWechat = @"4311";
        model.subCodeForWechatFriendPay = @"4316";
        model.disableAliPay = NO;
        model.disableWeChatPay = NO;
        model.disableWeChatFriendPay = NO;
        model.disableQQWalletPay = NO;
        model.disableApplePay = NO;
        model.disableCMBPay = NO;
    });
    
    return model;
}

@end
