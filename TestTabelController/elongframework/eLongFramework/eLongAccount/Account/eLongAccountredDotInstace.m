//
//  eLongAccountredDotInstace.m
//  ElongClient
//
//  Created by lvyue on 15/4/8.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountredDotInstace.h"
#import "NSString+eLongExtension.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"
@implementation eLongAccountredDotInstace

-(void)requestRedDotWithPCardNo:(NSString *)cardNo Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self redDotBusiness]
                             params:[self getRequestParamWithCardNo:cardNo]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

- (NSDictionary *)getRequestParamWithCardNo:(NSString *)cardNo{
    if (!STRINGHASVALUE(cardNo)) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:cardNo forKey:@"cardNo"];
    [dic safeSetObject:@(2) forKey:@"waiting4PayScope"];
    return dic;
}

-(NSString *)redDotBusiness{
    return @"myelong/getAboutHotelOrderNum";
}

@end
