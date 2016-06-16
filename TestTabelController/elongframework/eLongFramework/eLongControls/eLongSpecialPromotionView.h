//
//  eLongSpecialPromotionView.h
//  ElongClient
//
//  Created by Dawn on 14-10-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    SpecialPromotionHongbao,          //红包
    SpecialPromotionCoupon,           //返
    SpecialPromotionCouponNum,        //返金额
    SpecialPromotionDiscountHongbao,  //首晚五折
    SpecialPromotionDiscount          //立减
}SpecialPromotionType;

@interface eLongSpecialPromotionItem : UIImageView{
    UILabel *valueLbl;
}
@property (nonatomic,assign) NSInteger sortIndex;
@property (nonatomic,assign) NSInteger value;
@property (nonatomic,retain) UILabel *discountLbl;
- (id) initWithType:(SpecialPromotionType)promotionType;
@end

@interface eLongSpecialPromotionView : UIView{
    UIScrollView *_contentView;
}
@property (nonatomic,assign) BOOL scrollEnabled;
@property (nonatomic,retain) NSArray *items;
- (void) reset;
- (void) addeLongSpecialPromotionItem:(eLongSpecialPromotionItem *)item;
@end
