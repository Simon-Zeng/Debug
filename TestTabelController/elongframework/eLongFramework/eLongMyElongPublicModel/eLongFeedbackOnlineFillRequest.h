//
//  eLongFeedbackOnlineFillRequest.h
//  ElongClient
//
//  Created by lvyue on 15/5/5.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongRequestBaseModel.h"

@interface eLongFeedbackOnlineFillRequest : eLongRequestBaseModel

/**
 *  问题环节编码，即级联返回当中对应类别为"problem"，例如：2002
 */
@property (nonatomic, assign) NSInteger categoryCode;
/**
 *  问题分类编码，即级联返回当中对应类别为"category"，例如：20
 */
@property (nonatomic, assign) NSInteger contentCode;
/**
 *  描述
 */
@property (nonatomic, copy) NSString *complaintDescription;
/**
 *  1--web 网站  2--mobile移动
 */
@property (nonatomic, assign) NSInteger complaintFrom;
/**
 *  1.hotel 国内酒店2.group 团购3.globle 国际酒店	4.air机票
 */
@property (nonatomic, assign) NSInteger productCategory;
/**
 *  附加信息
 */
@property (nonatomic, copy) NSString *attachments;
/**
 *  订单号
 */
@property (nonatomic, copy) NSString *orderId;
/**
 *  操作者
 */
@property (nonatomic, copy) NSString *operator;
/**
 *  操作者
 */
@property (nonatomic, copy) NSString *opip;

#pragma remark - 申诉专用字段
/**
 *  申诉类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 * 申述取消订单类型 1:扣部分款 2：扣全款
 */
@property (nonatomic, assign) NSInteger cancelOrderType;
@end
