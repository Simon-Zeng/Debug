//
//  eLongOrderHistoryPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongOrderHistoryPostManager.h"

static eLongJHotelOrderHistory *hotelorderhistory = nil;
static eLongJCancelHotelOrder *cancelhotelorder = nil;
static eLongJGetFlightOrder *getFlightOrder = nil;

@implementation eLongOrderHistoryPostManager

+ (eLongJHotelOrderHistory *)hotelorderhistory
{
	
	@synchronized(self) {
		if(!hotelorderhistory) {
			hotelorderhistory = [[eLongJHotelOrderHistory alloc] init];
		}
	}
	return hotelorderhistory;
}

+ (eLongJCancelHotelOrder *)cancelhotelorder
{
	
	@synchronized(self) {
		if(!cancelhotelorder) {
			cancelhotelorder = [[eLongJCancelHotelOrder alloc] init];
		}
	}
	return cancelhotelorder;
}

+ (eLongJGetFlightOrder *)getFlightOrder
{
	
	@synchronized(self) {
		if(!getFlightOrder) {
			getFlightOrder = [[eLongJGetFlightOrder alloc] init];
		}
	}
	return getFlightOrder;
}

@end
