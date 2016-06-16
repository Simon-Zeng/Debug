//
//  eLongLocation.m
//  ElongClient
//
//  Created by Dawn on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "NSString+eLongExtension.h"

@interface eLongLocation()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *originalLocation;
@property (nonatomic,assign) BOOL autoStop;
@property (nonatomic,assign) BOOL isPosition;

@end


@implementation eLongLocation
@synthesize currentCity = _currentCity;
@synthesize isGpsing = _isGpsing;
@synthesize positionCity = _positionCity;

+ (instancetype) sharedInstance{
    static eLongLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[eLongLocation alloc] init];
    });
    return location;
}

- (id) init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        // 10m的精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter  = 10;  // 移动刷新距离10m
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = NO;
        }
        self.horizontalAccuracy = self.locationManager.location.horizontalAccuracy;
        self.isPosition = NO;
        self.isGpsing = YES;
        self.isNotFindCityName = YES;
        self.positionCity = @"";
    }
    return self;
}

- (CLAuthorizationStatus)stateLocation
{
    CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
    return state;
}

- (void) startLocation {
    // 自动停止关闭
    self.autoStop = NO;
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        // 设置状态为“已开始”
        self.locationState = eLongLocationStateStarted;
    }else {
        NSLog(@"Location services not enabled");
        // 设置状态为“禁用”
        self.locationState = eLongLocationStateDiabled;
    }
}

- (void) startLocationAutoStop{
    // 自动停止开启
    self.autoStop = YES;
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        // 设置状态为“已开始”
        self.locationState = eLongLocationStateStarted;
    }else {
        NSLog(@"Location services not enabled");
        // 设置状态为“禁用”
        self.locationState = eLongLocationStateDiabled;
    }
}

- (void) stopLocation {
    // 设置状态为“已停止”
    self.locationState = eLongLocationStateStoped;
    [self.locationManager stopUpdatingLocation];
}



#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
            break;
        case kCLAuthorizationStatusDenied: {
            // 设置状态为“拒绝”
            self.locationState = eLongLocationStateDenied;
        }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    // 记录下来最原始的坐标，方便纠偏以后恢复使用
    self.originalLocation = newLocation;
    self.accuracy = MAX(newLocation.verticalAccuracy, newLocation.horizontalAccuracy);
    
    CLLocationCoordinate2D mNewLocation; // 火星坐标
    
    double lon = newLocation.coordinate.longitude;
    double lat = newLocation.coordinate.latitude;
    
    const double a = 6378245.0f;
    const double ee = 0.00669342162296594323;
    
    // 把坐标点范围锁定在国内，排除国外的情况
    if (lon > 72.004 && lon < 137.8347 && lat > 0.8293 && lat < 55.8271) {\
        // 纠偏处理
        double dLat = [self transformLatX:lon - 105.0 y:lat - 35.0];
        double dLon = [self transformLonX:lon - 105.0 y:lat - 35.0];
        double radLat = lat / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
        double mgLat = lat + dLat;
        double mgLon = lon + dLon;
        
        mNewLocation = CLLocationCoordinate2DMake(mgLat, mgLon);
    }
    else {
        mNewLocation = [newLocation coordinate];
    }
    self.coordinate = mNewLocation;
    self.isGpsing = NO;
    // 设置状态为已更新
    self.locationState = eLongLocationStateUpdated;
    
    // 定位地址解析成功
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONGLOCATION_NOTI_LOCATIONUPDATED
                                                        object:nil];
    
    
    if (self.autoStop) {
        // 3s之后自动停止
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(stopLocation)
                                                   object:nil];
        [self performSelector:@selector(stopLocation) withObject:nil afterDelay:3];
    }
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mNewLocation.latitude
                                                      longitude:mNewLocation.longitude]; // 火星坐标
    [self locationAddressWithLocation:location];
}

