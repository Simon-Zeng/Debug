//
//  eLongOrderHistoryPostManager.h
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongJHotelOrderHistory.h"
#import "eLongJCancelHotelOrder.h"
#import "eLongJGetFlightOrder.h"

@interface eLongOrderHistoryPostManager : NSObject {

}

+ (eLongJHotelOrderHistory *)hotelorderhistory;

+ (eLongJCancelHotelOrder *)cancelhotelorder;

+ (eLongJGetFlightOrder *)getFlightOrder;

@end
