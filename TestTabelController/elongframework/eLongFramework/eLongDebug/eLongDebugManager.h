//
//  eLongDebugManager.h
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongDebugNetwork.h"
#import "eLongDebugServer.h"
#import "eLongDebugPerformance.h"
#import "eLongDebugStorage.h"
#import "eLongDebugBusinessLine.h"
#import "eLongDebugAds.h"
#import "eLongDebugCrash.h"
#import "eLongDebugDeviceid.h"

@interface eLongDebugManager : NSObject
/**
 *  网络模块
 *
 *  @return
 */
+ (eLongDebugNetwork *) networkInstance;
/**
 *  服务器模块
 *
 *  @return 
 */
+ (eLongDebugServer *) serverInstance;

/**
 *  deviceId模块
 *
 *  @return
 */
+ (eLongDebugDeviceid *)deviceIdInstance;

/**
 *  性能模块
 *
 *  @return
 */
+ (eLongDebugPerformance *) performanceInstance;
/**
 *  存储模块
 *
 *  @return
 */
+ (eLongDebugStorage *) storageInstance;
/**
 *  业务模块
 *
 *  @return 
 */
+ (eLongDebugBusinessLine *) businessLineInstance;
/**
 *  广告模块
 *
 *  @return
 */
+ (eLongDebugAds *) adsInstance;

/**
 *  crash模块
 *
 *  @return
 */
+ (eLongDebugCrash *) crashInstance;
@end
