//
//  eLongPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongPostManager.h"
#import "eLongExtension.h"
#import "eLongNetworkRequest.h"
#import "eLongTokenReq.h"
#import "eLongAccountUserInstance.h"
#import "eLongDefine.h"
#import "AdSupport/AdSupport.h"
#import "eLongDeviceUtil.h"

#define APPTYPE     @"1"


static eLongJCard *card = nil;
static eLongJAddCard *addCard = nil;
static eLongJModifyCard *modifyCard = nil;
static eLongJDeleteCard *deleteCard = nil;
static eLongJVerifyCard *verifyCard = nil;
static eLongJCustomer *customer = nil;
static eLongJAddCustomer *addCustomer = nil;
static eLongJModifyCustomer *modifyCustomer = nil;
static eLongJDeleteCustomer *deleteCustomer = nil;
static eLongJGetAddress *getAddress = nil;
static eLongJAddAddress *addAddress = nil;
static eLongJModifyAddress *modifyAddress = nil;
static eLongJDeleteAddress *deleteAddress = nil;
static eLongJCoupon *coupon = nil;
static eLongActivateCoupon *activeCoupon = nil;
static eLongJDeleteHotelFavorite *deleteHF = nil;
static eLongJDeleteGrouponFavorite *deleteGF = nil;

static eLongJGetInvoiceTitle *getInvoiceTitles = nil;
static eLongJAddInvoiceTitle *addInvoiceTitle = nil;
static eLongJModifyInvoiceTitle *modifyInvoiceTitle = nil;
static eLongJDeleteInvoiceTitle *deleteInvoiceTitle = nil;
static eLongJSetDefaultAddress *setDefaultAddress = nil;
static eLongJSetDefaultInvoiceTitle *setDefaultInvoiceTitle = nil;

@implementation eLongPostManager
//Cards
+ (eLongJCard *)card  {
	@synchronized(self) {
		if(!card) {
			card = [[eLongJCard alloc] init];
		}
	}
	return card;
}
+ (eLongJAddCard *)addCard  {
	@synchronized(self) {
		if(!addCard) {
			addCard = [[eLongJAddCard alloc] init];
		}
	}
	return addCard;
}

+ (eLongJModifyCard *)modifyCard  {
	@synchronized(self) {
		if(!modifyCard) {
			modifyCard = [[eLongJModifyCard alloc] init];
		}
	}
	return modifyCard;
}
+ (eLongJDeleteCard *)deleteCard  {
	@synchronized(self) {
		if(!deleteCard) {
			deleteCard = [[eLongJDeleteCard alloc] init];
		}
	}
	return deleteCard;
}

+ (eLongJVerifyCard *)verifyCard  {
	@synchronized(self) {
		if(!verifyCard) {
			verifyCard = [[eLongJVerifyCard alloc] init];
		}
	}
	return verifyCard;
}
//+ (JPostHeader *)getCardType  {
//	@synchronized(self) {
//		if(!getCardType) {
//			getCardType = [[JPostHeader alloc] init];
//		}
//	}
//	return getCardType;
//}



//Customers
+ (eLongJCustomer *)customer  {
	
	@synchronized(self) {
		if(!customer) {
			customer = [[eLongJCustomer alloc] init];
		}
	}
	return customer;
}
+ (eLongJAddCustomer *)addCustomer  {
	
	@synchronized(self) {
		if(!addCustomer) {
			addCustomer = [[eLongJAddCustomer alloc] init];
		}
	}
	return addCustomer;
}
+ (eLongJModifyCustomer *)modifyCustomer  {
	
	@synchronized(self) {
		if(!modifyCustomer) {
			modifyCustomer = [[eLongJModifyCustomer alloc] init];
		}
	}
	return modifyCustomer;
}
+ (eLongJDeleteCustomer *)deleteCustomer  {
	
	@synchronized(self) {
		if(!deleteCustomer) {
			deleteCustomer = [[eLongJDeleteCustomer alloc] init];
		}
	}
	return deleteCustomer;
}

//Address
+ (eLongJGetAddress *)getAddress  {

	@synchronized(self) {
		if(!getAddress) {
			getAddress = [[eLongJGetAddress alloc] init];
		}
	}
	return getAddress;
}
+ (eLongJAddAddress *)addAddress  {

	@synchronized(self) {
		if(!addAddress) {
			addAddress = [[eLongJAddAddress alloc] init];
		}
	}
	return addAddress;
}
+ (eLongJModifyAddress *)modifyAddress  {
	
	@synchronized(self) {
		if(!modifyAddress) {
			modifyAddress = [[eLongJModifyAddress alloc] init];
		}
	}
	return modifyAddress;
}
+ (eLongJDeleteAddress *)deleteAddress  {
	
	@synchronized(self) {
		if(!deleteAddress) {
			deleteAddress = [[eLongJDeleteAddress alloc] init];
		}
	}
	return deleteAddress;
}

