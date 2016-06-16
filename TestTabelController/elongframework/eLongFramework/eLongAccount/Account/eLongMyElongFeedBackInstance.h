//
//  eLongMyElongFeedBackInstance.h
//  eLongFramework
//  （用于客服，可取消订单的申请退款）
//  Created by yangfan on 15/11/12.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "eLongFeedbackOnlineFillRequest.h"

@interface eLongMyElongFeedBackInstance : eLongAccountInstanceBase

+(eLongMyElongFeedBackInstance *)feedBcakInstance;

#pragma mark
#pragma mark ------提交投诉相关（提交投诉，上传图片）
/**
 *  提交投诉
 *
 *  @param commitFeedBackModel 提交内容Model
 *  @param success   成功回调
 *  @param failed    失败回调
 *
 *  @return 网络持有
 */
-(eLongHTTPRequestOperation *) CommitFeedBackWithCommitFeedBackModel:(eLongFeedbackOnlineFillRequest *)commitFeedBackModel
                                                             Success:(NetSuccessCallBack)success
                                                              Failed:(NetFailedCallBack)failed;

/**
 *  在线反馈提交页面获取级联结构
 *
 *  @param success   成功回调
 *  @param failed    失败回调
 *
 *  @return 网络持有
 */
-(eLongHTTPRequestOperation *) FeedBackComplainCascadeSuccess:(NetSuccessCallBack)success Failed:(NetFailedCallBack)failed;


@end
