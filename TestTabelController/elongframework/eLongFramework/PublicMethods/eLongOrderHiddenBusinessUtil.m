//
//  eLongOrderHiddenBusinessUtil.m
//  eLongFramework
//
//  Created by yangfan on 15/11/5.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongOrderHiddenBusinessUtil.h"
#import "eLongOrderBaseHotelOrderModel.h"
#import "eLongFileDefine.h"

#define HIDDEN_HOTELORDERS @"hidden_hotelOrders"

@implementation eLongOrderHiddenBusinessUtil

//处理隐藏的订单 (NSDictionary)
+(NSArray *)removedHiddenOrdersInCurrentOrders:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];
    
    for(NSDictionary *hotelOrder in hotelOrders){
        NSString *orderNumber = [hotelOrder safeObjectForKey:@"OrderNo"];
        if([hiddenOrdersArray containsObject:orderNumber]){
            [tmpHotelOrders removeObject:hotelOrder];
        }
    }
    
    return tmpHotelOrders;
}

//处理隐藏的订单 (MyElongOrderBaseHotelOrderModel)
+(NSArray *)removedHiddenOrdersInCurrentOrderModels:(NSArray *)hotelOrders{
    NSArray *hiddenOrdersArray = [self readHiddenOrderArrayByUser];
    NSMutableArray *tmpHotelOrders = [NSMutableArray arrayWithArray:hotelOrders];
    
    for(eLongOrderBaseHotelOrderModel *hotelOrder in hotelOrders){
        NSNumber *orderNumber =[NSNumber numberWithInteger:hotelOrder.OrderNo];
        if([hiddenOrdersArray containsObject:orderNumber]){
            [tmpHotelOrders removeObject:hotelOrder];
        }
    }
    return tmpHotelOrders;
}

//从文件读取隐藏的订单列表
+ (NSArray *)readHiddenOrderArrayByUser{
    NSArray *hiddenOrdersArray = [NSArray array];
    
    NSData *hiddenOrdersData = [[NSUserDefaults standardUserDefaults] objectForKey:HIDDEN_HOTELORDERS];
    if(hiddenOrdersData!=nil){
        hiddenOrdersArray = [NSKeyedUnarchiver unarchiveObjectWithData:hiddenOrdersData];
    }
    
    return hiddenOrdersArray;
}

//将隐藏的订单写入到文件
+ (void)writeHiddenOrderArrayByUser:(NSNumber *)orderNumber{
    NSMutableArray *hiddenOrdersArray = [NSMutableArray array];
    [hiddenOrdersArray addObjectsFromArray:[self readHiddenOrderArrayByUser]];
    
    if(![hiddenOrdersArray containsObject:orderNumber]){
        [hiddenOrdersArray addObject:orderNumber];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:hiddenOrdersArray] forKey:HIDDEN_HOTELORDERS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
