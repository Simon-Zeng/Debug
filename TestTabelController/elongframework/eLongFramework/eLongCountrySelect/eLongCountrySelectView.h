//
//  eLongCountrySelectView.h
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/24.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongCountryModel,eLongCountrySelectView;

@protocol eLongCountrySelectViewDelegate <NSObject>

- (void)eLongCountrySelectView:(eLongCountrySelectView *)countrySelectView didSelectCountry:(eLongCountryModel *)countryModel;

@end

@interface eLongCountrySelectView : UIView

@property (nonatomic, weak) id<eLongCountrySelectViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame countryList:(NSArray *)countryList;

@end
