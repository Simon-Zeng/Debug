//
//  eLongFeedbackOnlineFillRequest.m
//  ElongClient
//
//  Created by lvyue on 15/5/5.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongFeedbackOnlineFillRequest.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongFeedbackOnlineFillRequest

- (NSDictionary *)requestParams{
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic safeSetObject:_attachments forKey:@"attachments"];
    [requestDic safeSetObject:@(_categoryCode) forKey:@"categoryCode"];
    [requestDic safeSetObject:@(_contentCode) forKey:@"contentCode"];
    [requestDic safeSetObject:_complaintDescription forKey:@"complaintDescription"];
    [requestDic safeSetObject:@(_complaintFrom) forKey:@"complaintFrom"];
    [requestDic safeSetObject:@(_productCategory) forKey:@"productCategory"];
    NSString *cardNo = [[eLongAccountManager  userInstance] cardNo];
    NSString *phoneNum =[[eLongAccountManager  userInstance] phoneNo];
    [requestDic safeSetObject:cardNo forKey:@"CardNo"];
    [requestDic safeSetObject:phoneNum forKey:@"mobile"];
    [requestDic safeSetObject:_orderId forKey:@"orderId"];
    [requestDic safeSetObject:_operator forKey:@"operator"];
    [requestDic safeSetObject:_opip forKey:@"opip"];
    [requestDic safeSetObject:@(_type) forKey:@"type"];
    [requestDic safeSetObject:@(_cancelOrderType) forKey:@"cancelOrderType"];
    return requestDic;
}

- (NSString *)requestBusiness{
    return  @"myelong/addComplaint";
}

@end
