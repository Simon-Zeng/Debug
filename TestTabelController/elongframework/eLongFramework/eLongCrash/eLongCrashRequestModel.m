//
//  eLongCrashRequestModel.m
//  ElongClient
//  
//  Created by 张馨允 on 15/4/17.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCrashRequestModel.h"

@implementation eLongCrashRequestModel

- (NSString *)requestBusiness{
    return @"hotel-other/saveCrash";
}

- (NSDictionary *) requestParams{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:self.pageName forKey:@"PageName"];
    [param setValue:self.exceptionName forKey:@"ExceptionName"];
    [param setValue:[NSNumber numberWithInteger:self.exceptionType] forKey:@"ExceptionType"];
    [param setValue:self.exceptionsStackDetail forKey:@"ExceptionsStackDetail"];
    [param setValue:self.appVersion forKey:@"AppVersion"];
    [param setValue:self.osVersion forKey:@"OsVersion"];
    [param setValue:self.deviceModel forKey:@"DeviceModel"];
    [param setValue:[NSNumber numberWithInteger:self.netWorkType] forKey:@"NetWorkType"];
    [param setValue:self.deviceStatus forKey:@"DeviceStatus"];
    [param setValue:self.channelId forKey:@"ChannelId"];
    [param setValue:[NSNumber numberWithInteger:self.clientType] forKey:@"ClientType"];
    [param setValue:self.netWorkCarrier forKey:@"NetWorkCarrier"];
    [param setValue:self.crashTime forKey:@"CrashTime"];
    [param setValue:self.appName forKey:@"AppName"];
    [param setValue:self.eLongAccount forKey:@"ELongAccount"];
    [param setValue:self.phoneNumber forKey:@"PhoneNumber"];
    [param setValue:self.deviceId forKey:@"DeviceId"];
    
    return param;
}
@end
