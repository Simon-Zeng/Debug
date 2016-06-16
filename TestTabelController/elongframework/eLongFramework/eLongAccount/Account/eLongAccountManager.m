//
//  eLongAccountManager.m
//  ElongClient
//
//  Created by Janven Zhao on 15/3/16.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAccountManager.h"

@implementation eLongAccountManager

+(eLongAccountUserInstance *)userInstance{
    static eLongAccountUserInstance *user_Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user_Instance = [[eLongAccountUserInstance alloc] init];
    });
    return user_Instance;
}

+(eLongAccountCustomerInfoListInstance *)customerInfoListInstance{

    static eLongAccountCustomerInfoListInstance *user_CustomerInfoListInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        user_CustomerInfoListInstance = [[eLongAccountCustomerInfoListInstance alloc] init];
    });
    return user_CustomerInfoListInstance;
}

+(eLongAccountCAInstance *)CAInstance{
    static eLongAccountCAInstance *ca_Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        ca_Instance = [[eLongAccountCAInstance alloc] init];
    });
    return ca_Instance;
}
+(eLongAccountHongBaoInstance *)hongBaoInstance{
    static eLongAccountHongBaoInstance *hongBao_Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        hongBao_Instance = [[eLongAccountHongBaoInstance alloc] init];
    });
    return hongBao_Instance;
}
+(eLongAccountOrdersInstance *)ordersInstance{
    static eLongAccountOrdersInstance *orders = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        orders = [[eLongAccountOrdersInstance alloc] init];
    });
    return orders;
}


+(eLongAccountredDotInstace *)redDotInstance{
    static eLongAccountredDotInstace *redDotInstace = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        redDotInstace = [[eLongAccountredDotInstace alloc] init];
    });
    return redDotInstace;
}

@end
