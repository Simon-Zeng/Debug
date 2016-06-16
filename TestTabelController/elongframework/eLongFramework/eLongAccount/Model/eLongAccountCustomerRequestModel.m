//
//  eLongAccountCustomerRequestModel.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/24.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountCustomerRequestModel.h"
#import "eLongFileIOUtils.h"

@implementation eLongAccountCustomerRequestModel

-(NSDictionary *)addCustomerRequestParameters{
    return [self toDictionary];
}
//POST
-(NSString *)addCustomerRequestBusiness{
    return @"myelong/customer";
}

+(NSDictionary *)deleteCustomerWithID:(NSNumber *)customerID andCarNo:(NSString *)cardNo{
    NSMutableDictionary *rDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [rDic safeSetObject:cardNo forKey:@"CardNo"];
    [rDic safeSetObject:customerID forKey:@"CustomerId"];
    return rDic;
}
//DELETE
+(NSString *)deleteCustomerRequestBusiness{
    
    return @"myelong/customer";
}

-(NSDictionary *)modifyCutomerRequestParameter{
    return [self toDictionary];
}
//PUT
-(NSString *)modifyCustomerRequestBusiness{
    return @"myelong/customer";
}

+(NSDictionary *)getCustomersWithCardNo:(NSString *)cardNo CustomerType:(CustomerType)type PageIndex:(NSInteger)index PageSize:(NSInteger)size{
    NSMutableDictionary *rDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    [rDic safeSetObject:cardNo forKey:@"CardNo"];
    [rDic safeSetObject:@(type) forKey:@"CustomerType"];
    [rDic safeSetObject:@(index) forKey:@"PageIndex"];
    [rDic safeSetObject:@(size) forKey:@"PageSize"];
    return rDic;
}
//GET
+(NSString *)getCustomersRequestBusiness{
    return @"myelong/customers";
}
@end
