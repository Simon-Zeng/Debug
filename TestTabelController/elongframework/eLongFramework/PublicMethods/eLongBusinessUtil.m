//
//  eLongBusinessUtil.m
//  MyElong
//
//  Created by yangfan on 15/6/29.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "eLongBusinessUtil.h"
#import "eLongAccountUserInstance.h"
#import "eLongAccountManager.h"
#import "eLongNetUtil.h"
#import "eLongUserDefault.h"
#import "eLongFileIOUtils.h"
#import "eLongLocation.h"
#import "eLongDefine.h"
#import "JSONKit.h"

@implementation eLongBusinessUtil

+ (NSData *)getPassDateByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude {
    NSString *passURL = [NSString stringWithFormat:@"http://apiaff.elong.com/PassBook/%@.aspx?orderid=%@&cardno=%@&lat=%@&lon=%@",
                         type, orderId, num, latitude, longitude];
    NSData *passData = [NSData dataWithContentsOfURL:[NSURL URLWithString:passURL]];
    return passData;
}

+ (NSString *)getPassUrlByType:(NSString *)type orderID:(NSString *)orderId cardNum:(NSString *)num lat:(NSString *)latitude lon:(NSString *)longitude {
    NSString *passURL = [NSString stringWithFormat:@"http://apiaff.elong.com/PassBook/%@.aspx?orderid=%@&cardno=%@&lat=%@&lon=%@",
                         type, orderId, num, latitude, longitude];
    
    return passURL;
}

+ (BOOL) adjustIsLogin{
    return [[eLongAccountManager userInstance] isAdjustLogin];
}

+ (void)getLongVIPInfo {
    /* Modify by Jian.Zhao   VIP Requested After Login
     if ([[eLongAccountManager userInstance] isLogin]) {
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
     [dict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
     HttpUtil *util = [[[HttpUtil alloc] init] autorelease];
     
     NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"useablecredits" andParam:[dict JSONString]];
     
     [util requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:[AccountManager instanse]];
     
     [dict release];
     }
     */
}

+ (void)saveSearchKey:(NSString *)key forCity:(NSString *)city {
    [self saveSearchKey:key type:nil propertiesId:nil lat:nil lng:nil forCity:city];
}

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city{
    [self saveSearchKey:key type:type propertiesId:pid propertiesType:nil lat:lat lng:lng forCity:city];
}

+ (void) saveSearchKey:(NSString *)key type:(NSNumber *)type propertiesId:(NSString *)pid propertiesType:(NSNumber *)pidType lat:(NSNumber *)lat lng:(NSNumber *)lng forCity:(NSString *)city{
    NSMutableDictionary *hotelSearchKeywordDict = nil;
    NSObject* hotelSearchKeywordObj = [eLongUserDefault objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
    if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
        hotelSearchKeywordDict = [NSMutableDictionary dictionary];
    }else{
        hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
    }
    
    if (STRINGHASVALUE(key) && STRINGHASVALUE(city)) {
        NSMutableArray *hotelSearchKeywordArray = [NSMutableArray arrayWithArray:[hotelSearchKeywordDict objectForKey:city]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict safeSetObject:key forKey:@"Name"];
        if (type) {
            [dict setObject:type forKey:@"Type"];
        }
        if (pid) {
            [dict setObject:pid forKey:@"PropertiesId"];
        }
        if (pidType) {
            [dict setObject:pidType forKey:@"PropertiesIdType"];
        }
        if (lat) {
            [dict setObject:lat forKey:@"Lat"];
        }
        if (lng) {
            [dict setObject:lng forKey:@"Lng"];
        }
        
        if (![hotelSearchKeywordArray containsObject:dict]) {
            [hotelSearchKeywordArray insertObject:dict atIndex:0];
            
            while (hotelSearchKeywordArray.count > HOTEL_KEYWORDHISTORY_NUM) {
                [hotelSearchKeywordArray removeLastObject];
            }
            
            [hotelSearchKeywordDict setObject:hotelSearchKeywordArray forKey:city];
            [eLongUserDefault setObject:hotelSearchKeywordDict forKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        }
    }
}

+ (NSArray *) allSearchKeysForCity:(NSString *)city{
    if (STRINGHASVALUE(city)) {
        NSMutableDictionary *hotelSearchKeywordDict = nil;
        NSObject* hotelSearchKeywordObj = [eLongUserDefault objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
            return [NSArray array];
        }else{
            hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
        }
        if ([hotelSearchKeywordDict objectForKey:city]) {
            return [hotelSearchKeywordDict objectForKey:city];
        }
    }
    return [NSArray array];
}

+ (void) clearSearchKeyforCity:(NSString *)city{
    if (STRINGHASVALUE(city)) {
        NSMutableDictionary *hotelSearchKeywordDict = nil;
        NSObject* hotelSearchKeywordObj = [eLongUserDefault objectForKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
        if (![hotelSearchKeywordObj isKindOfClass:[NSDictionary class]]) {
            return;
        }else{
            hotelSearchKeywordDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)hotelSearchKeywordObj];
        }
        if ([hotelSearchKeywordDict objectForKey:city]) {
            [hotelSearchKeywordDict removeObjectForKey:city];
        }
        [eLongUserDefault setObject:hotelSearchKeywordDict forKey:USERDEFUALT_HOTEL_SEARCHKEYWORD];
    }
}

