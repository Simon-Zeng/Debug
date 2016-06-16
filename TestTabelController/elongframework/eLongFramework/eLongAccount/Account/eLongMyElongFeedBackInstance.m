//
//  eLongMyElongFeedBackInstance.m
//  eLongFramework
//
//  Created by yangfan on 15/11/12.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongMyElongFeedBackInstance.h"

@implementation eLongMyElongFeedBackInstance

+(eLongMyElongFeedBackInstance *)feedBcakInstance{
    static eLongMyElongFeedBackInstance *user_Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user_Instance = [[eLongMyElongFeedBackInstance alloc] init];
    });
    return user_Instance;
}

#pragma mark
#pragma mark ------提交投诉相关（提交投诉，上传图片）

-(eLongHTTPRequestOperation *) CommitFeedBackWithCommitFeedBackModel:(eLongFeedbackOnlineFillRequest *)commitFeedBackModel
                                                             Success:(NetSuccessCallBack)success
                                                              Failed:(NetFailedCallBack)failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[commitFeedBackModel requestBusiness]
                             params:[commitFeedBackModel requestParams]
                             method:eLongNetworkRequestMethodGET];
    return [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(eLongHTTPRequestOperation *) FeedBackComplainCascadeSuccess:(NetSuccessCallBack)success
                                                       Failed:(NetFailedCallBack)failed{
    NSDictionary *dic = @{};
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self requestComplainCascadeListBusiness]
                             params:dic
                             method:eLongNetworkRequestMethodGET];
    return [eLongHTTPRequest startRequest:request success:success failure:failed];
}


//级联
- (NSString *) requestComplainCascadeListBusiness{
    return @"myelong/getComplaintDict";
}


@end
