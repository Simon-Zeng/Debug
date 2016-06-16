//
//  eLongPostManager.h
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongJCustomer.h"
#import "eLongJCard.h"
#import "eLongJCoupon.h"
#import "eLongJAddCustomer.h"
#import "eLongJModifyCustomer.h"
#import "eLongJDeleteCustomer.h"
#import "eLongJGetAddress.h"
#import "eLongJDeleteAddress.h"
#import "eLongJModifyAddress.h"
#import "eLongJAddAddress.h"
#import "eLongJAddCard.h"
#import "eLongJVerifyCard.h"
#import "eLongActivateCoupon.h"
//#import "HotelFavoriteRequest.h"
#import "eLongJDeleteHotelFavorite.h"
#import "eLongJModifyCard.h"
#import "eLongJDeleteCard.h"
#import "eLongJDeleteGrouponFavorite.h"

#import "eLongJAddInvoiceTitle.h"
#import "eLongJGetInvoiceTitle.h"
#import "eLongJDeleteInvoiceTitle.h"
#import "eLongJModifyInvoiceTitle.h"
#import "eLongJSetDefaultAddress.h"
#import "eLongJSetDefaultInvoiceTitle.h"

@class eLongJCustomer;
@class eLongJCard;
@class eLongJCoupon;
@interface eLongPostManager : NSObject {

}

+ (eLongJCard *)card;
+ (eLongJAddCard *)addCard;
+ (eLongJVerifyCard *)verifyCard;
+ (eLongJModifyCard *)modifyCard;
+ (eLongJDeleteCard *)deleteCard;
+ (eLongJCoupon *)coupon ;
+ (eLongActivateCoupon *)activeCoupon;

+ (eLongJCustomer *)customer ;
+ (eLongJAddCustomer *)addCustomer;
+ (eLongJModifyCustomer *)modifyCustomer;
+ (eLongJDeleteCustomer *)deleteCustomer;

+ (eLongJGetAddress *)getAddress;
+ (eLongJAddAddress *)addAddress;
+ (eLongJModifyAddress *)modifyAddress;
+ (eLongJDeleteAddress *)deleteAddress;
+ (eLongJSetDefaultAddress *)setDefaultAddress;

+ (eLongJGetInvoiceTitle *)getInvoiceTitles;
+ (eLongJAddInvoiceTitle *)addInvoiceTitle;
+ (eLongJModifyInvoiceTitle *)modifyInvoiceTitle;
+ (eLongJDeleteInvoiceTitle *)deleteInvoiceTitle;
+ (eLongJSetDefaultInvoiceTitle *)setDefaultInvoiceTitle;

+ (eLongJDeleteHotelFavorite *)deleteHF;
+ (eLongJDeleteGrouponFavorite *)deleteGF;


+ (NSDictionary *)hotelPostManagerHeader;

@end
