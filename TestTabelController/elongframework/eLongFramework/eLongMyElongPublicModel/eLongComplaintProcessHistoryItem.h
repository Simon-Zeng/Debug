//
//  eLongComplaintProcessHistoryItem.h
//  ElongClient
//
//  Created by yangfan on 15/5/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"

@protocol eLongComplaintProcessHistoryItem @end

@interface eLongComplaintProcessHistoryItem : eLongResponseBaseModel

@property (nonatomic, strong) NSNumber * complaintId; // 投诉id
@property (nonatomic, copy) NSString * opTime; // 操作时间
@property (nonatomic, copy) NSString * processMappingName; // 投诉状态名称
@property (nonatomic, copy) NSString * processStatusName; // 处理状态名称

@end
