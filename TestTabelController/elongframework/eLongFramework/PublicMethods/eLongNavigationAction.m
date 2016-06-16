//
//  eLongNavigationAction.m
//  Pods
//
//  Created by yangfan on 15/6/30.
//
//

#import "eLongNavigationAction.h"
//elonglocation模块
#import "eLongLocation.h"
#import "eLongDefine.h"
#import "eLongDebugManager.h"
#import <MapKit/MapKit.h>

typedef enum {
    AutoMapNavigation,              // 高德地图
    BaiduMapNavigation,             // 百度地图
    GoogleMapNavigation,            // 谷歌地图
    AppleMapNavigation,             // 系统地图
    TencentMapNavigation            // 腾讯地图
}NavigationMapType;

@implementation eLongNavigationAction
DEF_SINGLETON(eLongNavigationAction)

- (void) dealloc{
    self.navActions = nil;
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == self.navActions.count) {
        return;
    }
    
    if ([eLongDebugManager businessLineInstance].enabled) {
        if (![[eLongDebugManager businessLineInstance] isEnabled:eLongDebugBLBooking]) {
            // 如果monkey打开，不做处理，直接跳出
            return;
        }
    }
    
    NSDictionary *dict = [self.navActions objectAtIndex:buttonIndex];
    NSLog(@"%@",dict);
    NSString *url = [dict objectForKey:@"Url"];
    if ([[dict objectForKey:@"MapType"] intValue] == AppleMapNavigation) {
        if ([eLongDebugManager businessLineInstance].enabled) {
            if (![[eLongDebugManager businessLineInstance] isEnabled:eLongDebugBLBooking]) {
                // 如果monkey打开，不做处理，直接跳出
                return;
            }
        }
        
//        if (IOSVersion_6) {
            //
            float lat = [[dict objectForKey:@"lat"] floatValue];
            float lng = [[dict objectForKey:@"lng"] floatValue];
            
            eLongLocation *poiManager = [eLongLocation sharedInstance];
            
            MKPlacemark *currentMark = [[MKPlacemark alloc] initWithCoordinate:poiManager.coordinate addressDictionary:nil];
            MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) addressDictionary:nil];
            MKMapItem *targetMapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:currentMark];
            targetMapItem.name = [dict objectForKey:@"Name"];
            currentLocation.name = @"当前位置";
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, targetMapItem, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
//        }else{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
@end
