//
//  eLongEditGuestHistoryRequestModel.h
//  ElongClient
//
//  Created by myiMac on 15/3/18.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongEditGuestHistoryRequestModel : eLongRequestBaseModel
/**
 *  卡号
 */
@property (nonatomic,copy) NSString *CardNo;
/**
 *  type 0:同时获取默认地址和发票抬头  1:获取默认地址 2:获取默认发票抬头
 */
@property (nonatomic,assign) NSInteger type;

@end
