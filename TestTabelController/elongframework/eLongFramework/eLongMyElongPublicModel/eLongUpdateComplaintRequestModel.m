//
//  eLongUpdateComplaintRequestModel.m
//  ElongClient
//
//  Created by yangfan on 15/5/12.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongUpdateComplaintRequestModel.h"

@implementation eLongUpdateComplaintRequestModel

- (NSDictionary *) requestParams{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setValue:self.opType forKey:@"opType"];
    [params setValue:self.complaintId forKey:@"complaintId"];
    [params setValue:self.feedback forKey:@"feedback"];
    
    return params;
}

- (NSString *)requestBusiness{
    return  @"myelong/updateComplaint";
}

@end
