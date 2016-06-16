//
//  eLongAccountAddressRequestModel.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountAddressRequestModel.h"

@implementation eLongAccountAddressRequestModel

-(NSDictionary *)addAddressRequestParameters{
    return [self toDictionary];
}
-(NSString *)addAddressRequestBusiness{
    return @"myelong/addAddress";
}

+(NSDictionary *)deleteAddressWithID:(NSNumber *)addressID{
    NSMutableDictionary *rDic = [NSMutableDictionary dictionary];
    [rDic setValue:addressID forKey:@"AddressId"];
    return rDic;
}
+(NSString *)deleteAddressRequestBusiness{

    return @"myelong/deleteAddress";
}

-(NSDictionary *)modifyAddressRequestParameter{
    return [self toDictionary];
}
-(NSString *)modifyAddressRequestBusiness{
    return @"myelong/modifyAddress";
}

+(NSDictionary *)getAddressListWithCardNo:(NSString *)cardNo PageIndex:(NSInteger)index PageSize:(NSInteger)size{
    NSMutableDictionary *rDic = [NSMutableDictionary dictionary];
    [rDic setValue:cardNo forKey:@"CardNo"];
    [rDic setValue:@(index) forKey:@"PageIndex"];
    [rDic setValue:@(size) forKey:@"PageSize"];
    return rDic;
}

+(NSString *)getAddressListRequestBusiness{
    return @"myelong/addressList";
}
@end