+ (eLongJSetDefaultAddress *)setDefaultAddress{
    
    @synchronized(self) {
        if(!setDefaultAddress) {
            setDefaultAddress = [[eLongJSetDefaultAddress alloc] init];
        }
    }
    return setDefaultAddress;
}

//Invoice
+ (eLongJGetInvoiceTitle *)getInvoiceTitles  {
    
    @synchronized(self) {
        if(!getInvoiceTitles) {
            getInvoiceTitles = [[eLongJGetInvoiceTitle alloc] init];
        }
    }
    return getInvoiceTitles;
}
+ (eLongJAddInvoiceTitle *)addInvoiceTitle  {
    
    @synchronized(self) {
        if(!addInvoiceTitle) {
            addInvoiceTitle = [[eLongJAddInvoiceTitle alloc] init];
        }
    }
    return addInvoiceTitle;
}
+ (eLongJModifyInvoiceTitle *)modifyInvoiceTitle  {
    
    @synchronized(self) {
        if(!modifyInvoiceTitle) {
            modifyInvoiceTitle = [[eLongJModifyInvoiceTitle alloc] init];
        }
    }
    return modifyInvoiceTitle;
}
+ (eLongJDeleteInvoiceTitle *)deleteInvoiceTitle  {
    
    @synchronized(self) {
        if(!deleteInvoiceTitle) {
            deleteInvoiceTitle = [[eLongJDeleteInvoiceTitle alloc] init];
        }
    }
    return deleteInvoiceTitle;
}

+ (eLongJSetDefaultInvoiceTitle *)setDefaultInvoiceTitle{

    @synchronized(self) {
        if(!setDefaultInvoiceTitle) {
            setDefaultInvoiceTitle = [[eLongJSetDefaultInvoiceTitle alloc] init];
        }
    }
    return setDefaultInvoiceTitle;
}

//Coupon
+ (eLongJCoupon *)coupon  {
	@synchronized(self) {
		if(!coupon) {
			coupon = [[eLongJCoupon alloc] init];
		}
	}
	return coupon;
}
+ (eLongActivateCoupon *)activeCoupon  {
	@synchronized(self) {
		if(!activeCoupon) {
			activeCoupon = [[eLongActivateCoupon alloc] init];
		}
	}
	return activeCoupon;
}

//hotelFavorite
+ (eLongJDeleteHotelFavorite *)deleteHF  {
	@synchronized(self) {
		if(!deleteHF) {
			deleteHF = [[eLongJDeleteHotelFavorite alloc] init];
		}
	}
	return deleteHF;
}

//grouponFavorite
+ (eLongJDeleteGrouponFavorite *)deleteGF{
    @synchronized(self) {
		if(!deleteGF) {
			deleteGF = [[eLongJDeleteGrouponFavorite alloc] init];
		}
	}
	return deleteGF;
}

static NSMutableDictionary *header = nil;

+ (NSDictionary *)hotelPostManagerHeader{
    @synchronized(self) {
        if(!header) {
            header = [[NSMutableDictionary alloc] init];
            [header safeSetObject:[eLongNetworkRequest sharedInstance].channelID forKey:@"ChannelId"];
            [header safeSetObject:[eLongDeviceUtil macaddress] forKey:@"DeviceId"];
            [header safeSetObject:[NSNull null] forKey:@"AuthCode"];
            [header safeSetObject:APPTYPE forKey:@"ClientType"];
            [header safeSetObject:APP_VERSION forKey:@"Version"];
            
            NSString *userTraceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"HTTPMONITOR_USERTRACEID"];
            if (!userTraceID) {
                userTraceID = @"";
            }
            [header safeSetObject:userTraceID forKey:@"UserTraceId"];
            NSString *osver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
            [header safeSetObject:osver forKey:@"OsVersion"];
            
//            if (IOSVersion_7) {
                if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
                {
                    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                    [header safeSetObject:idfaStr forKey:@"Guid"];
                }
//            }
            
            // 额外字段
            [header safeSetObject:[eLongDeviceUtil device] forKey:@"PhoneModel"];
            [header safeSetObject:@"iPhone" forKey:@"PhoneBrand"];
        }
    }
    // session iD
    [header safeSetObject:[[eLongTokenReq shared] sessionToken] forKey:SESSION_TOKEN];
    [header safeSetObject:[eLongNetworkRequest sharedInstance].channelID forKey:@"ChannelId"];
    
    // 放抓取验证码
    if ([[eLongTokenReq shared] checkCode]) {
        [header safeSetObject:[[eLongTokenReq shared] checkCode] forKey:@"CheckCode"];
    }
    
    
    //NSLog(@"header:%@", [header JSONRepresentation]);
    
    return header;
}
 @end
