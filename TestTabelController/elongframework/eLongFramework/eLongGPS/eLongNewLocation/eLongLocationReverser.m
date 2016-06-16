//
//  eLongLocationWGS84ToGCJ02.m
//  TestLocation
//
//  Created by top on 15/12/29.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import "eLongLocationReverser.h"

@implementation eLongLocationAddress

-(void)setCity:(NSString *)city{
    if ([city hasSuffix:@"市"]) {
        _city = [city substringToIndex:([city rangeOfString:@"市"]).location];
    }else if([city hasSuffix:@"县"]){
        _city = [city substringToIndex:([city rangeOfString:@"县"]).location];
    }else if([city hasSuffix:@"村"]){
        _city = [city substringToIndex:([city rangeOfString:@"村"]).location];
    }else if([city hasSuffix:@"市市辖区"]){
        _city = [city substringToIndex:([city rangeOfString:@"市市辖区"]).location];
    }else if([city hasPrefix:@"香港"]) {
        //香港，澳门
        _city = @"香港";
    }else if([city hasPrefix:@"澳门"] || [city hasPrefix:@"澳門"]) {
        _city = @"澳门";
    }else {
        _city = city;
    }
}

@end
@implementation eLongLocationReverser

const double a = 6378245.0;
const double ee = 0.00669342162296594323;
const double pi = 3.14159265358979324;

-(void)startReverseWithCoordinate:(CLLocationCoordinate2D)location{
    
}

- (CLLocationCoordinate2D)gps84_To_Gcj02WithCoordinate:(CLLocationCoordinate2D)wgsLoc {
    CLLocationCoordinate2D adjustLoc;
    if(self.outOfMainland) {
        adjustLoc = wgsLoc;
    } else {
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double radLat = wgsLoc.latitude / 180.0 * pi;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat;
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}

- (double)transformLatWithX:(double)x withY:(double)y {
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

- (double)transformLonWithX:(double)x withY:(double)y {
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

- (CLLocationCoordinate2D) transformWithLat:(double) lat withLon:(double) lon {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lon);
    if (self.outOfMainland) {
        return location;
    }
    double dLat = [self transformLatWithX:(lon - 105.0) withY: (lat - 35.0)];
    double dLon = [self transformLatWithX:(lon - 105.0) withY: (lat - 35.0)];
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return CLLocationCoordinate2DMake(mgLat, mgLon);
}

/**
 * * 火星坐标系 (GCJ-02) to 84 * * @param lon * @param lat * @return
 * */
- (CLLocationCoordinate2D) gcj_To_Gps84WithCoordinate:(CLLocationCoordinate2D)location {
    double lat = location.latitude;
    double lon = location.longitude;
    CLLocationCoordinate2D gps = [self transformWithLat:lat withLon: lon];
    double lontitude = lon * 2 - gps.longitude;
    double latitude = lat * 2 - gps.latitude;
    return CLLocationCoordinate2DMake(latitude, lontitude);
}

/**
 * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
 *
 * @param gg_lat
 * @param gg_lon
 */
- (CLLocationCoordinate2D) gcj02_To_Bd09WithCoordinate:(CLLocationCoordinate2D)location {
    double x = location.longitude, y = location.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

/**
 * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标 * * @param
 * bd_lat * @param bd_lon * @return
 */
- (CLLocationCoordinate2D) bd09_To_Gcj02WithCoordinate:(CLLocationCoordinate2D)location {
    double x = location.longitude - 0.0065, y = location.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

/**
 * (BD-09)-->84
 * @param bd_lat
 * @param bd_lon
 * @return
 */
- (CLLocationCoordinate2D) bd09_To_Gps84WithCoordinate:(CLLocationCoordinate2D)location {
    
    CLLocationCoordinate2D gcj02 = [self bd09_To_Gcj02WithCoordinate:location];
    CLLocationCoordinate2D map84 = [self gcj_To_Gps84WithCoordinate:gcj02];
    return map84;
}

@end
