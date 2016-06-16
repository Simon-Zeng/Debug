//
//  eLongLocation.h
//  ElongClient
//
//  Created by Dawn on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define ELONGLOCATION_NOTI_LOCATIONUPDATED  @"ELONGLOCATION_NOTI_LOCATIONUPDATED"       // 定位位置发生变化
#define ELONGLOCATION_NOTI_ADDRESSUPDATED   @"ELONGLOCATION_NOTI_ADDRESSUPDATED"        // 定位地址解析成功
#define ELONGLOCATION_NOTI_LOCATION_FAILURE   @"ELONGLOCATION_NOTI_LOCATION_FAILURE"    // 定位失败

/**
 *  当前定位状态
 */
typedef NS_ENUM(NSUInteger, eLongLocationState){
    /**
     *  定位开启
     */
    eLongLocationStateStarted,
    /**
     *  定位结束，主动结束定位
     */
    eLongLocationStateStoped,
    /**
     *  定位已更新
     */
    eLongLocationStateUpdated,
    /**
     *  定位失败
     */
    eLongLocationStateFailed,
    /**
     *  定位不可用
     */
    eLongLocationStateDiabled,
    /**
     *  用户拒绝定位
     */
    eLongLocationStateDenied
};

@protocol eLongPositionManagerDelegate <NSObject>

- (void)getPositionInfoBack:(NSDictionary *)dicPosition;

@end

@interface eLongLocation : NSObject
/**
 *  当前定位坐标点
 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
/**
 *  当前定位精度
 */
@property (nonatomic,assign) CLLocationDistance accuracy;
/**
 *  当前定位的状态
 */
@property (nonatomic,assign) eLongLocationState locationState;
/**
 *  当前位置是否在国外
 */
@property (nonatomic,assign) BOOL abroad;
/**
 *  当前定位城市
 */
@property (nonatomic,copy) NSString *currentCity;
/**
 *  当前地理定位到的城市，不做任何处理!
 */
@property (nonatomic,copy) NSString *positionCity;
/**
 *  当前定位地址简写
 */
@property (nonatomic,copy) NSString *simpleAddress;
/**
 *  当前定位地址全称
 */
@property (nonatomic,copy) NSString *fullAddress;
/**
 *  当前定位的位置精度
 */
@property (nonatomic,assign) CLLocationAccuracy horizontalAccuracy;
/**
 *  当前定位的特殊城市
 */
@property (nonatomic,strong) NSString *specialCity;
/**
 *  当前定位管理者的代理
 */
@property (nonatomic, weak) id<eLongPositionManagerDelegate> delegate;
/**
 *  当前是否在gps定位中
 */
@property (nonatomic, assign) BOOL isGpsing;
/**
 *  当前是否没有找到城市名字
 */
@property (nonatomic, assign) BOOL isNotFindCityName;
/**
 *  当前定位服务状态
 */
@property (nonatomic, assign) CLAuthorizationStatus stateLocation;
/**
 *  当前定位的行政信息
 */
@property (nonatomic, strong) CLPlacemark *currentPlacemark;

/**
 *  单例
 *
 *  @return
 */
+ (instancetype)sharedInstance;
/**
 *  开启定位，启动后不会自行终止，直道stopLocation
 */
- (void) startLocation;
/**
 *  开启定位，定位结束后自行终止
 */
- (void) startLocationAutoStop;
/**
 *  结束定位
 */
- (void) stopLocation;
/**
 *  无网环境下获取当前城市
 */
- (NSString *)getCurrentCityWithoutNetwork;
/**
 *  从地址名获取位置信息
 */
- (void)getPositionFromAddress:(NSString *)addressName;
/**
 *  正在定位的状态
 */
- (BOOL)getPositionBool;
/**
 *  获得当前城市名称
 */
- (NSString *)getCurrentCityName;
/**
 *  获得当前所在省名称
 */
- (NSString *)getCurrentProvinceName;


@end
