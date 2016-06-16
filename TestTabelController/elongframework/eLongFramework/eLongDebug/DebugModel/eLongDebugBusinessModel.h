//
//  Business.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  业务线
 */
typedef NS_ENUM(NSUInteger, eLongDebugBLType){
    /**
     *  顶部广告
     */
    eLongDebugBLTopAd,
    /**
     *  底部广告
     */
    eLongDebugBLBottomAd,
    /**
     *  酒店
     */
    eLongDebugBLHotel,
    /**
     *  今日特价
     */
    eLongDebugBLLMHotel,
    /**
     *  团购
     */
    eLongDebugBLGrouponHotel,
    /**
     *  附近酒店
     */
    eLongDebugBLNearbyHotel,
    /**
     *  公寓
     */
    eLongDebugBLApartment,
    /**
     *  机票
     */
    eLongDebugBLFlight,
    /**
     *  火车票
     */
    eLongDebugBLTrain,
    /**
     *  租车
     */
    eLongDebugBLTexi,
    /**
     *  当地
     */
    eLongDebugBLLocation,
    /**
     *  旅行清单
     */
    eLongDebugBLTravelList,
    /**
     *  汇率
     */
    eLongDebugBLExchangeRate,
    /**
     *  驴友
     */
    eLongDebugBLLvyou,
    /**
     *  意见反馈
     */
    eLongDebugBLFeedback,
    /**
     *  首页
     */
    eLongDebugBLHome,
    /**
     *  订单
     */
    eLongDebugBLOrder,
    /**
     *  客服
     */
    eLongDebugBLCallCenter,
    /**
     *  我的艺龙
     */
    eLongDebugBLMyElong,
    /**
     *  成单
     */
    eLongDebugBLBooking,
    /**
     *  汽车票
     */
    eLongDebugBLBus,
    /**
     *  首页活动动画
     */
    eLongDebugBLHomeActivityAnimation
};

@interface eLongDebugBusinessModel : NSManagedObject

/**
 *  业务线是否开启
 */
@property (nonatomic, retain) NSNumber * enabled;
/**
 *  业务线名
 */
@property (nonatomic, retain) NSString * name;
/**
 *  业务线tag
 */
@property (nonatomic, retain) NSNumber * tag;

@end
