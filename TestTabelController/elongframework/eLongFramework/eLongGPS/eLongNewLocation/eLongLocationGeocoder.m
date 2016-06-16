//
//  eLongLocationGeocoder.m
//  TestLocation
//
//  Created by top on 15/12/30.
//  Copyright © 2015年 robotnik911. All rights reserved.
//

#import "eLongLocationGeocoder.h"
#import "eLongLocationAppleReverser.h"
#import "eLongLocationBaiduReverser.h"

@interface eLongLocationGeocoder () <eLongLocationReverserDelegate>

@property (nonatomic, strong, readwrite) CLLocation *wgs84Location;

@property (nonatomic, strong, readwrite) CLLocation *gcj02Location;

@property (nonatomic, strong, readwrite) CLLocation *bd09Location;

@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, assign, readwrite) BOOL abroad;

@property (nonatomic, copy, readwrite) NSString *currentCity;

//@property (nonatomic, strong, readwrite) CLPlacemark *currentPlacemark;
@property (nonatomic, strong, readwrite) eLongLocationAddress *address;

@property (nonatomic, copy, readwrite) NSString *simpleAddress;

@property (nonatomic, copy, readwrite) NSString *fullAddress;

@property (nonatomic, strong) NSArray *mainlandCoordinates;

@end

@implementation eLongLocationGeocoder

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray *)mainlandCoordinates{
    if (_mainlandCoordinates == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"coordinates" ofType:@"plist"];
        _mainlandCoordinates = [NSArray arrayWithContentsOfFile:path];
    }
    
    return _mainlandCoordinates;
}

//检查经纬度是否在内地
- (BOOL)outOfMainland:(CLLocationCoordinate2D)location {
    NSArray *poly = self.mainlandCoordinates;
    
    double x = location.latitude;
    double y = location.longitude;
    NSInteger index = 0;
    BOOL inside = false;
    NSDictionary *p = poly[0];
    
    CLLocationCoordinate2D prePoint = CLLocationCoordinate2DMake([[p objectForKey:@"Lat"] doubleValue], [[p objectForKey:@"Lon"] doubleValue]);
    
    for (index = 1; index < poly.count; index++)
    {
        NSDictionary *next = poly[index];
        CLLocationCoordinate2D nextPoint = CLLocationCoordinate2DMake([[next objectForKey:@"Lat"] doubleValue], [[next objectForKey:@"Lon"] doubleValue]);
        
        if (y > MIN(prePoint.longitude, nextPoint.longitude)
            && y <= MAX(prePoint.longitude, nextPoint.longitude)
            && x <= MAX(prePoint.latitude, nextPoint.latitude)
            && prePoint.longitude != nextPoint.longitude)
        {
            double xinters = (y - prePoint.longitude) * (nextPoint.longitude - prePoint.latitude) / (nextPoint.longitude - prePoint.longitude) + prePoint.latitude;
            if (prePoint.latitude == nextPoint.latitude || x <= xinters)
                inside ^= true;
        }
        prePoint = nextPoint;
    }
    
    return inside;
}

- (eLongLocationReverser *)makeReverser:(CLLocationCoordinate2D)location{
    self.abroad = [self outOfMainland:location];
    
    if (self.abroad) {
        return [[eLongLocationAppleReverser alloc] init];
    }
    
    return [[eLongLocationBaiduReverser alloc] init];
}

#pragma mark - public method
- (void)reverseGeocodeLocation:(CLLocation *)location
               completionBlock:(eLongLocationGeocoderCompletionBlock)completionBlock {
    [self reset];
    if (!location) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Location is nil.",
                                    NSLocalizedFailureReasonErrorKey: @"Location is nil." };
        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(error);
        }
        return;
    }
    self.wgs84Location = location;
    CLLocation *reverseGeocodeLocation;
    
    eLongLocationReverser<eLongLocationReverseProtocol> *reverser = [self makeReverser:self.wgs84Location.coordinate];
    reverser.delegate = self;
    
    if (!self.abroad) {
        CLLocationCoordinate2D GCJ02Coordinate = [reverser gps84_To_Gcj02WithCoordinate:self.wgs84Location.coordinate];
        CLLocation *tempGCJ02Location = [[CLLocation alloc] initWithCoordinate:GCJ02Coordinate
                                                                      altitude:self.wgs84Location.altitude
                                                            horizontalAccuracy:self.wgs84Location.horizontalAccuracy
                                                              verticalAccuracy:self.wgs84Location.verticalAccuracy
                                                                        course:self.wgs84Location.course
                                                                         speed:self.wgs84Location.speed
                                                                     timestamp:self.wgs84Location.timestamp];
        self.gcj02Location = tempGCJ02Location;
        
        CLLocationCoordinate2D bd09Coordinate = [reverser gcj02_To_Bd09WithCoordinate:self.gcj02Location.coordinate];
        self.bd09Location = [[CLLocation alloc] initWithCoordinate: bd09Coordinate
                                                         altitude:self.wgs84Location.altitude
                                               horizontalAccuracy:self.wgs84Location.horizontalAccuracy
                                                 verticalAccuracy:self.wgs84Location.verticalAccuracy
                                                           course:self.wgs84Location.course
                                                            speed:self.wgs84Location.speed
                                                        timestamp:self.wgs84Location.timestamp];
        
        reverseGeocodeLocation = self.bd09Location;
    } else {
        reverseGeocodeLocation = self.wgs84Location;
    }
    
    //开始解析地址
    [reverser startReverseWithCoordinate:reverseGeocodeLocation.coordinate];
    
