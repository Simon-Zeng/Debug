//
//  eLongHotelDetailHoldingTimeModel.m
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongHotelDetailHoldingTimeModel.h"

@implementation eLongHotelDetailHoldingTimeModel

- (NSString *) ArriveTimeEarly{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_ArriveTimeEarly];
}

- (NSString *) ArriveTimeLate{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_ArriveTimeLate];
}
@end
