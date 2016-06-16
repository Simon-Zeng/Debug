//
//  eLongAccountCustomerInfoListInstance.m
//  eLongFramework
//
//  Created by 吕月 on 15/9/22.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongAccountCustomerInfoListInstance.h"

@implementation eLongAccountCustomerInfoListInstance


static NSInteger customerIndex;
static NSMutableArray *allUserInfo;
static NSMutableArray *allAddressInfo;
static NSMutableArray *allInvoiceTitleInfo;
static NSMutableArray *allCardsInfo;
static NSMutableArray *allCouponInfo;
static NSMutableArray *allHotelFInfo;

- (NSInteger)customerIndex{
    return customerIndex;
}

- (void)setCustomerIndex:(NSInteger)customerIndex_{
    customerIndex = customerIndex_;
}

- (NSMutableArray *)allHotelFInfo  {
    
    @synchronized(self) {
        if(!allHotelFInfo) {
            allHotelFInfo = [[NSMutableArray alloc] init];
        }
    }
    return allHotelFInfo;
}

- (void)setAllHotelFInfo:(NSMutableArray *)allHotelFInfo_{
    allHotelFInfo = allHotelFInfo_;
}

- (NSMutableArray *)allUserInfo  {
    
    @synchronized(self) {
        if(!allUserInfo) {
            allUserInfo = [[NSMutableArray alloc] init];
        }
    }
    return allUserInfo;
}

- (void)setAllUserInfo:(NSMutableArray *)allUserInfo_{
    allUserInfo = allUserInfo_;
}

- (NSMutableArray *)allAddressInfo  {
    
    @synchronized(self) {
        if(!allAddressInfo) {
            allAddressInfo = [[NSMutableArray alloc] init];
        }
    }
    return allAddressInfo;
}

- (void)setAllAddressInfo:(NSMutableArray *)allAddressInfo_{

    allAddressInfo = allAddressInfo_;
}

- (NSMutableArray *)allInvoiceTitleInfo  {
    
    @synchronized(self) {
        if(!allInvoiceTitleInfo) {
            allInvoiceTitleInfo = [[NSMutableArray alloc] init];
        }
    }
    return allInvoiceTitleInfo;
}

- (void) setAllInvoiceTitleInfo:(NSMutableArray *)allInvoiceTitleInfo_{
    allInvoiceTitleInfo = allInvoiceTitleInfo_;
}

- (NSMutableArray *)allCardsInfo  {
    
    @synchronized(self) {
        if(!allCardsInfo) {
            allCardsInfo = [[NSMutableArray alloc] init];
        }
    }
    return allCardsInfo;
}

- (void)setAllCardsInfo:(NSMutableArray *)allCardsInfo_{
    allCardsInfo = allCardsInfo_;
}

- (NSMutableArray *)allCouponInfo  {
    
    @synchronized(self) {
        if(!allCouponInfo) {
            allCouponInfo = [[NSMutableArray alloc] init];
        }
    }
    return allCouponInfo;
}

- (void) setAllCouponInfo:(NSMutableArray *)allCouponInfo_{
    allCouponInfo = allCouponInfo_;
}

@end
