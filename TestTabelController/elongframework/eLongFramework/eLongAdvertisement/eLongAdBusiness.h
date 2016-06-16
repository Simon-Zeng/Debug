//
//  eLongAdBusiness.h
//  ElongClient
//
//  Created by zhaoyingze on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongAdvInfoModel.h"
/**
 广告页配置 0:默认,1:酒店查询,2:机票查询,3:火车票查询,4:酒店收银台,5:机票收银台,6:团购收银台,7:首页,8:酒店列表,9:公寓1,10:公寓2,11:公寓3,12:闪屏,13:H5钟点房,14:搜索页,15:公寓列表,16:H5活动,17:国际酒店列表页,18:H5国际酒店首页,19:国际酒店首页,20:发现酒店
 如有更新 需要同时更新实现文件里的key值数组
 */
typedef enum : NSUInteger {
    AdPageTypeDefault = 0,
    AdPageTypeHotelSearch,
    AdPageTypeFlightSearch,
    AdPageTypeRailwaySearch,
    AdPageTypeHotelPayCounter,
    AdPageTypeFlightPayCounter,
    AdPageTypeGrouponPayCounter,
    AdPageTypeHomePage,
    AdPageTypeHotelList,
    AdPageTypeFlatOne,
    AdPageTypeFlatTwo,
    AdPageTypeFlatThree,
    AdPageTypeSplashScreen,
    AdPageTypeH5Business,
    AdPageTypeH5Activity,
    AdPageTypeFlatList,
    AdPageTypeH5ActivityPage,
    AdPageTypeGlobalHotelListPage,
    AdPageTypeH5GlobalHotelIndexPage,
    AdPageTypeGlobalHotelIndexPage,
    AdPageTypeFindlHotelIndexPage
} AdPageType;
typedef void(^adInfoBlock)(NSArray<eLongAdvInfoModel> *adInfos);
typedef void(^failureBlock)(NSError *error);
@interface eLongAdBusiness : NSObject
+ (void)getAdvInfoWithCountry:(NSString *)country
                         city:(NSString *)city
                     pageType:(AdPageType)pageType
                  adInfoBlock:(adInfoBlock)adInfoBlock
                 failureBlock:(failureBlock)failureBlock;
@end