- (void)setCurrentCity:(NSString *)currentCity{
    BOOL found = NO;
    if ([currentCity hasSuffix:@"市"]) {
        currentCity = [currentCity substringToIndex:([currentCity rangeOfString:@"市"]).location];
        found = YES;
    }else if([currentCity hasSuffix:@"县"]){
        currentCity = [currentCity substringToIndex:([currentCity rangeOfString:@"县"]).location];
        found = YES;
    }else if([currentCity hasSuffix:@"村"]){
        currentCity = [currentCity substringToIndex:([currentCity rangeOfString:@"村"]).location];
        found = YES;
    }else if([currentCity hasSuffix:@"市市辖区"]){
        currentCity = [currentCity substringToIndex:([currentCity rangeOfString:@"市市辖区"]).location];
        found = YES;
    }else if([currentCity hasPrefix:@"香港"]) {
        //香港，澳门
        currentCity = @"香港";
        found = YES;
    }else if([currentCity hasPrefix:@"澳门"] || [currentCity hasPrefix:@"澳門"]) {
        currentCity = @"澳门";
        found = YES;
    }else {
        // 英文到本地城市列表搜索对应
        NSBundle *eLongLocationBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"eLongLocation" ofType:@"bundle"]];
        NSBundle *bundle = (eLongLocationBundle ? eLongLocationBundle : [NSBundle mainBundle]);
        NSString * plistPath = [bundle pathForResource:@"hotelcity" ofType:@"plist"];
        NSDictionary *localCityDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        for (NSArray *array in [localCityDic allValues]) {
            for (NSArray *cityElements in array) {
                if (NSOrderedSame == [[cityElements objectAtIndex:1] compare:currentCity options:NSCaseInsensitiveSearch]) {
                    currentCity = [cityElements objectAtIndex:0];
                    found = YES;
                    break;
                }
            }
        }
    }
    
    if (found) {
        if (self.abroad) {
            // 如果在国外的话，一律把默认城市名改为北京
            _currentCity = @"北京";
        }else {
            _currentCity = currentCity;
            
        }
        self.isNotFindCityName = NO;
    }
    else
    {
        self.isNotFindCityName = YES;
    }
}

- (NSString *)getCurrentCityWithoutNetwork
{
    if(_currentCity == nil || [_currentCity isEqualToString: @""])
    {
        return @"北京";
    }
    return _currentCity;
}

- (NSString *)currentCity
{
    self.isPosition = YES;
    if(_currentCity == nil || _currentCity.length == 0)
    {
        self.isPosition = NO;
        _currentCity = @"北京";
    }
    return _currentCity;
}

-(NSString *)positionCurrentCity{
    return self.positionCity;
}

-(void)setPositionCurrentCity:(NSString *)city{
    self.positionCity = city;
}

-(BOOL)getPositionBool{
    return self.isPosition;
}

-(BOOL)isGpsing{
    return _isGpsing;
}

-(void)setGpsing:(BOOL)isStart{
    _isGpsing=isStart;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败:%@",error);
    self.originalLocation = nil;
    self.simpleAddress = nil;
    self.fullAddress = nil;
    self.coordinate = CLLocationCoordinate2DMake(0, 0);
    [[NSNotificationCenter defaultCenter] postNotificationName:ELONGLOCATION_NOTI_LOCATION_FAILURE object:nil];
}

// IOS 5.0 及以上版本使用此方法
- (void)locationAddressWithLocation:(CLLocation *)locationGps {
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    [clGeoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placeMark in placemarks) {
            if ([placeMark.ISOcountryCode isEqualToString:@"CN"]
                ||[placeMark.ISOcountryCode  isEqualToString:@"TW"]
                ||[placeMark.ISOcountryCode  isEqualToString:@"HK"]
                ||[placeMark.ISOcountryCode  isEqualToString:@"MO"]){
                // 中国、中国台湾、中国香港、中国澳门
                self.abroad = NO;
            }else {
                // 国外
                self.abroad = YES;
            }
            // 如果没有街道信息就显示地址全称，如果有街道信息就显示街道信息
            NSString *markName = nil;
            if (!placeMark.locality) {
                self.currentCity = placeMark.administrativeArea;
                self.positionCity = placeMark.administrativeArea;
                // 处理特殊城市
                [self dealWithSpecialCitys:placeMark.administrativeArea];
                
                if (placeMark.thoroughfare) {
                    markName = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,placeMark.thoroughfare];
                }else {
                    markName = [NSString stringWithFormat:@"%@",placeMark.name];
                }
            }else{
                self.currentCity = placeMark.locality;
                self.positionCity = placeMark.locality;
                
                // 处理特殊定位城市
                [self dealWithSpecialCitys:placeMark.locality];
                
                if (placeMark.thoroughfare) {
                    markName = [NSString stringWithFormat:@"%@%@",placeMark.locality,placeMark.thoroughfare];
                }else{
                    markName = [NSString stringWithFormat:@"%@",placeMark.name];
                }
            }
            self.simpleAddress = markName;
            NSArray *addressLines = [[placeMark addressDictionary] objectForKey:@"FormattedAddressLines"];
            
            
            if (addressLines && addressLines.count) {
                self.fullAddress = [addressLines componentsJoinedByString:@""];
                self.fullAddress = [self.fullAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
            }
            
            self.currentPlacemark = placeMark;
            // 定位地址解析成功
            [[NSNotificationCenter defaultCenter] postNotificationName:ELONGLOCATION_NOTI_ADDRESSUPDATED object:markName];
        }
        
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    }];
}

