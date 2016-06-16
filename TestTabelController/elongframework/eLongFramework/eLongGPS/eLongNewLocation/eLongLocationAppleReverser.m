//
//  eLongLocationAppleReverser.m
//  eLongFramework
//
//  Created by Harry Zhao on 4/19/16.
//  Copyright © 2016 Kirn. All rights reserved.
//

#import "eLongLocationAppleReverser.h"

@implementation eLongLocationAppleReverser

- (void)startReverseWithCoordinate:(CLLocationCoordinate2D )mNewLocation {
    
    CLLocation *locationGps = [[CLLocation alloc] initWithLatitude:mNewLocation.latitude
                                                         longitude:mNewLocation.longitude];
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    __weak typeof(self) weakSelf = self;

    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    [clGeoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(eLongLocationReverser:failureWithError:)]) {
                [weakSelf.delegate eLongLocationReverser:self failureWithError:error];
            }
        } else {
            eLongLocationAddress *address = [eLongLocationAddress new];
            eLongLocationReverseResult *res = [eLongLocationReverseResult new];
            res.location = mNewLocation;
            for (CLPlacemark *placeMark in placemarks) {
                if (!placeMark.locality) {
                    address.city = placeMark.administrativeArea;
                }else{
                    address.city = placeMark.locality;
                }
                address.streetName = placeMark.thoroughfare;
                address.streetNumber = placeMark.subThoroughfare;
                address.district = placeMark.subLocality;
                address.province = placeMark.administrativeArea;
                address.country = placeMark.country;
                
                NSArray *addressLines = [[placeMark addressDictionary] objectForKey:@"FormattedAddressLines"];
                if (addressLines && addressLines.count) {
                    res.fullAddress = [addressLines componentsJoinedByString:@""];
                    res.fullAddress = [res.fullAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                }
                
                // 定位地址解析成功
                if (self.delegate && [self.delegate respondsToSelector:@selector(eLongLocationReverser:sucessWithResult:)]) {
                    res.address = address;
                    [self.delegate eLongLocationReverser:self sucessWithResult:res];
                }
            }
        }
        
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    }];
}

@end
