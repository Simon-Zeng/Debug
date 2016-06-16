//
//  eLongOrderGetPenaltyInfoRequestModel.m
//  ElongClient
//
//  Created by zhaolina on 15/7/9.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongOrderGetPenaltyInfoRequestModel.h"
#import "eLongExtension.h"

@implementation eLongOrderGetPenaltyInfoRequestModel

- (NSString *)requestBusiness{
    return @"myelong/getPenaltyInfo";
}

- (NSDictionary *) requestParams{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:self.orderId forKey:@"orderId"];
//    [param safeSetObject:self.cancelTime forKey:@"cancelTime"];
    [param safeSetObject:[NSNumber numberWithInteger:self.payment]  forKey:@"payment"];
    [param safeSetObject:[NSNumber numberWithInteger:self.vouchSetCode] forKey:@"vouchSetCode"];
    [param safeSetObject:self.stateCode forKey:@"stateCode"];
    return param;
}
@end
