//
//  eLongHotelDetailPartialModel.m
//  ElongClient
//
//  Created by Kirn on 14-10-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongHotelDetailPartialModel.h"

@implementation eLongHotelDetailPartialModel
- (id) init{
    if (self = [super init]) {
        self.positionIndex = -1;
    }
    return self;
}

- (NSString *) description{
    return [NSString stringWithFormat:@"酒店图片:%@\n酒店名:%@\n酒店星级:%ld\n酒店地址:%@\n酒店地理坐标:(%f,%f)\n酒店设施编码:%ld\n酒店好评率:%f\n酒店好评数量:%ld\n酒店差评数量:%ld\nPSG推荐信息:%@\n该酒店在列表中的位置:%ld\n",self.imageUrl,self.hotelName,(long)self.starCode,self.hotelAddress,self.hotelLocation.latitude,self.hotelLocation.longitude,self.hotelFacilityCode,self.commentPoint,(long)self.goodCommentCount,(long)self.badCommentCount,self.psgInfo,(long)self.positionIndex];
}
@end
