//
//  eLongCountlyEventClick.m
//  ElongClient
//
//  Created by top on 15/3/31.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongCountlyEventClick.h"
#import "Countly.h"

@implementation eLongCountlyEventClick

- (void)sendEventCount:(NSInteger)count{
    [super sendEvent:@"click" count:count];
}

- (id) init{
    if (self = [super init]) {
        self.status = @([Countly sharedInstance].status);
    }
    return self;
}

@end
