//
//  PromotionView.m
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongSpecialRoomTypeView.h"
#import "eLongExtension.h"
#import "eLongDefine.h"

@implementation eLongSpecialRoomTypeItem
- (id) initWithType:(eLongSpecialRoomType)roomType{
    return [self initWithType:roomType tag:nil];
}

- (id) initWithType:(eLongSpecialRoomType)roomType tag:(NSString *)tag{
    if (self = [super initWithFrame:CGRectZero]) {
        self.contentMode = UIViewContentModeLeft;
        switch (roomType) {
                // 添加公寓半价icon
            case ApartmentHalfCut:{
                self.frame = CGRectMake(0, 0, 48+4, 12);
                self.image = [UIImage imageNamed:@"apartment_price_cut.png"];
            }
                break;
            case SpecialRoomApartment:{
                self.frame = CGRectMake(0, 0, 24+4, 12);
                self.image = [UIImage imageNamed:@"mobileHouseListIcon.png"];
                self.sortIndex = 6;
            }
                break;
            case SpecialRoomGift:{
                self.frame = CGRectMake(0, 0, 12 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"hoteldetail_gift.png"];
                self.sortIndex = 11;
            }
                break;
            case SpecialRoomLM:{
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
//                self.image = [UIImage noCacheImageNamed:@"mobilePriceLMIcon.png"];
                self.sortIndex = 10;
                UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                tagLbl.font = [UIFont systemFontOfSize:9];
                tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                tagLbl.layer.borderWidth = SCREEN_SCALE;
                tagLbl.layer.cornerRadius = 1;
                tagLbl.layer.masksToBounds = YES;
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.textAlignment = NSTextAlignmentCenter;
                tagLbl.text = @"特价";
                [self addSubview:tagLbl];
            }
                break;
            case SpecialRoomPhone:{
                self.frame = CGRectMake(0, 0, 23 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceListIcon.png"];
                self.sortIndex = 9;
            }
                break;
            case SpecialRoomVIP:{
                self.frame = CGRectMake(0, 0, 12 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceListVipIconFlag.png"];
                self.sortIndex = 7;
            }
                break;
            case SpecialRoomLimit:{
                self.frame = CGRectMake(0, 0, 12 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"timelimitPriceListIconFlag.png"];
                self.sortIndex = 8;
            }
                break;
            case SpecialRoomPark:{
                self.frame = CGRectMake(0, 0, 12, 12);
                self.image = [UIImage noCacheImageNamed:@"hotellist_park.png"];
                self.sortIndex = 1;
            }
                break;
            case SpecialRoomWifi:{
                self.frame = CGRectMake(0, 0, 15 + 2, 12);
                self.image = [UIImage noCacheImageNamed:@"hotellist_wifi.png"];
                self.sortIndex = 0;
            }
                break;
            case SpecialRoomAround:{
                self.frame = CGRectMake(0, 0, 40 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceAroundSale.png"];
                self.sortIndex = 4;
            }
                break;
            case SpecialRoomFiveToOne:{
                self.frame = CGRectMake(0, 0, 40 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceFiveToOne.png"];
                self.sortIndex = 5;
            }
                break;
            case SpecialRoomHalfOff:{
                self.frame = CGRectMake(0, 0, 40 + 4, 12);
                self.sortIndex = 3;
                if (STRINGHASVALUE(tag)) {
                    UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                    tagLbl.font = [UIFont systemFontOfSize:9];
                    tagLbl.textColor = [UIColor colorWithHexStr:@"#ff5555"];
                    tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#ff5555"] CGColor];
                    tagLbl.layer.borderWidth = SCREEN_SCALE;
                    tagLbl.layer.cornerRadius = 1;
                    tagLbl.layer.masksToBounds = YES;
                    tagLbl.backgroundColor = [UIColor clearColor];
                    tagLbl.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tagLbl];
                    tagLbl.text = tag;
                }

            }
                break;
            case SpecialFull100Cut50:{
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
                self.sortIndex = 2;
                if (STRINGHASVALUE(tag)) {
                    UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                    tagLbl.font = [UIFont systemFontOfSize:9];
                    tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                    tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                    tagLbl.layer.borderWidth = SCREEN_SCALE;
                    tagLbl.layer.cornerRadius = 1;
                    tagLbl.layer.masksToBounds = YES;
                    tagLbl.backgroundColor = [UIColor clearColor];
                    tagLbl.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tagLbl];
                    tagLbl.text = @"满减";
                }
            }
                break;
            case InterHotelGift:{
                self.frame = CGRectMake(0, 0, 12 + 4, 12);
                self.image = [UIImage noCacheImageNamed:@"IHotel_hoteldetail_gift"];
                self.sortIndex = 11;
            }
                break;
            case NDiscount:{
                self.frame = CGRectMake(0, 0, 40 + 4, 12);
                self.sortIndex = 3;
                if (STRINGHASVALUE(tag)) {
                    UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                    tagLbl.font = [UIFont systemFontOfSize:9];
                    tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                    tagLbl.backgroundColor = [UIColor clearColor];
                    tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                    tagLbl.layer.borderWidth = SCREEN_SCALE;
                    tagLbl.layer.cornerRadius = 1;
                    tagLbl.layer.masksToBounds = YES;
                    tagLbl.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tagLbl];
                    tagLbl.text = tag;
                }
            }
                break;
            case Hongbao:{
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
                self.sortIndex = 13;
                UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                tagLbl.font = [UIFont systemFontOfSize:9];
                tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                tagLbl.layer.borderWidth = SCREEN_SCALE;
                tagLbl.layer.cornerRadius = 1;
                tagLbl.layer.masksToBounds = YES;
                tagLbl.textAlignment = NSTextAlignmentCenter;
                [self addSubview:tagLbl];
                tagLbl.text = @"红包";
            }
                break;
            case LiJian:{
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
                self.sortIndex = 14;
                
                UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                tagLbl.font = [UIFont systemFontOfSize:9];
                tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                tagLbl.layer.borderWidth = SCREEN_SCALE;
                tagLbl.layer.cornerRadius = 1;
                tagLbl.layer.masksToBounds = YES;
                tagLbl.textAlignment = NSTextAlignmentCenter;
                [self addSubview:tagLbl];
                tagLbl.text = @"立减";
            }
                break;
            case Fan:{
                self.frame = CGRectMake(0, 0, 14 + 4, 12);
                self.sortIndex = 15;
                UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                tagLbl.font = [UIFont systemFontOfSize:9];
                tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                tagLbl.layer.borderWidth = SCREEN_SCALE;
                tagLbl.layer.cornerRadius = 1;
                tagLbl.layer.masksToBounds = YES;
                tagLbl.textAlignment = NSTextAlignmentCenter;
                [self addSubview:tagLbl];
                tagLbl.text = @"返";
            }
                break;
            case MemberCoupon:{
                tag = @"会员优惠";
                self.frame = CGRectMake(0, 0, 44 + 4, 12);
                UILabel *tagLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 4, 12)];
                tagLbl.font = [UIFont systemFontOfSize:9];
                tagLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                tagLbl.layer.borderWidth = SCREEN_SCALE;
                tagLbl.layer.cornerRadius = 1;
                tagLbl.layer.masksToBounds = YES;
                tagLbl.backgroundColor = [UIColor clearColor];
                tagLbl.textAlignment = NSTextAlignmentCenter;
                [self addSubview:tagLbl];
                tagLbl.text = tag;
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGSize  size = [string sizeWithFont:font constrainedToSize:CGSizeMake(10000, 12)];
    
    return size;
}

@end

@interface eLongSpecialRoomTypeView()


@end
@implementation eLongSpecialRoomTypeView

- (void) dealloc{
    self.items = nil;
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _contentView.scrollEnabled = NO;
        [self addSubview:_contentView];
//        [_contentView release];
        
        self.items = [NSMutableArray array];
        
        _contentView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (BOOL) scrollEnabled{
    return _contentView.scrollEnabled;
}

- (void) setScrollEnabled:(BOOL)scrollEnabled{
    _contentView.scrollEnabled = scrollEnabled;
}

- (void) reset{
    [_contentView removeAllSubviews];
//    [self removeAllSubviews];
    self.items = [NSArray array];
}

- (void) addeLongSpecialRoomTypeItem:(eLongSpecialRoomTypeItem *)item{
    float x = 0;
    float y = 0;
    NSMutableArray *tItems = [NSMutableArray arrayWithArray:self.items];
    [tItems addObject:item];
    
    self.items = [tItems sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger index0 = ((eLongSpecialRoomTypeItem *)obj1).sortIndex;
        NSInteger index1 = ((eLongSpecialRoomTypeItem *)obj2).sortIndex;
        if (index0 > index1) {
            return 1;
        }else if(index0 == index1){
            return 0;
        }else{
            return -1;
        }
    }];
    
    [_contentView removeAllSubviews];
    
    for (eLongSpecialRoomTypeItem *typeItem in self.items) {
        typeItem.frame = CGRectMake(x, y, typeItem.frame.size.width, typeItem.frame.size.height);
        x += typeItem.frame.size.width;
        [_contentView addSubview:typeItem];
    }
    _contentView.contentSize = CGSizeMake(x, 12);
}

//#warning 公寓逻辑需修改
//- (void)addApartmentRootItem:(ApartmentRoomTypeItem *)item
//{
//    float x = 0;
//    float y = 0;
//    NSMutableArray *tItems = [NSMutableArray arrayWithArray:self.items];
//    [tItems addObject:item];
//
//    self.items = [tItems sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSInteger index0 = ((ApartmentRoomTypeItem *)obj1).sortIndex;
//        NSInteger index1 = ((ApartmentRoomTypeItem *)obj2).sortIndex;
//        if (index0 > index1) {
//            return 1;
//        }else if(index0 == index1){
//            return 0;
//        }else{
//            return -1;
//        }
//    }];
//
//    [_contentView removeAllSubviews];
//
//    for (ApartmentRoomTypeItem *typeItem in self.items) {
//        typeItem.frame = CGRectMake(x, y, typeItem.frame.size.width, typeItem.frame.size.height);
//        x += typeItem.frame.size.width;
//        [_contentView addSubview:typeItem];
//    }
//    _contentView.contentSize = CGSizeMake(x, 12);
//}

@end
