//
//  eLongSpecialPromotionView.m
//  ElongClient
//
//  Created by Dawn on 14-10-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongSpecialPromotionView.h"
#import "eLongDefine.h"
#import "eLongExtension.h"

@implementation eLongSpecialPromotionItem
- (id) initWithType:(SpecialPromotionType)promotionType{
    if (self = [super initWithFrame:CGRectZero]) {
        self.contentMode = UIViewContentModeRight;
        switch (promotionType) {
            case SpecialPromotionHongbao:{
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
                self.sortIndex = 3;
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
                tagLbl.text = @"红包";

            }
                break;
            case SpecialPromotionDiscount: {
                self.frame = CGRectMake(0, 0, 24 + 4, 12);
                self.sortIndex = 1;
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
                tagLbl.text = @"立减";
            }
            break;
            case SpecialPromotionDiscountHongbao:{
                self.frame = CGRectMake(0, 0, (24 + 2)*2, 12);
                self.image = [UIImage imageNamed:@"discount_hotellist"];
                self.sortIndex = 4;
                if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
                    self.discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, (24 + 2)*2, 12)];
                }else{
                    self.discountLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (24 + 2)*2, 12)];
                }
                self.discountLbl.font = [UIFont boldSystemFontOfSize:10.0f];
                self.discountLbl.backgroundColor = [UIColor clearColor];
                self.discountLbl.textColor = [UIColor clearColor];
                self.discountLbl.textAlignment = NSTextAlignmentRight;
                self.discountLbl.textColor = [UIColor colorWithHexStr:@"#4499ff"];
                self.discountLbl.layer.borderColor = [[UIColor colorWithHexStr:@"#4499ff"] CGColor];
                self.discountLbl.layer.borderWidth = SCREEN_SCALE;
                self.discountLbl.layer.cornerRadius = 1;
                self.discountLbl.layer.masksToBounds = YES;
                self.discountLbl.adjustsFontSizeToFitWidth = YES;
                [self addSubview:self.discountLbl];
            }
            break;
            case SpecialPromotionCoupon:{
                self.frame = CGRectMake(0, 0, 14 + 4, 12);
                self.sortIndex = 2;
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
                tagLbl.text = @"返";
            }
                break;
            case SpecialPromotionCouponNum:{
                self.frame = CGRectMake(0, 0, 24 + 2, 12);
                valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24 + 2, 12)];
                valueLbl.font = [UIFont systemFontOfSize:10.0f];
                valueLbl.textAlignment = NSTextAlignmentCenter;
                valueLbl.textColor = RGBACOLOR(254, 75, 32, 1);
                valueLbl.backgroundColor = [UIColor clearColor];
                [self addSubview:valueLbl];
                valueLbl.text = [NSString stringWithFormat:@"¥%ld",(long)self.value];
                self.sortIndex = 0;
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    self.discountLbl = nil;
//    [super dealloc];
}

- (void) setValue:(NSInteger)value{
    _value = value;
    valueLbl.text = [NSString stringWithFormat:@"¥%ld",(long)self.value];
}

@end

@implementation eLongSpecialPromotionView
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _contentView.scrollEnabled = NO;
        [self addSubview:_contentView];
        
        self.items = [NSMutableArray array];
        
        _contentView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)dealloc{
    self.items = nil;
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

- (void) addeLongSpecialPromotionItem:(eLongSpecialPromotionItem *)item{
    float x = 0;
    float y = 0;
    NSMutableArray *tItems = [NSMutableArray arrayWithArray:self.items];
    [tItems addObject:item];
    
    self.items = [tItems sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger index0 = ((eLongSpecialPromotionItem *)obj1).sortIndex;
        NSInteger index1 = ((eLongSpecialPromotionItem *)obj2).sortIndex;
        if (index0 > index1) {
            return 1;
        }else if(index0 == index1){
            return 0;
        }else{
            return -1;
        }
    }];
    
    [_contentView removeAllSubviews];
    
    for (eLongSpecialPromotionItem *typeItem in self.items) {
        typeItem.frame = CGRectMake(self.frame.size.width - x - typeItem.frame.size.width, y, typeItem.frame.size.width, typeItem.frame.size.height);
        x += typeItem.frame.size.width;
        [_contentView addSubview:typeItem];
    }
    _contentView.contentSize = CGSizeMake(x, 12);
}
@end
