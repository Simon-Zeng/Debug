//
//  eLongNetworkReachability.h
//  eLongNetworking
//
//  Created by Dawn on 14-11-29.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

typedef NS_ENUM(NSInteger, eLongNetworkReachabilityStatus) {
    eLongNetworkReachabilityStatusUnknown          = -1,
    eLongNetworkReachabilityStatusNotReachable     = 0,
    eLongNetworkReachabilityStatusReachableViaWWAN = 1,
    eLongNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface eLongNetworkReachability : NSObject
/**
 *  获取当前网络的可用状态
 *
 *  @return 当前网络的可用状态
 */
- (eLongNetworkReachabilityStatus)currentReachabilityStatus;
/**
 *  通过host name检测当前网络是否可用，可能会block主线程较长时间，不推荐在主线程调用
 *
 *  @param hostName host name
 *
 *  @return eLongNetworkReachability
 */
+ (eLongNetworkReachability *)reachabilityWithHostName:(NSString *)hostName;
/**
 *  通过ip地址检测当前网络是否可用
 *
 *  @param hostAddress ip 地址
 *
 *  @return eLongNetworkReachability
 */
+ (eLongNetworkReachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;
/**
 *  检测当前网络是否可以连接Internet，返回数据不一定真实，有可能连接存在但是不一定能访问真实的网络地址
 *  此操作不会block主线程，对于一般的网络检测推荐使用
 *
 *  @return eLongNetworkReachability
 */
+ (eLongNetworkReachability *)reachabilityForInternetConnection;
/**
 *  检测wifi是否可用
 *
 *  @return eLongNetworkReachability
 */
+ (eLongNetworkReachability *)reachabilityForLocalWiFi;


@end