+ (void) wgs84ToGCJ_02WithLatitude:(double *)lat longitude:(double *)lon{
    const double a = 6378245.0f;
    const double ee = 0.00669342162296594323;
    
    double dLat = [eLongBusinessUtil transformLatX:*lon - 105.0 Y:*lat - 35.0];
    double dLon = [eLongBusinessUtil transformLonX:*lon - 105.0 Y:*lat - 35.0];
    double radLat = *lat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *lat = *lat + dLat;
    *lon = *lon + dLon;
}

+ (double)transformLatX:(double)x Y:(double)y{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double) transformLonX:(double)x Y:(double)y{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

+ (BOOL) needSwitchWgs84ToGCJ_02:(NSString *)cityName{
    // 特殊城市，香港，澳门
    eLongLocation *fastPositioning = [eLongLocation sharedInstance];
    
    if (!fastPositioning.specialCity && !fastPositioning.abroad) {
//        // 在国内、非香港澳门、IOS6及其以上版本
//        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
//        NSString *cityName = [hotelsearcher cityName];
        
        NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"Hong Kong",@"澳门",@"Macau", @"台北", @"台中", @"高雄", @"屏东", @"花莲", @"宜兰", @"台南", @"南投", @"台东", @"金门", @"云林", @"嘉义", @"基隆", @"彰化", @"新竹", @"桃园", @"澎湖", @"苗栗", @"花莲", nil ];
        for (int i = 0; i < specialCity.count; i++) {
            NSRange range;
            range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
            if (range.length) {
                NSLog(@"国内酒店需要纠偏");
                return YES;
            }
        }
    }
    NSLog(@"国内酒店不需要需要纠偏");
    return NO;
}

+ (BOOL) needSwitchWgs84ToGCJ_02Groupon:(NSString *)cityName{
    // 特殊城市，香港，澳门
    eLongLocation *fastPositioning = [eLongLocation sharedInstance];
    
    if (!fastPositioning.specialCity && !fastPositioning.abroad) {
//        // 在国内、非香港澳门、IOS6及其以上版本
//        GListRequest *listReq = [GListRequest shared];
//        NSString *cityName = listReq.cityName;
        
        NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"澳门", nil];
        for (int i = 0; i < specialCity.count; i++) {
            NSRange range;
            range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
            if (range.length) {
                NSLog(@"国内团购需要纠偏");
                return YES;
            }
        }
    }
    NSLog(@"国内团购不需要需要纠偏");
    return NO;
}

+ (NSString *) getStar:(NSInteger)level{
    if (level < 3) {
        return  @"经济型";
    }else if(level >= 3 && level <= 5){
        if (level == 3) {
            return @"三星";
        }else if(level == 4){
            return @"四星";
        }else if(level == 5){
            return @"五星";
        }
    }else{
        float elongLevel = level/10.0f;
        if (elongLevel <= 3) {
            return @"舒适型";
        }else if(elongLevel > 3 && elongLevel < 4){
            return @"高档型";
        }else if(elongLevel >= 4){
            return @"豪华型";
        }
    }
    return @"";
}

//得到评论描述
+(NSString *) getCommentDespLogic:(NSInteger) goodComment badComment:(NSInteger) badComment comentPoint:(float) commentPoint
{
    //return [NSString stringWithFormat:@"%.0f%% 好评",commentPoint*100];
    return [NSString stringWithFormat:@"%.0f%%",commentPoint*100];
    
    //    //是否保留？？？
    //    if (goodComment + badComment == 0) {
    //        return @"暂无评论";
    //    }
    //    else if (goodComment == 0)
    //    {
    //        return [NSString stringWithFormat:@"%d条评论",badComment];
    //    }
    //    else
    //    {
    //        return [NSString stringWithFormat:@"%.0f%% 好评",commentPoint*100];
    //    }
}

//得到评论描述
+(NSString *) getCommentDespOldLogic:(NSInteger) goodComment badComment:(NSInteger) badComment
{
    // 计算好评率 四舍五入
    NSInteger favRate = 0;
    if (goodComment + badComment == 0) {
        favRate = 0;
    }else{
        favRate = ceil(goodComment * 100/ (goodComment + badComment + 0.0f));
    }
    
    if (goodComment + badComment == 0) {
        return @"暂无评论";
    }
    else if (goodComment == 0) {
        return [NSString stringWithFormat:@"%ld条评论",(long)badComment];
    }else{
        return [NSString stringWithFormat:@"%ld%% 推荐",(long)favRate];
    }
}

+ (NSString *) getHouseStar:(NSInteger)level{
    if (level < 3) {
        return  @"公寓";
    }else if(level >= 3 && level <= 5){
        if (level == 3) {
            return @"舒适公寓";
        }else if(level == 4){
            return @"高档公寓";
        }else if(level == 5){
            return @"豪华公寓";
        }
    }else{
        float elongLevel = level/10.0f;
        if (elongLevel <= 3) {
            return @"舒适公寓";
        }else if(elongLevel > 3 && elongLevel < 4){
            return @"高档公寓";
        }else if(elongLevel >= 4){
            return @"豪华公寓";
        }
    }
    return @"";
}

