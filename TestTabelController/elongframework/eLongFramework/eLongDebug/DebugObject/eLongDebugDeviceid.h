//
//  eLongDebugDeviceid.h
//  eLongFramework
//
//  Created by Dean on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugDeviceIdModel.h"

#define ELONDEBUG_NOTI_DEVICEIDCHANGED   @"ELONDEBUG_NOTI_DEVICEIDCHANGED"    // 设备ID变更

@interface eLongDebugDeviceid : eLongDebugObject
@property (nonatomic,strong,readonly) eLongDebugDeviceIdModel *deviceidModel;
@property (nonatomic,strong,readonly) NSString *deviceid;
/**
 *  添加deviceId
 *
 *  @param name deviceId名字
 *  @param deviceid  deviceId
 *
 *  @return
 */
- (eLongDebugDeviceIdModel *)addDeviceIdName:(NSString *)name deviceid:(NSString *)deviceid;

/**
 *  移除deviceid
 *
 *  @param deviceidModel  deviceid Model
 */
- (void)removeDeviceid:(eLongDebugDeviceIdModel *)deviceidModel;

/**
 *  返回所有的可用的deviceid
 */
- (NSArray *)deviceids;

/**
 *  保存
 *
 *  @param deviceid Model
 */
- (void)saveDeviceId:(eLongDebugDeviceIdModel *)deviceidModel;

@end
