//
//  eLongPostHeader.m
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongPostHeader.h"
#import "eLongDefineCommon.h"
#import <AdSupport/AdSupport.h>
#import "eLongTokenReq.h"
#import "eLongTokenConfig.h"
#import "eLongDeviceUtil.h"
#import "ABNotifier.h"
#import "eLongExtension.h"
#import "eLongNetworkRequest.h"
#import"eLongDefine.h"

static NSMutableDictionary *header = nil;

@implementation eLongPostHeader
+ (NSMutableDictionary *)header  {
	
	@synchronized(self) {
		if(!header) {
			header = [[NSMutableDictionary alloc] init];
            ABNotifier * sharedNotifier = [ABNotifier shared];
			[header safeSetObject:sharedNotifier.channelID forKey:@"ChannelId"];
			[header safeSetObject:[eLongDeviceUtil macaddress] forKey:@"DeviceId"];
			[header safeSetObject:[NSNull null] forKey:@"AuthCode"];
			[header safeSetObject:[eLongNetworkRequest sharedInstance].clientType forKey:@"ClientType"];
			[header safeSetObject:APP_VERSION forKey:@"Version"];
            
            NSString *userTraceID = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_HTTPMONITOR_USERTRACEID];
            if (!userTraceID) {
                userTraceID = @"";
            }
            [header safeSetObject:userTraceID forKey:@"UserTraceId"];
			NSString *osver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
			[header safeSetObject:osver forKey:@"OsVersion"];
            
//            if (IOSVersion_7) {
                if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
                {
                    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                    [header safeSetObject:idfaStr forKey:@"Guid"];
                } 
//            }
            
            // 额外字段
            [header safeSetObject:[eLongDeviceUtil device] forKey:@"PhoneModel"];
            [header safeSetObject:@"iPhone" forKey:@"PhoneBrand"];
		}
	}
    // session iD
    ABNotifier * sharedNotifier = [ABNotifier shared];

    [header safeSetObject:[[eLongTokenReq shared] sessionToken] forKey:SESSION_TOKEN];
    [header safeSetObject:sharedNotifier.channelID forKey:@"ChannelId"];
    
    // 放抓取验证码
    if ([[eLongTokenReq shared] checkCode]) {
        [header safeSetObject:[[eLongTokenReq shared] checkCode] forKey:@"CheckCode"];
    }
    
    
    //NSLog(@"header:%@", [header JSONRepresentation]);
    
	return header;
}
@end
