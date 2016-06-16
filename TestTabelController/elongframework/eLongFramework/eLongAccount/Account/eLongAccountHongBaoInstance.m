//
//  eLongAccountHongBaoInstance.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountHongBaoInstance.h"

@implementation eLongAccountHongBaoInstance

-(void)requestTheHongBaoRecordsWithCardNo:(NSString *)cardNo
                                PageIndex:(NSInteger)index
                                 PageSize:(NSInteger)size
                                Successed:(NetSuccessCallBack)success
                                   Failed:(NetFailedCallBack)failed{

    NSDictionary *req = @{@"CardNo":cardNo,@"PageSize":@(size),@"PageIndex":@(index)};
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance] javaRequest:@"myelong/getBonusRecords"
                                                                       params:req
                                                                       method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}
@end
