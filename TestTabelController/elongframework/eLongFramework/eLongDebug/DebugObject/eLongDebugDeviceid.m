//
//  eLongDebugDeviceid.m
//  eLongFramework
//
//  Created by Dean on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongDebugDeviceid.h"
#import "eLongDebugDB.h"

static NSString *deviceidDebugModelName = @"DeviceID";        // deviceid储数据表名


@implementation eLongDebugDeviceid
@synthesize deviceidModel = _deviceidModel;
/**
 *  添加deviceId
 *
 *  @param name deviceId名字
 *  @param deviceid  deviceId
 *
 */
- (eLongDebugDeviceIdModel *)addDeviceIdName:(NSString *)name deviceid:(NSString *)deviceid
{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    
    // 先读取所有的deviceid标记为禁用状态
    NSArray *deviceids = [self deviceids];
    for (eLongDebugDeviceIdModel *deviceidModel in deviceids) {
        deviceidModel.enabled = @(NO);
    }
    
    // 新增deviceid model
    eLongDebugDeviceIdModel *deviceidModel = [debugDB insertEntity:deviceidDebugModelName];
    deviceidModel.name = name;
    deviceidModel.deviceid = deviceid;
    deviceidModel.enabled = @(YES);
    
    // 存储入库
    [debugDB saveContext];
    _deviceidModel = deviceidModel;
    return deviceidModel;
}

/**
 *  移除deviceid
 *
 */
- (void) removeDeviceid:(eLongDebugDeviceIdModel *)deviceidModel{
    if (!self.enabled) {
        return;
    }
    if (_deviceidModel == deviceidModel) {
        _deviceidModel = nil;
    }
    
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB remove:deviceidModel];
    
    [debugDB saveContext];
}

/**
 *  返回所有的deviceid
 */
- (NSArray *)deviceids{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    NSArray *deviceids = [debugDB selectDataFromEntity:deviceidDebugModelName query:nil];
    if (deviceids && deviceids.count) {
        for (eLongDebugDeviceIdModel *deviceidModel in deviceids) {
            if ([deviceidModel.enabled boolValue]) {
                _deviceidModel = deviceidModel;
            }
        }
        return deviceids;
    }else{
        return nil;
    }
}

- (NSString *)deviceid{
    if (self.enabled) {
        if (self.deviceidModel) {
            return self.deviceidModel.deviceid;
        }else{
            [self deviceids];
            if (self.deviceidModel) {
                return self.deviceidModel.deviceid;
            }
            return nil;
        }
    }else{
        return nil;
    }
}


/**
 *  保存
 *
 *  @param  deviceid Model
 */
- (void) saveDeviceId:(eLongDebugDeviceIdModel *)deviceidModel{
    if (!self.enabled) {
        return;
    }
    if ([deviceidModel.enabled boolValue]) {
        _deviceidModel = deviceidModel;
    }else if(_deviceidModel == deviceidModel){
        _deviceidModel = nil;
    }
    eLongDebugDB *debugDB = [eLongDebugDB shareInstance];
    [debugDB saveContext];
}

@end
