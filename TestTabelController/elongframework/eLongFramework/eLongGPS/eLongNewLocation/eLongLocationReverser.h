//
//  eLongLocationWGS84ToGCJ02.h
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

///此类表示地址结果的层次化信息
@interface eLongLocationAddress : NSObject

/// 街道号码
@property (nonatomic, strong) NSString* streetNumber;
/// 街道名称
@property (nonatomic, strong) NSString* streetName;
/// 区县名称
@property (nonatomic, strong) NSString* district;
/// 城市名称
@property (nonatomic, strong) NSString* city;
/// 省份名称
@property (nonatomic, strong) NSString* province;

@property (nonatomic, strong) NSString* country;

@end

@interface eLongLocationReverseResult : NSObject
@property (nonatomic, strong) eLongLocationAddress *address;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *fullAddress;
@end

@protocol eLongLocationReverseProtocol <NSObject>

- (void) startReverseWithCoordinate:(CLLocationCoordinate2D)location;

@end

@class eLongLocationReverser;

@protocol eLongLocationReverserDelegate <NSObject>

- (void) eLongLocationReverser:(eLongLocationReverser*)reverser sucessWithResult:(eLongLocationReverseResult *)result;

- (void) eLongLocationReverser:(eLongLocationReverser*)reverser failureWithError:(NSError *)error;

@end

@interface eLongLocationReverser : NSObject<eLongLocationReverseProtocol>

@property (nonatomic, weak) id<eLongLocationReverserDelegate> delegate;
// 是否在内地
@property (nonatomic, assign) BOOL outOfMainland;

/**
 * 84 to 火星坐标系 (GCJ-02) World Geodetic System ==> Mars Geodetic System
 *
 * @param lat
 * @param lon
 * @return
 */
-(CLLocationCoordinate2D)gps84_To_Gcj02WithCoordinate:(CLLocationCoordinate2D)location;

/**
 * * 火星坐标系 (GCJ-02) to 84 
 * 
 * @param lon 
 * @param lat 
 * @return
 * */
-(CLLocationCoordinate2D) gcj_To_Gps84WithCoordinate:(CLLocationCoordinate2D)location;

/**
 * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
 *
 * @param gg_lat
 * @param gg_lon
 */
-(CLLocationCoordinate2D) gcj02_To_Bd09WithCoordinate:(CLLocationCoordinate2D)location;

/**
 * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标 
 *
 * @param
 * bd_lat 
 * @param bd_lon * @return
 */
-(CLLocationCoordinate2D) bd09_To_Gcj02WithCoordinate:(CLLocationCoordinate2D)location;

/**
 * (BD-09)-->84
 * @param bd_lat
 * @param bd_lon
 * @return
 */
-(CLLocationCoordinate2D) bd09_To_Gps84WithCoordinate:(CLLocationCoordinate2D)location;

@end