// 目前只处理香港、澳门、台湾
- (void) dealWithSpecialCitys:(NSString *)cityName{
    NSArray *specialCity = [NSArray arrayWithObjects:@"香港" ,@"Hong Kong" ,@"澳门" ,@"Macau" ,@"台湾" ,@"Taiwan", nil];
    for (int i = 0; i < specialCity.count; i++) {
        NSRange range;
        range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
        if (range.length) {
            self.specialCity = [specialCity objectAtIndex:i];
            
            // 恢复定位修正
            self.coordinate = self.originalLocation.coordinate;
            return;
        }
    }
}

// 从地址名获取位置信息
- (void)getPositionFromAddress:(NSString *)addressName
{
    //    NSString *addressName = @"南苑机场";
    
    NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc]init];
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:addressName completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0 && error == nil)
         {
             CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
             
             // 经纬度
             NSString *stringLonlat = [NSString stringWithFormat:@"%f,%f",firstPlacemark.location.coordinate.latitude,firstPlacemark.location.coordinate.longitude];
             [locationInfo setValue:stringLonlat forKey:@"latlonInfo"];
             
             NSString *cityName = @"";
             
             if (!firstPlacemark.locality)
             {
                 cityName = firstPlacemark.administrativeArea;
             }else
             {
                 cityName = firstPlacemark.locality;
             }
             
             if (locationInfo != nil && firstPlacemark != nil)
             {
                 if ([cityName notEmpty])
                 {
                     if ([cityName hasSuffix:@"市"]) {
                         cityName = [cityName substringToIndex:([cityName rangeOfString:@"市"]).location];
                     }else if([cityName hasSuffix:@"县"]){
                         cityName = [cityName substringToIndex:([cityName rangeOfString:@"县"]).location];
                     }else if([cityName hasSuffix:@"村"]){
                         cityName = [cityName substringToIndex:([cityName rangeOfString:@"村"]).location];
                     }else if([cityName hasSuffix:@"市市辖区"]){
                         cityName = [cityName substringToIndex:([cityName rangeOfString:@"市市辖区"]).location];
                     }else if([cityName hasPrefix:@"香港"])
                     {
                         cityName=@"香港";
                     }
                     else if([cityName hasPrefix:@"澳门"]||[cityName hasPrefix:@"澳門"])
                     {
                         cityName=@"澳门";
                     }
                     
                     // 保存
                     [locationInfo setValue:cityName forKey:@"cityName"];
                     
                     // 代理回调
                     if((_delegate != nil) && ([_delegate respondsToSelector:@selector(getPositionInfoBack:)] == YES))
                     {
                         [_delegate getPositionInfoBack:locationInfo];
                     }
                 }
             }
             
             NSLog(@"locationInfo neibu is%@",[locationInfo description]);
         }
         else if ([placemarks count] == 0 && error == nil) {
             NSLog(@"Found no placemarks.");
         }
         else if (error != nil) {
             NSLog(@"An error occurred = %@", error); }
     }];
}


#pragma mark 将GPS原始信息转换为火星坐标系
- (double) transformLatX:(double)x y:(double) y{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

- (double) transformLonX:(double)x y:(double) y{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

- (NSString *)getCurrentCityName;
{
    return self.currentPlacemark.locality ? self.currentPlacemark.locality : self.currentPlacemark.administrativeArea;
}
- (NSString *)getCurrentProvinceName;
{
    return self.currentPlacemark.administrativeArea;
}

@end
