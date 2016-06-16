//
//  eLongHotelPromotionInfoRequest.m
//  ElongClient
//
//  Created by Dawn on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongHotelPromotionInfoRequest.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"
#import "JSONKit.h"

@implementation eLongHotelPromotionInfoRequest

DEF_SINGLETON(eLongHotelPromotionInfoRequest)
- (void) dealloc{
    self.checkinDate = nil;
    self.checkoutDate = nil;
    self.cityName = nil;
    self.hotelId = nil;
    self.hotelName = nil;
    self.roomType = nil;
    self.star = nil;
    self.orderId = nil;
}

- (id) init{
    if (self = [super init]) {
        self.promotionType = OrderPromotionNone; // 无促销
    }
    return self;
}

- (void) clear{
    self.checkinDate = nil;
    self.checkoutDate = nil;
    self.cityName = nil;
    self.hotelId = nil;
    self.hotelName = nil;
    self.roomType = nil;
    self.star = nil;
    self.orderId = nil;
    self.promotionType = 0;
    self.orderEntrance = 0;
    self.fixedPromotionType = 0;
    self.fixedOrderEntrance = 0;
}

- (NSString *) requestString{
    if (self.fixedOrderEntrance) {
        self.orderEntrance = self.fixedOrderEntrance;
    }
    if (self.fixedPromotionType) {
        self.promotionType = self.fixedPromotionType;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.checkinDate forKey:@"checkinDate"];
    [params safeSetObject:self.checkoutDate forKey:@"checkoutDate"];
    [params safeSetObject:self.cityName forKey:@"cityName"];
    [params safeSetObject:self.hotelId forKey:@"hotelId"];
    [params safeSetObject:self.hotelName forKey:@"hotelName"];
    [params safeSetObject:self.roomType forKey:@"roomType"];
    [params safeSetObject:self.star forKey:@"star"];
    [params safeSetObject:NUMBER(self.orderEntrance) forKey:@"orderEntrance"];
    [params safeSetObject:NUMBER(self.promotionType) forKey:@"promotionType"];
    [params safeSetObject:NUMBER(self.payType) forKey:@"payType"];
    [params safeSetObject:self.orderId forKey:@"orderId"];
    [params safeSetObject:[self makeJsonDateWithUTCDate:[NSDate date]] forKey:@"createTime"];
    NSString *requestString = [params JSONString];
    
    
    return requestString;
}

- (NSString *)makeJsonDateWithUTCDate:(NSDate *)utcDate{
    NSTimeInterval seconds = [utcDate timeIntervalSince1970];
    
    return [self makeJsonDateWithNSTimeInterval:seconds];
}

- (NSString *)makeJsonDateWithNSTimeInterval:(NSTimeInterval)seconds{
    
    NSTimeZone *stz=[NSTimeZone systemTimeZone];
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setTimeZone:stz];
    [f setDateFormat:@"Z"];
    NSString *jsondate=[NSString stringWithFormat:@"/Date(%.f%@)/",seconds*1000,[f stringFromDate:[NSDate date]]];
    
    return jsondate;
}

@end
