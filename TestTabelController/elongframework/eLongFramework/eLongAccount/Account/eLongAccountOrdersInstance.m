//
//  eLongAccountOrdersInstance.m
//  ElongClient
//  
//  Created by Janven Zhao on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountOrdersInstance.h"
#import "eLongAccountOrdersRequestModel.h"

@implementation eLongAccountOrdersInstance
#pragma mark ------URL Business
-(NSString *)hotelBusiness{
    return @"myelong/getHotelOrderList";
}
-(NSString *)internationalHotelsBusiness{
    return @"myelong/iOrderList";
}
-(NSString *)grouponHotelsBusiness{
    return @"myelong/getOrderByCardNo";
}
-(NSString *)flightBusiness{
    return @"jsonservice/myelong.aspx?action=GetFlightOrderListV2";
}
-(NSString *)internationalFlightBusiness{
    return @"myelong/globalFlightOrderQueryList";
}
-(NSString *)trainBusiness{
    return @"myelong/get12306TrainOrderList";
}
-(NSString *)taxiBusiness{
    return @"myelong/takeTaxi/orderList";
}
-(NSString *)rentCarBusiness{
    return @"myelong/rentCar/orderList";
}

-(NSString *)ordersTypeBusiness{
    return @"myelong/getHotelOrdersByType";
}

-(NSString *) getHotelOrdersByClientStatus{
    return @"myelong/getHotelOrdersByClientStatus";
}

#pragma mark
#pragma mark ------RequestMethord

-(void)requestHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{

    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self hotelBusiness] params:[eLongAccountOrdersRequestModel hotelOrdersRequestParametersWithPageIndex:pageIndex PageSize:pageSize StartTime:startTime]
                                                                       method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}



-(void)requestHotelOrderListByDicParam:(NSDictionary *)dicParam Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self hotelBusiness]
                             params:dicParam
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestTodayHotelOrderListByDicParam:(NSDictionary *)dicParam Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self getHotelOrdersByClientStatus]
                             params:dicParam
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestInternationalHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self internationalHotelsBusiness] params:[eLongAccountOrdersRequestModel internationalHotelsOrdersRequestParametersWithPageIndex:pageIndex PageSize:pageSize StartTime:startTime]
                             method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestGrouponHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize OrderID:(NSInteger)orderID Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self grouponHotelsBusiness] params:[eLongAccountOrdersRequestModel grouponOrdersRequestParametersWithPageIndex:pageIndex PageSize:pageSize OrderID:orderID]
                             method:eLongNetworkRequestMethodGET];
    
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestFlightOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
        
    NSURLRequest *doNot = [[eLongNetworkRequest sharedInstance] dotNetRequest:[self flightBusiness] params:[eLongAccountOrdersRequestModel flightOrdersRequestParametersWithPageIndex:pageIndex PageSize:pageSize StartTime:startTime] method:eLongNetworkRequestMethodPOST encoding:YES];
    
    [eLongHTTPRequest startRequest:doNot success:success failure:failed];
}

-(void)requestInternationalFlightOrderListWithPageNumber:(NSInteger)pageIndex PageCount:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self internationalFlightBusiness] params:[eLongAccountOrdersRequestModel internationalFlightOrdersRequestParametersWithPageNumber:pageIndex PageCount:pageSize StartTime:startTime]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestTrainOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self trainBusiness] params:[eLongAccountOrdersRequestModel trainOrdersRequestParameters]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestTaxiOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self taxiBusiness] params:[eLongAccountOrdersRequestModel taxiOrdersRequestParameters]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestRentCarOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self rentCarBusiness] params:[eLongAccountOrdersRequestModel rentCarOrdersRequestParameters]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:failed];
}

-(void)requestElongOrdersByType:(ElongOrdersType)type CardNo:(NSString *)cardNo PageSize:(NSInteger)size PageIndex:(NSInteger)index StartTime:(NSString *)start EndTime:(NSString *)end Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild{

    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self ordersTypeBusiness]
                             params:[eLongAccountOrdersRequestModel ordersByType:type CardNo:cardNo PageSize:size PageIndex:index StartTime:start EndTime:end]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:faild];
}

-(void)requestElongOrdersByDicParam:(NSDictionary *)paramDic Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild{
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self ordersTypeBusiness]
                             params:paramDic
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:faild];
}

-(void)requestElongOrdersByType:(ElongOrdersType)type PageSize:(NSInteger)size PageIndex:(NSInteger)index StartTime:(NSString *)start EndTime:(NSString *)end Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild{
    
    NSURLRequest *request = [[eLongNetworkRequest sharedInstance]
                             javaRequest:[self ordersTypeBusiness]
                             params:[eLongAccountOrdersRequestModel ordersByType:type PageSize:size PageIndex:index StartTime:start EndTime:end]
                             method:eLongNetworkRequestMethodGET];
    [eLongHTTPRequest startRequest:request success:success failure:faild];
}
@end
