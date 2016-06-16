//
//  eLongRedPacketModel.m
//  eLongFramework
//
//  Created by 吕月 on 15/8/31.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongRedPacketModel.h"
#import "eLongFileIOUtils.h"
#import "eLongDefine.h"

@implementation eLongRedPacketModel

- (void) reset{
    self.hotelUnactiveAmount = 0.0;
    self.hotelUnactiveNumber = 0;
    self.hotelActiveAmount = 0.0;
    self.hotelActiveNumber = 0;
    self.rujiaHotelActiveAmount = 0.0;
    self.rujiaHotelActiveNumber = 0;
    self.boTaoHotelActiveAmount = 0.0;
    self.boTaoHotelActiveNumber = 0;
    self.trainUnactiveAmount = 0.0;
    self.trainUnactiveNumber = 0;
    self.trainActiveAmount = 0.0;
    self.trainActiveNumber = 0;
    self.generalActiveAmount = 0.0;
    self.generalActiveNumber = 0;
    self.generalUnactiveAmount = 0.0;
    self.generalUnactiveNumber = 0;
    self.hasPrivilege = NO;
}

- (id) initWithHongbaos:(NSDictionary *)hongbao{
    if (self = [super init]) {
        if (!OBJECTISNULL([hongbao safeObjectForKey:@"activeBonusRecords"])) {
            for (NSDictionary *item in [hongbao safeObjectForKey:@"activeBonusRecords"]) {
                NSInteger hongbaoType = [[item safeObjectForKey:@"rechargeType"] intValue];
                CGFloat amount = [[item safeObjectForKey:@"amountFee"] floatValue];
                NSInteger number = [[item safeObjectForKey:@"num"] intValue];
                NSInteger days = [[item safeObjectForKey:@"days"] intValue];
                CGFloat soonExpireAmountFee = [[item safeObjectForKey:@"soonExpireAmountFee"] floatValue];
                switch (hongbaoType) {
                    case 103093:{   // 如家专用红包，不能记入酒店红包
                        self.rujiaHotelActiveNumber += number;
                        self.rujiaHotelActiveAmount += amount;
                        self.hotelSoonExpireAmountFee += soonExpireAmountFee;
                        self.hotelDays = days;
                    }
                        break;
                    case 103094:{   // 酒店专用红包
                        self.hotelActiveNumber += number;
                        self.hotelActiveAmount += amount;
                        self.hotelSoonExpireAmountFee += soonExpireAmountFee;
                        self.hotelDays = days;
                    }
                        break;
                    case 103095:{   // 火车票专用
                        self.trainActiveNumber += number;
                        self.trainActiveAmount += amount;
                        self.trainSoonExpireAmountFee += soonExpireAmountFee;
                        self.trainDays = days;
                    }
                        break;
                    case 103098:{   // 通用红包，适用于酒店和机票
                        self.generalActiveNumber += number;
                        self.generalActiveAmount += amount;
                        self.soonExpireAmountFee += soonExpireAmountFee;
                        self.days = days;
                    }
                        break;
                    case 103092: {   //铂涛专用红包
                        self.boTaoHotelActiveNumber += number;
                        self.boTaoHotelActiveAmount += amount;
                        self.soonExpireAmountFee += soonExpireAmountFee;
                        self.hotelDays = days;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        if (!OBJECTISNULL([hongbao safeObjectForKey:@"unactiveBonusRecords"])) {
            for (NSDictionary *item in [hongbao safeObjectForKey:@"unactiveBonusRecords"]) {
                NSInteger hongbaoType = [[item safeObjectForKey:@"rechargeType"] intValue];
                CGFloat amount = [[item safeObjectForKey:@"amountFee"] floatValue];
                NSInteger number = [[item safeObjectForKey:@"num"] intValue];
                
                switch (hongbaoType) {
                    case 103094:{   // 酒店专用红包
                        self.hotelUnactiveNumber += number;
                        self.hotelUnactiveAmount += amount;
                    }
                        break;
                    case 103095:{   // 火车票专用
                        self.trainUnactiveNumber += number;
                        self.trainUnactiveAmount += amount;
                    }
                        break;
                    case 103098:{   // 通用红包，适用于酒店和机票
                        self.generalUnactiveNumber += number;
                        self.generalUnactiveAmount += amount;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        // 得到未登录用户是否有红包
        self.hasPrivilege = [[hongbao objectForKey:@"hasPrivilege"] floatValue];
    }
    return self;
}

@end



@implementation elongHongBaoCountResponseModel

@end
