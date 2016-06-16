//
//  eLongGetPenaltyInfoBtnModel.h
//  ElongClient
//
//  Created by zhaolina on 15/7/10.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongGetPenaltyInfoBtnModel @end

@interface eLongGetPenaltyInfoBtnModel : eLongResponseBaseModel
/**
 *  按钮类型：1 确认取消; 2 确定; 3 特殊申请全额退款; 4 特殊申请解冻/退款; 5 点错了
 */
@property (nonatomic,assign) NSInteger code;
/**
 *  按钮文字
 */
@property (nonatomic,copy) NSString *text;
@end