//    // 保存 Device 的现语言 (英语 法语 ，，，)
//    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    // 强制 成 简体中文
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
//    
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    __weak __typeof(self) weakSelf = self;
//    [clGeoCoder reverseGeocodeLocation:reverseGeocodeLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        __typeof(weakSelf) strongSelf = weakSelf;
//        if ([placemarks count] > 0 && error == nil) {
//            [strongSelf configureDataWithPlacemarks:placemarks];
//            if (completionBlock) {
//                completionBlock(nil);
//            }
//        } else if ([placemarks count] == 0 && error == nil) {
//            NSLog(@"Found no placemarks.");
//            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Found no placemarks.",
//                                        NSLocalizedFailureReasonErrorKey: @"Found no placemarks." };
//            NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
//            if (completionBlock) {
//                completionBlock(error);
//            }
//        } else if (error != nil) {
//            NSLog(@"An error occurred = %@", error);
//            if (completionBlock) {
//                completionBlock(error);
//            }
//        }
//        // 还原Device 的语言
//        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
//    }];
}

-(void)eLongLocationReverser:(eLongLocationReverser *)reverser sucessWithResult:(eLongLocationReverseResult *)result{
    self.address = result.address;
    self.fullAddress = result.fullAddress;
    self.currentCity = result.address.city;
}

-(void)eLongLocationReverser:(eLongLocationReverser *)reverser failureWithError:(NSError *)error{
    // do nothing
}

- (void)geocodeAddressString:(NSString *)addressString
             completionBlock:(eLongLocationGeocoderCompletionBlock)completionBlock {
    [self reset];
    
    if (!addressString || ![addressString isKindOfClass:[NSString class]] || addressString.length == 0) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"AddressString is nil.",
                                    NSLocalizedFailureReasonErrorKey: @"AddressString is nil." };
        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(error);
        }
        return;
    }

    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    __weak __typeof(self) weakSelf = self;
    [myGeocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        __typeof(weakSelf) strongSelf = weakSelf;
        if ([placemarks count] > 0 && error == nil) {
            [strongSelf configureDataWithPlacemarks:placemarks];
            if (completionBlock) {
                completionBlock(nil);
            }
        } else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Found no placemarks.",
                                        NSLocalizedFailureReasonErrorKey: @"Found no placemarks." };
            NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:userInfo];
            if (completionBlock) {
                completionBlock(error);
            }
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
            if (completionBlock) {
                completionBlock(error);
            }
        }
    }];
}

#pragma mark - internal method
- (void)configureDataWithPlacemarks:(NSArray *)placemarks {
    for (CLPlacemark *placeMark in placemarks) {
        if ([placeMark.ISOcountryCode isEqualToString:@"CN"]
            ||[placeMark.ISOcountryCode  isEqualToString:@"TW"]
            ||[placeMark.ISOcountryCode  isEqualToString:@"HK"]
            ||[placeMark.ISOcountryCode  isEqualToString:@"MO"]) {
            // 中国、中国台湾、中国香港、中国澳门
            self.abroad = NO;
        } else {
            // 国外
            self.abroad = YES;
        }
        // 如果没有街道信息就显示地址全称，如果有街道信息就显示街道信息
        NSString *markName = nil;
        if (!placeMark.locality) {
            self.currentCity = placeMark.administrativeArea;
            // 处理特殊城市
            [self dealWithSpecialCitys:placeMark.administrativeArea];
            if (placeMark.thoroughfare) {
                markName = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,placeMark.thoroughfare];
            } else {
                markName = [NSString stringWithFormat:@"%@",placeMark.name];
            }
        } else {
            self.currentCity = placeMark.locality;
            // 处理特殊定位城市
            [self dealWithSpecialCitys:placeMark.locality];
            
            if (placeMark.thoroughfare) {
                markName = [NSString stringWithFormat:@"%@%@",placeMark.locality,placeMark.thoroughfare];
            } else {
                markName = [NSString stringWithFormat:@"%@",placeMark.name];
            }
        }
        self.simpleAddress = markName;
        NSArray *addressLines = [[placeMark addressDictionary] objectForKey:@"FormattedAddressLines"];
        if (addressLines && addressLines.count) {
            self.fullAddress = [addressLines componentsJoinedByString:@""];
            self.fullAddress = [self.fullAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
        }
//        self.currentPlacemark = placeMark;
    }
}

// 目前只处理香港、澳门、台湾
- (void)dealWithSpecialCitys:(NSString *)cityName {
    NSArray *specialCity = [NSArray arrayWithObjects:@"香港" ,@"Hong Kong" ,@"澳门" ,@"Macau" ,@"台湾" ,@"Taiwan", nil];
    for (int i = 0; i < specialCity.count; i++) {
        NSRange range;
        range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
        if (range.length) {
            self.currentCity = [specialCity objectAtIndex:i];
            // 恢复定位修正
            self.coordinate = self.wgs84Location.coordinate;
            break;
        }
    }
}

- (void)reset {
//    self.currentPlacemark = nil;
    self.abroad = NO;
    self.currentCity = nil;
    self.simpleAddress = nil;
    self.fullAddress = nil;
    self.wgs84Location = nil;
    self.gcj02Location = nil;
    _coordinate.latitude = 0;
    _coordinate.longitude = 0;
}

@end