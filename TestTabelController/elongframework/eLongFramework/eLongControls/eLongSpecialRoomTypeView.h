//
//  PromotionView.h
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ApartmentRoomTypeItem.h"

typedef enum {
    SpecialRoomLM,          // 今日特价
    SpecialRoomPhone,       // 手机专享
    SpecialRoomApartment,   // 公寓
    SpecialRoomVIP,         // 龙萃
    SpecialRoomGift,        // 送礼
    SpecialRoomLimit,       // 限时抢
    SpecialRoomPark,        // 停车场
    SpecialRoomWifi,        // Wifi
    SpecialRoomAround,      // 周边价
    SpecialRoomFiveToOne,   // 会员计划（买五送一）
    SpecialRoomHalfOff,     // 预付半价
    SpecialFull100Cut50,    // 满减活动
    ApartmentHalfCut,       // 公寓半价
    InterHotelGift,         // 国际酒店送礼
    NDiscount,              // N折
    Hongbao,                // 红包
    LiJian,                 // 立减
    Fan,                    // 返
    MemberCoupon,           // 会员优惠
}eLongSpecialRoomType;

@interface eLongSpecialRoomTypeItem : UIImageView{
    
}
@property (nonatomic,assign) NSInteger sortIndex;
- (id) initWithType:(eLongSpecialRoomType)roomType;
- (id) initWithType:(eLongSpecialRoomType)roomType tag:(NSString *)tag;
@end

@interface eLongSpecialRoomTypeView : UIView{
    UIScrollView *_contentView;
}
@property (nonatomic,assign) BOOL scrollEnabled;
@property (nonatomic,strong) NSArray *items;
- (void) reset;
- (void) addeLongSpecialRoomTypeItem:(eLongSpecialRoomTypeItem *)item;

// 公寓列表
//- (void)addApartmentRootItem:(ApartmentRoomTypeItem *)item;

@end
