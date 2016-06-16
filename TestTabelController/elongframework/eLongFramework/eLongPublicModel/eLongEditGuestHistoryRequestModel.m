//
//  eLongEditGuestHistoryRequestModel.m
//  ElongClient
//
//  Created by myiMac on 15/3/18.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongEditGuestHistoryRequestModel.h"
#import "eLongExtension.h"

@implementation eLongEditGuestHistoryRequestModel
- (NSString *)requestBusiness{
    return @"myelong/getDefaultGuestHistory";
}

- (NSDictionary *) requestParams{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:self.CardNo forKey:@"CardNo"];
    [param safeSetObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    return param;
}
@end
