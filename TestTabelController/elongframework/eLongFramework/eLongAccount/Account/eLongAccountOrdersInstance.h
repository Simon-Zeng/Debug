//
//  eLongAccountOrdersInstance.h
//  ElongClient
//  订单系统管理类
//  Created by Janven Zhao on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountInstanceBase.h"
#import "elongAccountDefine.h"

@interface eLongAccountOrdersInstance : eLongAccountInstanceBase
/**
 *  请求国内酒店订单
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd日期格式
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;

/**
 *  请求国内酒店订单
 *
 *  @param DicParam  model中的设置好的请求参数
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestHotelOrderListByDicParam:(NSDictionary *)dicParam Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;

/**
 *  请求国内酒店已确认的订单（今日无房）
 *
 *  @param DicParam  model中的设置好的请求参数
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestTodayHotelOrderListByDicParam:(NSDictionary *)dicParam Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;

/**
 *  请求国际酒店订单
 *
 *  @param pageIndex 页码索引
 *  @param pageSize
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd日期格式
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestInternationalHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求团购酒店订单
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param orderID   订单号，传0
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestGrouponHotelOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize OrderID:(NSInteger)orderID Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求国内机票订单列表
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd日期格式
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestFlightOrderListWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求国际机票订单列表
 *
 *  @param pageIndex 页码索引
 *  @param pageSize  页码中记录条数
 *  @param startTime 起始时间 不能为空 yyyy-MM-dd日期格式
 *  @param success   网络成功回调
 *  @param failed    网络失败回调
 */
-(void)requestInternationalFlightOrderListWithPageNumber:(NSInteger)pageIndex PageCount:(NSInteger)pageSize StartTime:(NSString *)startTime Success:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求火车票订单列表
 *
 *  @param success 网络成功回调
 *  @param failed  网络失败回调
 */
-(void)requestTrainOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求打车业务订单列表
 *
 *  @param success 网络成功回调
 *  @param failed  网络失败回调
 */
-(void)requestTaxiOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;
/**
 *  请求租车业务订单列表
 *
 *  @param success 网络成功回调
 *  @param failed  网络失败回调
 */
-(void)requestRentCarOrderListWithSuccess:(NetSuccessCallBack )success Failed:(NetFailedCallBack )failed;

/**
 *  艺龙订单分类请求
 *
 *  @param type    类别 ElongOrdersType
 *  @param size    页码中记录条数
 *  @param index   索引页码
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param success 成功回调
 *  @param faild   失败回调
 */
-(void)requestElongOrdersByType:(ElongOrdersType)type PageSize:(NSInteger)size PageIndex:(NSInteger)index StartTime:(NSString *)start EndTime:(NSString *)end Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild;

/**
 *  艺龙订单分类请求
 *
 *  @param type    类别 ElongOrdersType
 *  @param cardNo  卡号
 *  @param size    页码中记录条数
 *  @param index   索引页码
 *  @param start   开始时间
 *  @param end     结束时间
 *  @param success 成功回调
 *  @param faild   失败回调
 */
-(void)requestElongOrdersByType:(ElongOrdersType)type CardNo:(NSString *)cardNo PageSize:(NSInteger)size PageIndex:(NSInteger)index StartTime:(NSString *)start EndTime:(NSString *)end Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild;

/**
 *  艺龙订单分类请求 传Dic请求参数的
 *  @param paramDic 请求参数
 *  @param success 成功回调
 *  @param faild   失败回调
 */
-(void)requestElongOrdersByDicParam:(NSDictionary *)paramDic Success:(NetSuccessCallBack)success Failed:(NetFailedCallBack)faild;


@end
