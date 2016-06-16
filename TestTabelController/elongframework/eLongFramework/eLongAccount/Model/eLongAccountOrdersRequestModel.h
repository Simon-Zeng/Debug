//
//  eLongAccountOrdersRequestModel.h
//  ElongClient
//  订单请求参数整合类
//  Created by Janven Zhao on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongRequestBaseModel.h"
#import "elongAccountDefine.h"

@interface eLongAccountOrdersRequestModel : eLongRequestBaseModel
/**
 *  国内酒店订单请求参数
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始开始时间 yyyy-MM-dd格式
 *
 *  @return 参数字典
 */
+(NSDictionary *)hotelOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime;
/**
 *  国际酒店订单请求参数
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始开始时间 不能为空 yyyy-MM-dd格式
 *
 *  @return 参数字典
 */
+(NSDictionary *)internationalHotelsOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime;
/**
 *  团购酒店订单请求参数
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param orderID   订单id 置为0
 *
 *  @return 请求参数
 */
+(NSDictionary *)grouponOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize OrderID:(NSInteger)orderID;
/**
 *  国内机票订单请求参数
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd格式
 *
 *  @return 请求参数
 */
+(NSDictionary *)flightOrdersRequestParametersWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime;
/**
 *  国际机票订单请求参数
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录的条数
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd格式
 *
 *  @return 请求参数
 */
+(NSDictionary *)internationalFlightOrdersRequestParametersWithPageNumber:(NSInteger)pageIndex PageCount:(NSInteger)pageSize StartTime:(NSString *)startTime;
/**
 *  火车票订单请求参数
 *
 *  @return 请求参数
 */
+(NSDictionary *)trainOrdersRequestParameters;
/**
 *  打车订单请求参数
 *
 *  @return 请求参数
 */
+(NSDictionary *)taxiOrdersRequestParameters;
/**
 *  租车订单请求参数
 *
 *  @return 请求参数
 */
+(NSDictionary *)rentCarOrdersRequestParameters;

/**
 *  艺龙分类订单请求
 *
 *  @param type      分类 ElongOrdersType
 *  @param cardNo    卡号
 *  @param pageSize  页码中记录条数
 *  @param pageIndex 索引页码
 *  @param start     开始时间 yyyy-MM-dd 不能为空
 *  @param end       结束时间 yyyy-MM-dd  不能为空
 *
 *  @return 请求参数
 */
+(NSDictionary *)ordersByType:(ElongOrdersType)type CardNo:(NSString *)cardNo PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex StartTime:(NSString *)start EndTime:(NSString *)end;

/**
 *  艺龙分类订单请求
 *
 *  @param type      分类 ElongOrdersType
 *  @param pageSize  页码中记录条数
 *  @param pageIndex 索引页码
 *  @param start     开始时间 yyyy-MM-dd 不能为空
 *  @param end       结束时间 yyyy-MM-dd  不能为空
 *
 *  @return 请求参数
 */
+(NSDictionary *)ordersByType:(ElongOrdersType)type PageSize:(NSInteger)pageSize PageIndex:(NSInteger)pageIndex StartTime:(NSString *)start EndTime:(NSString *)end;


@end
