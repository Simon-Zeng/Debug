//
//  eLongCountlyEventShow.m
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventShow.h"
#import "Countly.h"

@implementation eLongCountlyEventShow

- (void)sendEventCount:(NSInteger)count {
    [super sendEvent:@"show" count:count];
}

- (id) init{
    if (self = [super init]) {
        self.channelId = [Countly sharedInstance].channelId;
        self.appt = [Countly sharedInstance].appt;
        self.status = @([Countly sharedInstance].status);
    }
    return self;
}

@end