+ (NSString *) getHomeItemName:(NSInteger)tag{
    NSString * name = @"";
    switch (tag) {
        case 1410:  // 机票
            name = @"flight";
            break;
        case 1420:  // 火车票
            name =  @"ticket";
            break;
        case 1431:  // 个人中心
            name =  @"usercenter";
            break;
        case 1432:  // 电话
            name = @"callus";
            break;
        case 1433:  // 自定义模块
            name = @"add";
            break;
        case 1440:  // 航班动态
            name =  @"flightinfo";
            break;
        case 1450:  // 旅行清单
            name =  @"travelpackage";
            break;
        case 1460:  // 汇率换算
            name = @"exchangerate";
            break;
        case 1470:  // 用车
            name =  @"car";
            break;
        case 1480:  // 旅游指南
            name = @"travelguide";
            break;
        case 1490:  // 每日特惠
            name =  @"specialoffer";
            break;
        case 1401:  // 意见反馈
            name = @"feedback";
            break;
        case 1200:  // 酒店
            name = @"hotel";
            break;
        case 1300:  // 团购
            name = @"groupbuy";
            break;
        case 1500:  // 特价酒店
            name = @"offprice";
            break;
        case 1600:  // 附近酒店
            name = @"hotelnearby";
            break;
        case 1700:
            name = @"globalhotel";
        case 1800:
            name = @"clockHotel";
            break;
        default:
            name = @"other";
            break;
    }
    return name;
}

+ (NSInteger) getHomeItemType:(NSInteger)tag{
    NSInteger type = -1;
    switch (tag) {
        case 1402: //汽车票
            type = 19;
            break;
        case 1410:  //机票
            type = 7;
            break;
        case 1420:  // 火车票
            type = 8;
            break;
        case 1431:  // 个人中心
            type = 18;
            break;
        case 1432:  // 电话
            type = 17;
            break;
        case 1433:  // 自定义模块
            type = 13;
            break;
        case 1450:  // 旅行清单
            type = 11;
            break;
        case 1460:  // 汇率换算
            type = 12;
            break;
        case 1470:  // 用车
            type = 9;
            break;
        case 1480:  // 旅游指南
            type = 9;
            break;
        case 1490:  // 每日特惠
            type = 3;
            break;
        case 1401:  // 意见反馈
            type = 13;
            break;
        case 1200:  // 酒店
            type = 2;
            break;
        case 1300:  // 团购
            type = 4;
            break;
        case 1500:  // 特价酒店
            type = 3;
            break;
        case 1600:  // 附近酒店
            type = 5;
            break;
        case 1700:
            type = 20;
            break;
        case 1800:
            type = 5;
            break;
        case 1440:  // 公寓
            type = 6;
            break;
        default:
            type = -1;
            break;
    }
    return type;
}


//+ (NSString *)getCityIDWithCity:(NSString *)cityName{
//    // 需改动
////    NSString *plistPath = [DestinationUpdater getCityListPlistName:@"hotelcity"];
//    NSString * plistPath = @"";
//    NSDictionary *dictionary  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    
//    for (NSArray *keyArray in [dictionary allValues]) {
//        for (NSArray *cityArray in keyArray) {
//            NSString *city = [cityArray safeObjectAtIndex:0];
//            NSRange range = [city rangeOfString:cityName];
//            
//            if (range.location != NSNotFound) {
//                return [cityArray lastObject];
//            }
//        }
//    }
//    return @"";
//}
//
//+ (BOOL) isHotCity:(NSString *)cityName{
//    // 需改动
////    NSString *plistPath = [DestinationUpdater getCityListPlistName:@"hotelcity"];
//    NSString *plistPath = @"";
//    NSDictionary *dictionary  = [NSDictionary dictionaryWithContentsOfFile:plistPath];
//    NSArray *hotcitys = [dictionary objectForKey:@"热门"];
//    
//    for (NSArray *cityArray in hotcitys) {
//        if ([[cityArray safeObjectAtIndex:0] isEqualToString:cityName]) {
//            return YES;
//        }
//    }
//    return NO;
//}

+ (NSInteger) getMaxPriceLevel:(NSInteger)price{
    switch (price) {
        case -1:
            return 4;
        case 0:
            return 0;
        case 150:
            return 1;
        case 300:
            return 2;
        case 500:
            return 3;
        case GrouponMaxMaxPrice:
            return 4;
        default:
            return 4;
    }
}

+ (NSInteger) getMinPriceLevel:(NSInteger)price{
    switch (price) {
        case -1:
            return 0;
        case 0:
            return 0;
        case 150:
            return 1;
        case 300:
            return 2;
        case 500:
            return 3;
        case GrouponMaxMaxPrice:
            return 4;
        default:
            return 0;
    }
}

+ (NSInteger) getMinPriceByLevel:(NSInteger)level{
    switch (level) {
        case 0:
            return 0;
        case 1:
            return 150;
        case 2:
            return 300;
        case 3:
            return 500;
        case 4:
            return GrouponMaxMaxPrice;
        default:
            return -1;
    }
}

+ (NSInteger) getMaxPriceByLevel:(NSInteger)level{
    switch (level) {
        case 0:
            return 0;
        case 1:
            return 150;
        case 2:
            return 300;
        case 3:
            return 500;
        case 4:
            return GrouponMaxMaxPrice;
        default:
            return -1;
    }
}

