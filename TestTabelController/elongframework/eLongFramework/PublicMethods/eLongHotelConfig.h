//
//  eLongHotelConfig.h
//  MyElong
//
//  Created by yangfan on 15/6/29.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#ifndef MyElong_eLongHotelConfig_h
#define MyElong_eLongHotelConfig_h

#define IMG_TYPE_ALL        @"所有"
#define IMG_TYPE_GUESTROOM  @"客房"
#define IMG_TYPE_EXTERIOR   @"外观"
#define IMG_TYPE_RECEPTION  @"前台"
#define IMG_TYPE_OTHER      @"设施"

#define HOTEL_NEARBY_RADIUS 5000                            // 国内酒店周边搜索半径

#define HOTEL_SEARCH_KEYWORD @"HOTEL_SEARCH_KEYWORD"        // 国内酒店搜索关键词

// 酒店图片分类
typedef enum
{
    eLongHotelImageTypeAll        = 0,   // 全部（基本不可能出现这个类型）
    eLongHotelImageTypeRestaurant = 1,   // 餐厅
    eLongHotelImageTypeRecreation = 2,   // 休闲
    eLongHotelImageTypeMeeting    = 3,   // 会议室
    eLongHotelImageTypeExterior   = 5,   // 酒店外观
    eLongHotelImageTypeReception  = 6,   // 大堂接待台
    eLongHotelImageTypeGuestRoom  = 8,   // 客房
    eLongHotelImageTypeBackground = 9,   // 背景图
    eLongHotelImageTypeOther      = 10   // 其它
}eLongHotelImageType;

// 酒店担保或预付种类
typedef enum
{
    eLongVouchSetTypeNormal         = 0, // 不担保
    eLongVouchSetTypeCreditCard     = 1, // 信用卡担保或预付
    eLongVouchSetTypeAlipayWap      = 2, // 支付宝Wap预付
    eLongVouchSetTypeWeiXinPayByApp = 5, // 微信预付
    eLongVouchSetTypeAlipayApp      = 7, // 支付宝担保或预付
    eLongVouchSetTypeNewVouch       = 8  // 先成单后支付担保
}eLongVouchSetType;

// 酒店关键词搜索种类
typedef enum {
    eLongHotelKeywordTypeNormal                   = 9,   // 酒店名或未知
    eLongHotelKeywordTypeBusiness                 = 3,   // 商圈
    eLongHotelKeywordTypeDistrict                 = 6,   // 行政区
    eLongHotelKeywordTypeBrand                    = 5,   // 品牌
    eLongHotelKeywordTypeAirportAndRailwayStation = 1,   // 机场火车站
    eLongHotelKeywordTypeSubwayStation            = 2,   // 地铁站
    eLongHotelKeywordTypePOI                      = 99   // POI
}eLongHotelKeywordType;

// 酒店筛选支付方式
typedef enum {
    eLongHotelFilterPayTypePrepay,       // 预付酒店
    eLongHotelFilterPayTypeNoGuarantee   // 免担保
}eLongHotelFilterPayType;

// 酒店筛选促销方式
typedef enum {
    eLongHotelFilterPromotionTypeVIP,    // 龙萃
    eLongHotelFilterPromotionTypeCash,   // 可返现
    eLongHotelFilterPromotionTypeLimit,   // 限时抢
    eLongHotelFilterPromotionTypeRedEnvelope //红包优惠
}eLongHotelFilterPromotionType;

typedef enum{
    eLongHotelSearchInHongKongArea = 0,       //香港
    eLongHotelSearchInMacaoArea,              //澳门
    eLongHotelSearchInSpecialPriceArea,       //今日特价
    eLongHotelSearchInOthersArea              //其他
}eLongHotelSearchRegionArea;


// 酒店筛选返回数据
#define HOTELFILTER_MUTIPLECONDITION @"MutipleCondition"
#define HOTELFILTER_BRANDS           @"Brands"
#define HOTELFILTER_AREANAME         @"AreaName"
#define HOTELFILTER_STARS            @"Stars"
#define HOTELFILTER_FACILITIES       @"Facilities"
#define HOTELFILTER_APARTMENT        @"Apartment"
#define HOTELFILTER_THEMES           @"Themes"
#define HOTELFILTER_NUMBER           @"Number"

// 非会员订单缓存
#define HOTEL_NONMEMBER_ORDER_PAYMENT_AMOUNT @"PaymentAmount"
#define HOTEL_NONMEMBER_ORDER_ROOM_COUNT     @"RoomCount"


#endif
