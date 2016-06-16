//
//  eLongUpdateComplaintRequestModel.h
//  ElongClient
//
//  Created by yangfan on 15/5/12.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"

@interface eLongUpdateComplaintRequestModel : eLongRequestBaseModel

@property (nonatomic, copy) NSString * opType; // 操作类型：1.是否满意；2.撤销投诉；
@property (nonatomic, copy) NSString * complaintId; // 投诉的id，详情会返回
@property (nonatomic, copy) NSString * feedback; // 1. 满意，2.不满意，opType=1时必填
@property (nonatomic, copy) NSString * complaintDescription; // 投诉描述
//@property (nonatomic, copy) NSString * operator;// 操作人
@property (nonatomic, copy) NSString * opip; // 操作Ip

@end