//added by jlg
+ (NSInteger) getMaxPriceLevel:(NSInteger)price andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion{
    if(hotelSearchRegion == eLongHotelSearchInHongKongArea){
        switch (price) {
            case -1:
                return 5;
            case 0:
                return 0;
            case 300:
                return 1;
            case 600:
                return 2;
            case 800:
                return 3;
            case 1100:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 5;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInMacaoArea){
        switch (price) {
            case -1:
                return 5;
            case 0:
                return 0;
            case 500:
                return 1;
            case 800:
                return 2;
            case 1200:
                return 3;
            case 1500:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 5;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInSpecialPriceArea){
        switch (price) {
            case -1:
                return 5;
            case 0:
                return 0;
            case 100:
                return 1;
            case 250:
                return 2;
            case 400:
                return 3;
            case 600:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 5;
        }
    }
    else{
        switch (price) {
            case -1:
                return 5;
            case 0:
                return 0;
            case 150:
                return 1;
            case 300:
                return 2;
            case 500:
                return 3;
            case 700:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 5;
        }
    }
}

+ (NSInteger) getMinPriceLevel:(NSInteger)price andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion{
    if(hotelSearchRegion == eLongHotelSearchInHongKongArea){
        switch (price) {
            case -1:
                return 0;
            case 0:
                return 0;
            case 300:
                return 1;
            case 600:
                return 2;
            case 800:
                return 3;
            case 1100:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 0;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInMacaoArea){
        switch (price) {
            case -1:
                return 0;
            case 0:
                return 0;
            case 500:
                return 1;
            case 800:
                return 2;
            case 1200:
                return 3;
            case 1500:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 0;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInSpecialPriceArea){
        switch (price) {
            case -1:
                return 0;
            case 0:
                return 0;
            case 100:
                return 1;
            case 250:
                return 2;
            case 400:
                return 3;
            case 600:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 0;
        }
    }
    else{
        switch (price) {
            case -1:
                return 0;
            case 0:
                return 0;
            case 150:
                return 1;
            case 300:
                return 2;
            case 500:
                return 3;
            case 700:
                return 4;
            case GrouponMaxMaxPrice:
                return 5;
            default:
                return 0;
        }
    }
}


+ (NSInteger) getMinPriceByLevel:(NSInteger)level andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion{
    if(hotelSearchRegion == eLongHotelSearchInHongKongArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 300;
            case 2:
                return 600;
            case 3:
                return 800;
            case 4:
                return 1100;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInMacaoArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 500;
            case 2:
                return 800;
            case 3:
                return 1200;
            case 4:
                return 1500;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    else if(hotelSearchRegion == eLongHotelSearchInSpecialPriceArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 100;
            case 2:
                return 250;
            case 3:
                return 400;
            case 4:
                return 600;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    else{
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 150;
            case 2:
                return 300;
            case 3:
                return 500;
            case 4:
                return 700;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    
}

+ (NSInteger) getMaxPriceByLevel:(NSInteger)level andHotelType:(eLongHotelSearchRegionArea) hotelSearchRegion{
    if(hotelSearchRegion == eLongHotelSearchInHongKongArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 300;
            case 2:
                return 600;
            case 3:
                return 800;
            case 4:
                return 1100;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
    }
    else if(hotelSearchRegion == eLongHotelSearchInMacaoArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 500;
            case 2:
                return 800;
            case 3:
                return 1200;
            case 4:
                return 1500;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    else if(hotelSearchRegion == eLongHotelSearchInSpecialPriceArea){
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 100;
            case 2:
                return 250;
            case 3:
                return 400;
            case 4:
                return 600;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    else{
        switch (level) {
            case 0:
                return 0;
            case 1:
                return 150;
            case 2:
                return 300;
            case 3:
                return 500;
            case 4:
                return 700;
            case 5:
                return GrouponMaxMaxPrice;
            default:
                return -1;
        }
        
    }
    
}

+ (BOOL)version:(NSString *)aVersion lessthanOtherVersion:(NSString *)other {
    if (!STRINGHASVALUE(aVersion) || !STRINGHASVALUE(other)) {
        return NO;
    }
    if ([aVersion compare:other options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

#pragma mark - 支付宝支付

//是否可以支付宝app支付
+(BOOL) couldPayByAlipayApp
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]])
    {
        return YES;
    }
    
    return YES;
}

// ================== 原Utils ======================

//+ (NSString *)getOrderStatusIcon:(int)orderStatus {
//    NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
//    
//    switch (orderStatus) {
//        case 0:
//            [name setString:@"ico_orderstate_used.png"];
//            break;
//        case 1:
//            [name setString:@"ico_orderstate_active.png"];
//            break;
//        case 2:
//            [name setString:@"ico_orderstate_cancel.png"];
//            break;
//        case 3:
//            [name setString:@"ico_orderstate_cancel.png"];
//            break;
//        case 4:
//            [name setString:@"ico_orderstate_cancel.png"];
//            break;
//    }
//    return name;
//}
//
//+ (NSString *)getTicketStatusName:(NSString *)flightS dict:(NSDictionary *)dict{
//    for (NSDictionary *dd in [dict safeObjectForKey:@"Tickets"]) {
//        if ([flightS isEqualToString:[dd safeObjectForKey:@"FlightNumber"]]) {
//            return [dd safeObjectForKey:@"TicketStateName"];
//        }
//    }
//    
//    return nil;
//}
//
//+ (int)getTicketStatus:(NSString *)flightS dict:(NSDictionary *)dict{
//    for (NSDictionary *dd in [dict safeObjectForKey:@"Tickets"]) {
//        if ([flightS isEqualToString:[dd safeObjectForKey:@"FlightNumber"]]) {
//            return [[dd safeObjectForKey:@"TicketState"] intValue];
//        }
//    }
//    
//    return 0;
//}
//
//+ (NSString *)getAirCorpPicName:(NSString *)airCorpName {
//    NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
//    [airCorpName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if ([airCorpName isEqual:@"东航"] || [airCorpName isEqual:@"东方航空"] || [airCorpName isEqual:@"中国东方航空公司"]) {
//        [name setString:@"airlines_dongfang.png"];
//    } else if ([airCorpName isEqual:@"国航"] || [airCorpName isEqual:@"中国国航"]|| [airCorpName isEqual:@"中国国际航空公司"]) {
//        [name setString:@"airlines_zhongguo.png"];
//    } else if ([airCorpName isEqual:@"海航"] || [airCorpName isEqual:@"海南航空"] || [airCorpName isEqual:@"海南航空公司"]|| [airCorpName isEqual:@"中国海南航空公司"] || [airCorpName isEqualToString:@"大新华"]) {
//        [name setString:@"airlines_hainan.png"];
//    } else if ([airCorpName isEqual:@"南航"] || [airCorpName isEqual:@"南方航空"] || [airCorpName isEqual:@"中国南方航空公司"]|| [airCorpName isEqual:@"中国深圳航空公司"]) {
//        [name setString:@"airlines_nanfang.png"];
//    } else if ([airCorpName isEqual:@"上航"] || [airCorpName isEqual:@"上海航空"] || [airCorpName isEqual:@"上海航空公司"]|| [airCorpName isEqual:@"中国上海航空公司"]) {
//        [name setString:@"airlines_shanghai.png"];
//    } else if ([airCorpName isEqual:@"深航"] || [airCorpName isEqual:@"深圳航空"]|| [airCorpName isEqual:@"深圳航空公司"]) {
//        [name setString:@"airlines_shenzhen.png"];
//    } else if ([airCorpName isEqual:@"奥凯航空"] || [airCorpName isEqual:@"奥凯"] || [airCorpName isEqual:@"奥凯航空公司"]|| [airCorpName isEqual:@"中国奥凯航空公司"]) {
//        [name setString:@"airlines_aokai.png"];
//    } else if ([airCorpName isEqual:@"厦航"] || [airCorpName isEqual:@"厦门航空"]|| [airCorpName isEqual:@"中国厦门航空公司"] || [airCorpName isEqualToString:@"厦门航空有限公司"]) {
//        [name setString:@"airlines_xiamen.png"];
//    } else if ([airCorpName isEqual:@"山航"] || [airCorpName isEqual:@"山东航空"] || [airCorpName isEqual:@"山东航空公司"]|| [airCorpName isEqual:@"中国山东航空公司"]) {
//        [name setString:@"airlines_shandong.png"];
//    } else if ([airCorpName isEqual:@"川航"] || [airCorpName isEqual:@"四川航空"] || [airCorpName isEqual:@"四川航空公司"]|| [airCorpName isEqual:@"中国四川航空公司"]) {
//        [name setString:@"airlines_sichuan.png"];
//    } else if ([airCorpName isEqual:@"鹰联航空"] || [airCorpName isEqual:@"鹰联航空公司"] || [airCorpName isEqual:@"鹰联"]) {
//        [name setString:@"airlines_yinglian.png"];
//    } else if ([airCorpName isEqual:@"祥鹏航空"] || [airCorpName isEqual:@"祥鹏航空公司"] ||
//               [airCorpName isEqual:@"祥鹏"]|| [airCorpName isEqual:@"云南祥鹏航空"]) {
//        [name setString:@"airlines_xiangpeng.png"];
//    } else if ([airCorpName isEqual:@"中联航"] || [airCorpName isEqual:@"中联航航空公司"]) {
//        [name setString:@"airlines_zhongguolian.png"];
//    } else if ([airCorpName isEqual:@"联合航空"] || [airCorpName isEqual:@"联合航空公司"] ||
//               [airCorpName isEqual:@"中国联合航空公司"]) {
//        [name setString:@"airlines_zhongguolian.png"];
//    } else if ([airCorpName isEqual:@"吉祥航空"] || [airCorpName isEqual:@"吉祥"]|| [airCorpName isEqual:@"上海吉祥航空公司"]|| [airCorpName isEqual:@"上海吉祥航空有限公司"])
//    {
//        [name setString:@"airlines_jixiang.png"];
//    }
//    else if ([airCorpName isEqual:@"华夏航空"]|| [airCorpName isEqual:@"华夏航空公司"] ||
//             [airCorpName isEqual:@"华夏"]||[airCorpName isEqual:@"华夏航空有限公司"]) {
//        [name setString:@"airlines_huaxia.png"];
//    }
//    else if ([airCorpName isEqual:@"成都航空"] || [airCorpName isEqual:@"成都航空有限公司"] ||
//             [airCorpName isEqual:@"成航"]) {
//        [name setString:@"airlines_chengdu.png"];
//    }
//    else if ([airCorpName isEqual:@"河北航空"] || [airCorpName isEqual:@"河北航空有限公司"] ||
//             [airCorpName isEqual:@"河航"]|| [airCorpName isEqual:@"河北航空公司"]) {
//        [name setString:@"hebei_chengdu.png"];
//    }
//    else if ([airCorpName isEqual:@"昆航"] || [airCorpName isEqual:@"昆明航空"] ||
//             [airCorpName isEqual:@"昆明航空有限公司"]) {
//        [name setString:@"airlines_kunming.png"];
//    }
//    else if ([airCorpName isEqual:@"首航"] || [airCorpName isEqual:@"首都航空"] ||
//             [airCorpName isEqual:@"北京首都航空有限公司"]) {
//        [name setString:@"airlines_shouhang.png"];
//    }
//    //Add By Jian.Zhao
//    else if ([airCorpName isEqualToString:@"东海"] || [airCorpName isEqualToString:@"东海航空"] || [airCorpName isEqualToString:@"东海航空有限公司"]){
//        [name setString:@"airlines_donghai.png"];
//    }else if ([airCorpName isEqualToString:@"长龙"]||[airCorpName isEqualToString:@"长龙航空"]||[airCorpName isEqualToString:@"长龙航空有限公司"]){
//        [name setString:@"airlines_changlong.png"];
//    }else if ([airCorpName isEqualToString:@"青岛"]||[airCorpName isEqualToString:@"青岛航空"]||[airCorpName isEqualToString:@"青岛航空"]){
//        [name setString:@"airlines_qingdao.png"];
//        
//    }else if ([airCorpName isEqualToString:@"瑞丽"]|| [airCorpName isEqualToString:@"瑞丽航空"]||[airCorpName isEqualToString:@"瑞丽航空有限公司"]){
//        [name setString:@"airlines_ruili.png"];
//    }else if ([airCorpName isEqualToString:@"幸福"]||[airCorpName isEqualToString:@"幸福航空"]||[airCorpName isEqualToString:@"幸福航空有限公司"]){
//        [name setString:@"airlines_xingfu.png"];
//    }else if ([airCorpName isEqualToString:@"西藏"]||[airCorpName isEqualToString:@"西藏航空"]||[airCorpName isEqualToString:@"西藏航空有限公司"]){
//        [name setString:@"airlines_xizang.png"];
//    }
//    
//    return name;
//}
//
//+ (NSString *)getAirCorpShortName:(NSString *)airCorpName
//{
//    NSMutableString *name = [[NSMutableString alloc] initWithString:@""];
//    [airCorpName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if ([airCorpName isEqual:@"中国东方航空公司"])
//    {
//        [name setString:@"东方航空"];
//    }
//    else if ([airCorpName isEqual:@"中国国际航空公司"])
//    {
//        [name setString:@"中国国航"];
//    }
//    else if ([airCorpName isEqual:@"海南航空公司"])
//    {
//        [name setString:@"海南航空"];
//    }
//    else if ([airCorpName isEqual:@"中国南方航空公司"])
//    {
//        [name setString:@"南方航空"];
//    }
//    else if ([airCorpName isEqual:@"上海航空公司"])
//    {
//        [name setString:@"上海航空"];
//    }
//    else if ([airCorpName isEqual:@"深圳航空公司"])
//    {
//        [name setString:@"深圳航空"];
//    }
//    else if ([airCorpName isEqual:@"奥凯航空公司"])
//    {
//        [name setString:@"奥凯航空"];
//    }
//    else if ([airCorpName isEqual:@"厦门航空"])
//    {
//        [name setString:@"厦门航空"];
//    }
//    else if ([airCorpName isEqual:@"山东航空公司"])
//    {
//        [name setString:@"山东航空"];
//    }
//    else if ([airCorpName isEqual:@"四川航空公司"])
//    {
//        [name setString:@"四川航空"];
//    }
//    else if ([airCorpName isEqual:@"鹰联航空公司"])
//    {
//        [name setString:@"鹰联航空"];
//    }
//    else if ([airCorpName isEqual:@"祥鹏航空公司"])
//    {
//        [name setString:@"祥鹏航空"];
//    }
//    else if ([airCorpName isEqual:@"中联航航空公司"])
//    {
//        [name setString:@"中联航"];
//    }
//    else if ([airCorpName isEqual:@"中国联合航空公司"])
//    {
//        [name setString:@"联合航空"];
//    }
//    else if ([airCorpName isEqual:@"上海吉祥航空公司"])
//    {
//        [name setString:@"吉祥航空"];
//    }
//    else if ([airCorpName isEqual:@"华夏航空公司"])
//    {
//        [name setString:@"华夏航空"];
//    }
//    else if ([airCorpName isEqual:@"成都航空有限公司"])
//    {
//        [name setString:@"成都航空"];
//    }
//    else if ([airCorpName isEqual:@"河北航空有限公司"])
//    {
//        [name setString:@"河北航空"];
//    }
//    else if ([airCorpName isEqual:@"昆明航空有限公司"])
//    {
//        [name setString:@"昆明航空"];
//    }
//    else if ([airCorpName isEqual:@"北京首都航空有限公司"])
//    {
//        [name setString:@"首都航空"];
//    }
//    else if ([airCorpName isEqualToString:@"新西兰航空公司"])
//    {
//        [name setString:@"新西兰航空"];
//    }
//    else if ([airCorpName isEqualToString:@"大新华航空公司"])
//    {
//        [name setString:@"大新华航空"];
//    }
//    else if ([airCorpName isEqualToString:@"澳洲航空公司"])
//    {
//        [name setString:@"澳洲航空"];
//    }
//    else if ([airCorpName isEqualToString:@"维珍航空公司"])
//    {
//        [name setString:@"维珍航空"];
//    }
//    else if ([airCorpName isEqualToString:@"奥地利航空公司"])
//    {
//        [name setString:@"奥地利航空"];
//    }
//    else if ([airCorpName isEqualToString:@"北欧航空公司"])
//    {
//        [name setString:@"北欧航空"];
//    }
//    
//    return name;
//}
//
//// 获取航班状态颜色
//+ (UIColor *)getFlightStatusColor:(NSInteger)statusCode
//{
//    UIColor *textColor = nil;
//    
//    switch (statusCode) {
//        case 1: // 起飞
//        {
//            textColor = RGBACOLOR(95, 167, 254, 1);
//        }
//            break;
//        case 2: // 计划
//        {
//            textColor = RGBACOLOR(52, 52, 52, 1);
//        }
//            break;
//        case 3: // 到达
//        {
//            textColor = RGBACOLOR(20, 157, 52, 1);
//        }
//            break;
//        case 4: // 延误
//        {
//            textColor = RGBACOLOR(254, 75, 32, 1);
//        }
//            break;
//        case 5: // 取消
//        {
//            textColor = RGBACOLOR(119, 119, 119, 1);
//        }
//            break;
//        case 6: // 备降
//        {
//            textColor = RGBACOLOR(201, 38, 1, 1);
//        }
//            break;
//        default:
//            break;
//    }
//    
//    return textColor;
//}
//
//
//+ (NSNumber *)getCertificateType:(NSString *)key {
//    
//    if ([key isEqualToString:@"身份证"]) {
//        return [NSNumber numberWithInt:0];
//    }else if ([key isEqualToString:@"军人证"] || [key isEqualToString:@"军官证"]) {
//        return [NSNumber numberWithInt:1];
//    }else if ([key isEqualToString:@"回乡证"]) {
//        return [NSNumber numberWithInt:2];
//    }else if ([key isEqualToString:@"港澳通行证"] || [key isEqualToString:@"港澳台通行证"]) {
//        return [NSNumber numberWithInt:3];
//    }else if ([key isEqualToString:@"护照"]) {
//        return [NSNumber numberWithInt:4];
//    }else if ([key isEqualToString:@"居留证"]) {
//        return [NSNumber numberWithInt:5];
//    }else if ([key isEqualToString:@"其它"]) {
//        return [NSNumber numberWithInt:6];
//    }else if ([key isEqualToString:@"台胞证"]) {
//        return [NSNumber numberWithInt:7];
//    }else if ([key isEqualToString:@"台湾通行证"]) {
//        return [NSNumber numberWithInt:8];
//    }
//    return [NSNumber numberWithInt:9];
//}
//
//+ (NSString *)getCertificateName:(NSInteger)key {
//    NSString *name = nil;
//    switch (key) {
//        case 0:
//            name = @"身份证";
//            break;
//        case 1:
//            name = @"军人证";
//            break;
//        case 2:
//            name = @"回乡证";
//            break;
//        case 3:
//            name = @"港澳通行证";
//            break;
//        case 4:
//            name = @"护照";
//            break;
//        case 5:
//            name = @"居留证";
//            break;
//        case 6:
//            name = @"其它";
//            break;
//        case 7:
//            name = @"台胞证";
//            break;
//        case 8:
//            name = @"台湾通行证";
//            break;
//        default:
//            name = @"未知";
//            break;
//            
//    }
//    
//    return name;
//}
//
//+ (int)getClassTypeID:(NSString *)name {
//    int classTypeID = 0;
//    if ([name isEqualToString:@"经济舱"]) {
//        classTypeID = 0;
//        
//    } else if ([name isEqualToString:@"商务舱"]) {
//        classTypeID = 1;
//        
//    } else if ([name isEqualToString:@"头等舱"]) {
//        classTypeID = 2;
//    }
//    return classTypeID;
//}
//
//+ (NSString *)getClassTypeName:(int)type {
//    NSString *name = nil;
//    switch (type) {
////		case 0:
////			name = @"不限舱位";
////			break;
//        case 1:
//            name = @"经济舱";
//            break;
//        case 2:
//            name = @"商务舱";
//            break;
//        case 3:
//            name = @"头等舱";
//            break;			
//    }
//    
//    return name;
//}


+ (void)clearHotelData {
    // 需改动
//    [[ApartmentDetailViewController hoteldetail] removeAllObjects];
//    [[Coupon activedcoupons] removeAllObjects];
//    [[SelectRoomer allRoomers] removeAllObjects];
//    [[MyFavorite hotels] removeAllObjects];
//    
//    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
//    [hotelsearcher clearBuildData];
//    [HotelPostManager poptoroothotelsearcher];
//    [HotelConditionRequest poptoroothotelcondition];
//    
//    ApartmentNetParameter *aApartmentNetParameter = [HotelPostManager sharedApartmentOrder];
//    [aApartmentNetParameter clearBuildData];
//    
//    JHotelSearch *tonightSearcher = [HotelPostManager tonightsearcher];
//    [tonightSearcher clearBuildData];
}

+ (NSDate *) getBirthday: (NSString *)idNumber {
    NSString* Ai = @"";
    NSString *idCardNumber = [idNumber stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (idCardNumber.length == 18) {
        Ai = [idCardNumber substringWithRange:NSMakeRange(0, 17)];
    } else if (idCardNumber.length == 15) {
        Ai = [NSString stringWithFormat:@"%@19%@",
              [idCardNumber substringWithRange:NSMakeRange(0, 6)],
              [idCardNumber substringWithRange:NSMakeRange(6, 9)]];
    }else{
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthday=[dateFormatter dateFromString:[Ai substringWithRange:NSMakeRange(6, 8)]];   //需要转化的字符串
    
    return birthday;
}

+ (eLongIdCardValidationType)isIdCardNumberValid:(NSString *)idNumber{
    idNumber = [idNumber lowercaseString];
    
    if(nil == idNumber)
        return eLongIDCARD_LENGTH_SHOULD_NOT_BE_NULL;
    
    NSString* Ai = @"";
    NSString *idCardNumber = [idNumber stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([idCardNumber isEqualToString:@""]||idCardNumber.length==0) {
        return eLongIDCARD_LENGTH_SHOULD_NOT_BE_NULL;
    }
    
    if ((idCardNumber.length != 15 && idCardNumber.length != 18)) {
        return eLongIDCARD_LENGTH_SHOULD_BE_MORE_THAN_15_OR_18;
    }
    
    if (idCardNumber.length == 18) {
        Ai = [idCardNumber substringWithRange:NSMakeRange(0, 17)];
        if (!STRINGISNUMBER(Ai)) {
            return eLongIDCARD_SHOULD_BE_17_DIGITS_EXCEPT_LASTONE;
        }
    } else if (idCardNumber.length == 15) {
        Ai = [NSString stringWithFormat:@"%@19%@",
              [idCardNumber substringWithRange:NSMakeRange(0, 6)],
              [idCardNumber substringWithRange:NSMakeRange(6, 9)]];
        if (!STRINGISNUMBER(Ai)) {
            return eLongIDCARD_SHOULD_BE_15_DIGITS;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *birthday=[dateFormatter dateFromString:[Ai substringWithRange:NSMakeRange(6, 8)]];   //需要转化的字符串
    
    if(birthday == nil)
        return eLongIDCARD_BIRTHDAY_IS_INVALID;
    
    NSDate *today = [NSDate date];
    NSTimeInterval secondsBetweenDates= [birthday timeIntervalSinceDate:today];
    if(secondsBetweenDates > 0) {
        return eLongIDCARD_BIRTHDAY_SHOULD_NOT_LARGER_THAN_NOW;
    }
    
    int HONGKONG_AREACODE = 810000; // 香港地域编码值
    int TAIWAN_AREACODE = 710000; // 台湾地域编码值
    int MACAO_AREACODE = 820000; // 澳门地域编码值
    int areaCode = [[Ai substringWithRange:NSMakeRange(0, 6)] intValue];
    
    if (areaCode != HONGKONG_AREACODE
        && areaCode != TAIWAN_AREACODE
        && areaCode != MACAO_AREACODE
        && (areaCode > 659004 || areaCode < 110000)) {
        return eLongIDCARD_REGION_ENCODE_IS_INVALID;
    }
    
    // 判断如果是18位身份证，判断最后一位的值是否合法
    /*
     * 校验的计算方式： 　　1. 对前17位数字本体码加权求和 　　公式为：S = Sum(Ai * Wi), i = 0, ... , 16
     * 　　其中Ai表示第i位置上的身份证号码数字值，Wi表示第i位置上的加权因子，其各位对应的值依次为： 7 9 10 5 8 4 2 1 6
     * 3 7 9 10 5 8 4 2 　　2. 以11对计算结果取模 　　Y = mod(S, 11) 　　3. 根据模的值得到对应的校验码
     * 　　对应关系为： 　　 Y值： 0 1 2 3 4 5 6 7 8 9 10 　　校验码： 1 0 X 9 8 7 6 5 4 3 2
     */
    NSArray* Wi = [[NSArray alloc] initWithObjects: @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    NSArray* ValCodeArr = [[NSArray alloc] initWithObjects: @"1", @"0", @"x", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    int TotalmulAiWi = 0;
    for (int i = 0; i < 17; i++) {
        TotalmulAiWi += [[Ai substringWithRange:NSMakeRange(i, 1)] intValue] * [[Wi objectAtIndex:i] intValue];
    }
    int modValue = TotalmulAiWi % 11;
    NSString* strVerifyCode = [ValCodeArr objectAtIndex:modValue];
    Ai = [NSString stringWithFormat:@"%@%@", Ai, strVerifyCode];
    
    if (idCardNumber.length == 18) {
        if (![Ai isEqualToString: idCardNumber]) {
            return eLongIDCARD_IS_INVALID;
        } else {
            return eLongIDCARD_IS_VALID;
        }
    } else if (idCardNumber.length == 15) {
        return eLongIDCARD_IS_VALID;
    }
    
    return eLongIDCARD_PARSER_ERROR;
}

@end
