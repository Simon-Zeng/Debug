//
//  eLongAccountOrdersRequestModel.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountOrdersRequestModel.h"
#import "eLongAccountManager.h"


@implementation eLongAccountOrdersRequestModel

+(NSDictionary *)hotelOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime{
    NSDictionary *req =
                        @{@"CardNo":[eLongAccountManager userInstance].cardNo,
                          @"PageIndex":@(pageIndex),
                          @"PageSize":@(pageSize),
                          @"StartTime":startTime};
    return req;
}

+(NSDictionary *)internationalHotelsOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime{
    NSDictionary *req =
                        @{@"MemberShip":[eLongAccountManager userInstance].cardNo,
                          @"PageIndex":@(pageIndex),
                          @"PageSize":@(pageSize),
                          @"Status":@(0),
                          @"CreateTimeStart":startTime};
    return req;
}

+(NSDictionary *)grouponOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize OrderID:(NSInteger)orderID{
    NSDictionary *req =
                        @{@"CardNo":[eLongAccountManager userInstance].cardNo,
                          @"PageIndex":@(pageIndex),
                          @"PageSize":@(pageSize),
                          @"OrderID":@(orderID)};
    return req;
}

+(NSDictionary *)flightOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime{
//    NSDictionary *req =
//                        @{@"CardNo":[eLongAccountManager userInstance].cardNo,
//                          @"Header":[PostHeader header],
//                          @"PageIndex":@(pageIndex),
//                          @"PageSize":@(pageSize),
//                          @"StartTime":startTime};
//    return req;
    return nil;
    
}
+(NSDictionary *)internationalFlightOrdersRequestParametersWithPageNumber:(NSInteger)pageIndex PageCount:(NSInteger)pageSize StartTime:(NSString *)startTime{
    NSDictionary *req =
                        @{@"CardNo":[eLongAccountManager userInstance].cardNo,
                          @"PageNumber":@(pageIndex),
                          @"PageCount":@(pageSize),
                          @"StartCreateOrderTime":startTime};
    return req;
}

+(NSDictionary *)trainOrdersRequestParameters{
    NSDictionary *req =
                        @{@"CardNo":[eLongAccountManager userInstance].cardNo,
                          @"uid":[eLongAccountManager userInstance].cardNo,
                          @"wrapperId":@"oms0000000",//OMS
                          @"isLogin":@(1)};
    return req;
}

+(NSDictionary *)taxiOrdersRequestParameters{
    NSDictionary *req = @{@"uid":[eLongAccountManager userInstance].cardNo,@"productType":@"01"};
    return req;
}

+(NSDictionary *)rentCarOrdersRequestParameters{
    NSDictionary *req = @{@"uid":[eLongAccountManager userInstance].cardNo,@"productType":@"02"};
    return req;
}

+(NSDictionary *)ordersByType:(ElongOrdersType)type CardNo:(NSString *)cardNo PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex StartTime:(NSString *)start EndTime:(NSString *)end{
         NSMutableDictionary *req = [NSMutableDictionary dictionary];
    [req setValue:cardNo forKey:@"CardNo"];
    [req setValue:@(type) forKey:@"Type"];
    [req setValue:@(pageIndex) forKey:@"PageIndex"];
    [req setValue:@(pageSize) forKey:@"PageSize"];
    [req setValue:start forKey:@"StartTime"];
    [req setValue:end forKey:@"EndTime"];
    return req;
}

+(NSDictionary *)ordersByType:(ElongOrdersType)type PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex StartTime:(NSString *)start EndTime:(NSString *)end{
    return [self ordersByType:type CardNo:[eLongAccountManager userInstance].cardNo PageSize:pageSize PageIndex:pageIndex StartTime:start EndTime:end];
}

@end
