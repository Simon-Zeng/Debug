//
//  eLongDebugManager.m
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugManager.h"


@implementation eLongDebugManager
+ (eLongDebugNetwork *) networkInstance{
    static eLongDebugNetwork *debugNetwork = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugNetwork = [[eLongDebugNetwork alloc] init];
    });
    return debugNetwork;
}

+ (eLongDebugServer *) serverInstance{
    static eLongDebugServer *debugServer = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugServer = [[eLongDebugServer alloc] init];
    });
    return debugServer;
}

+ (eLongDebugDeviceid *)deviceIdInstance
{
    static eLongDebugDeviceid *debugDeviceId = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugDeviceId = [[eLongDebugDeviceid alloc] init];
    });
    return debugDeviceId;
}


+ (eLongDebugPerformance *) performanceInstance{
    static eLongDebugPerformance *debugPerformance = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugPerformance = [[eLongDebugPerformance alloc] init];
    });
    return debugPerformance;
}

+ (eLongDebugStorage *) storageInstance{
    static eLongDebugStorage *debugStorage = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugStorage = [[eLongDebugStorage alloc] init];
    });
    return debugStorage;
}

+ (eLongDebugBusinessLine *) businessLineInstance{
    static eLongDebugBusinessLine *debugBusinessLine = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugBusinessLine = [[eLongDebugBusinessLine alloc] init];
    });
    return debugBusinessLine;
}

+ (eLongDebugAds *) adsInstance{
    static eLongDebugAds *debugAds = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugAds = [[eLongDebugAds alloc] init];
    });
    return debugAds;
}

+ (eLongDebugCrash *) crashInstance{
    static eLongDebugCrash *crash = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        crash = [[eLongDebugCrash alloc] init];
    });
    return crash;
}
@end
