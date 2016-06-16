//
//  eLongLocationGeocoder.h
//  TestLocation
//
//  Created by top on 15/12/30.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "eLongLocationReverser.h"

typedef void(^eLongLocationGeocoderCompletionBlock)(NSError *error);

@interface eLongLocationGeocoder : NSObject
/**
 *  未处理过的当前位置
 */
@property (nonatomic, strong, readonly) CLLocation *wgs84Location;
/**
 *  转成国内可识别坐标系后的当前位置
 */
@property (nonatomic, strong, readonly) CLLocation *gcj02Location;
/**
 *  转成百度坐标系后的当前位置
 */
@property (nonatomic, strong, readonly) CLLocation *bd09Location;
/**
 *  当前位置坐标（针对不同区域处理后的坐标）
 */
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;
/**
 *  当前位置是否在国外
 */
@property (nonatomic, assign, readonly) BOOL abroad;
/**
 *  当前定位城市
 */
@property (nonatomic, copy, readonly) NSString *currentCity;
/**
 *  当前定位的行政信息
 */
//@property (nonatomic, strong, readonly) CLPlacemark *currentPlacemark;
@property (nonatomic, strong, readonly) eLongLocationAddress *address;
/**
 *  当前定位地址简写
 */
//@property (nonatomic, copy, readonly) NSString *simpleAddress;
/**
 *  当前定位地址全称
 */
@property (nonatomic, copy, readonly) NSString *fullAddress;
/**
 *  定位信息反解析
 *
 *  @param location        定位信息
 *  @param completionBlock 回调
 */
- (void)reverseGeocodeLocation:(CLLocation *)location
               completionBlock:(eLongLocationGeocoderCompletionBlock)completionBlock;
/**
 *  地址信息反解析
 *
 *  @param addressString   地址信息
 *  @param completionBlock 回调
 */
- (void)geocodeAddressString:(NSString *)addressString
             completionBlock:(eLongLocationGeocoderCompletionBlock)completionBlock;

@end
