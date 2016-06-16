//
//  eLongLocationRequestDefines.h
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#ifndef eLongLocationRequestDefines_h
#define eLongLocationRequestDefines_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static const CLLocationAccuracy kHorizontalAccuracyThresholdCity =         5000.0;  // in meters
static const CLLocationAccuracy kHorizontalAccuracyThresholdNeighborhood = 1000.0;  // in meters
static const CLLocationAccuracy kHorizontalAccuracyThresholdBlock =         100.0;  // in meters
static const CLLocationAccuracy kHorizontalAccuracyThresholdHouse =          15.0;  // in meters
static const CLLocationAccuracy kHorizontalAccuracyThresholdRoom =            5.0;  // in meters

static const NSTimeInterval kUpdateTimeStaleThresholdCity =             600.0;  // in seconds
static const NSTimeInterval kUpdateTimeStaleThresholdNeighborhood =     300.0;  // in seconds
static const NSTimeInterval kUpdateTimeStaleThresholdBlock =             60.0;  // in seconds
static const NSTimeInterval kUpdateTimeStaleThresholdHouse =             15.0;  // in seconds
static const NSTimeInterval kUpdateTimeStaleThresholdRoom =               5.0;  // in seconds

/**
 *  定位服务的状态
 */
typedef NS_ENUM(NSInteger, eLongLocationServicesState) {
    /**
     *  可用
     */
    eLongLocationServicesStateAvailable,
    /**
     *  未决定
     */
    eLongLocationServicesStateNotDetermined,
    /**
     *  否定
     */
    eLongLocationServicesStateDenied,
    /**
     *  受限制(父母限制等)
     */
    eLongLocationServicesStateRestricted,
    /**
     *  不可用
     */
    eLongLocationServicesStateDisabled
};
/**
 *  定位精准度
 */
typedef NS_ENUM(NSInteger, eLongLocationAccuracy) {
    /**
     *  无限制 大于5公里范围，多于10分钟接收位置信息变化
     */
    eLongLocationAccuracyNone = 0,
    /**
     *  5公里范围，10分钟接收位置信息变化
     */
    eLongLocationAccuracyCity,
    /**
     *  1公里范围，5分钟内接收位置信息变化
     */
    eLongLocationAccuracyNeighborhood,
    /**
     *  100米范围，1分钟内接收位置信息变化
     */
    eLongLocationAccuracyBlock,
    /**
     *  15米范围，15秒内接收位置信息变化
     */
    eLongLocationAccuracyHouse,
    /**
     *  5米范围，5秒内接收位置信息变化
     */
    eLongLocationAccuracyRoom,
};
/**
 *  block回调返回的定位状态
 */
typedef NS_ENUM(NSInteger, eLongLocationStatus) {
    /**
     *  成功
     */
    eLongLocationStatusSuccess = 0,
    /**
     *  超时
     */
    eLongLocationStatusTimedOut,
    /**
     *  未确定
     */
    eLongLocationStatusServicesNotDetermined,
    /**
     *  否定
     */
    eLongLocationStatusServicesDenied,
    /**
     *  受限制(父母限制等)
     */
    eLongLocationStatusServicesRestricted,
    /**
     *  不可用
     */
    eLongLocationStatusServicesDisabled,
    /**
     *  错误
     */
    eLongLocationStatusError
};
/**
 *  请求位置的回调BLOCK
 *
 *  @param currentLocation  位置信息
 *  @param achievedAccuracy 精准度
 *  @param status           定位状态
 */
typedef void(^eLongLocationRequestBlock)(CLLocation *currentLocation, eLongLocationAccuracy achievedAccuracy, eLongLocationStatus status);
/**
 *  请求位置对象的ID
 */
typedef NSInteger eLongLocationRequestID;

#endif /* eLongLocationRequestDefines_h */
