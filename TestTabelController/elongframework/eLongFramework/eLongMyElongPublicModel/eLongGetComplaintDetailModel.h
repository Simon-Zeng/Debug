//
//  eLongGetComplaintDetailModel.h
//  ElongClient
//
//  Created by yangfan on 15/5/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongResponseBaseModel.h"
#import "eLongComplaintProcessHistoryItem.h"

@interface eLongGetComplaintDetailModel : eLongResponseBaseModel

@property (nonatomic, copy) NSString * cardNo; // 卡号
@property (nonatomic, copy) NSString * categoryCode; // 一级类别code
@property (nonatomic, copy) NSString * categoryName; // 一级类别名称
@property (nonatomic, copy) NSString * complaintFrom; // 来源
@property (nonatomic, copy) NSString * complaintStatusCode; // 投诉状态code
@property (nonatomic, copy) NSString * complaintStatusName; // 投诉状态名称
@property (nonatomic, copy) NSString * contentCode; // 二级类别code
@property (nonatomic, copy) NSString * contentName; // 二级状态名称
@property (nonatomic, copy) NSString * createTime;  // 创建时间
@property (nonatomic, copy) NSString * complaintDescription; // 投诉内容
@property (nonatomic, copy) NSString * feedBack; // 反馈结果
@property (nonatomic, copy) NSString * complaintId; // 投诉结果id
@property (nonatomic, copy) NSString * mobileNo; // 手机号
@property (nonatomic, copy) NSString * orderId;  // 订单号
@property (nonatomic, copy) NSString * processStatusCode; // 问题环节code
@property (nonatomic, copy) NSString * processStatusName; // 处理进度中文描述，例如：问题结案
@property (nonatomic, copy) NSString * opTime; // 操作时间
@property (nonatomic, copy) NSString * productCategory; // 产品线
@property (nonatomic, strong) NSArray<eLongComplaintProcessHistoryItem> * processHistory; // 投诉处理历史列表

// 不是接口得到的数据，从上一页面传下来的数据
@property (nonatomic, copy) NSString * hotelName; // 酒店名称
@property (nonatomic, copy) NSString * arriveDate; // 入店日期
@property (nonatomic, copy) NSString * leaveDate;  // 离店日期
@end
