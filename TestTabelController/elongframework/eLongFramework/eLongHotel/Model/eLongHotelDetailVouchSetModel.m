//
//  eLongHotelDetailVouchSetModel.m
//  ElongClient
//
//  Created by Dawn on 15/1/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongHotelDetailVouchSetModel.h"

@implementation eLongHotelDetailVouchSetModel
- (NSString *) ArriveEndTime{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_ArriveEndTime];
}

- (NSString *) ArriveStartTime{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_ArriveStartTime];
}

- (NSString *) StartDate{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_StartDate];
}

- (NSString *) EndDate{
    return [NSString stringWithFormat:@"/Date(%@+0800)/",_EndDate];
}
@end
