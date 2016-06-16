//
//  eLongOrderHiddenBusinessUtil.h
//  eLongFramework
//
//  Created by yangfan on 15/11/5.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongOrderHiddenBusinessUtil : NSObject

/**
 *  删除隐藏的订单
 *
 *  @param hotelOrders 订单列表(NSDictionary)
 *
 *  @return 得到过滤后的数据
 */
+ (NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders;
/**
 *  删除隐藏的订单
 *
 *  @param hotelOrders 订单列表(MyElongOrderBaseHotelOrderModel)
 *
 *  @return 得到过滤后的数据
 */
+(NSArray *)removedHiddenOrdersInCurrentOrderModels:(NSArray *)hotelOrders;
/**
 *  读取本地隐藏订单数据
 *
 *  @return 得到隐藏数据
 */
+ (NSArray *)readHiddenOrderArrayByUser;
/**
 *  将OrderID写入本地隐藏文件
 *
 *  @param orderNumber orderId
 */
+ (void)writeHiddenOrderArrayByUser:(NSNumber *)orderNumber;


@end
