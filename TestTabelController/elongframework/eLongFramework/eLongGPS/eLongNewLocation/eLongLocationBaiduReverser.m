//
//  eLongLocationBaiduGeocoder.m
//  eLongFramework
//
//  Created by Harry Zhao on 4/19/16.
//  Copyright © 2016 Kirn. All rights reserved.
//

#import "eLongLocationBaiduReverser.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface eLongLocationBaiduReverser()<BMKGeoCodeSearchDelegate>
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;

@end

@implementation eLongLocationBaiduReverser

-(BMKGeoCodeSearch *)searcher{
    if (_searcher == nil) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
        _searcher.delegate = self;
    }
    return _searcher;
}

-(void)startReverseWithCoordinate:(CLLocationCoordinate2D)location{
    //百度解析
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = location;

    BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{

    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"百度  %@",result.address);
        if (self.delegate && [self.delegate respondsToSelector:@selector(eLongLocationReverser:sucessWithResult:)]) {
            eLongLocationAddress *address = [eLongLocationAddress new];
            eLongLocationReverseResult *res = [eLongLocationReverseResult new];
            res.location = result.location;
            address.city = result.addressDetail.city;
            address.streetName = result.addressDetail.streetName;
            address.streetNumber = result.addressDetail.streetNumber;
            address.district = result.addressDetail.district;
            address.province = result.addressDetail.province;
            address.country = @"中国";
            res.address = address;
            res.fullAddress = result.address;
            [self.delegate eLongLocationReverser:self sucessWithResult:res];
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
        if (self.delegate && [self.delegate respondsToSelector:@selector(eLongLocationReverser:failureWithError:)]) {
            NSError *err = [NSError errorWithDomain:@"eLongLocationBaiduReverser"
                                                 code:error
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"百度地址解析失败",NSLocalizedDescriptionKey,nil]];
            
            [self.delegate eLongLocationReverser:self failureWithError:err];
        }
    }
}

@end
