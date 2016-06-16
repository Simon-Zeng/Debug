//
//  eLongDateAndKeywordsSearchBarView.h
//  eLongHotel
//
//  Created by top on 16/2/25.
//  Copyright © 2016年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eLongDateAndKeywordsSearchBarViewDelegate;

@interface eLongDateAndKeywordsSearchBarView : UIView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<eLongDateAndKeywordsSearchBarViewDelegate> delegate;

@property (nonatomic, strong) NSDate *checkinDate;

@property (nonatomic, strong) NSDate *checkoutDate;

@property (nonatomic, copy) NSString *placeholderText;

@property (nonatomic, copy) NSString *keywordsText;

@property (nonatomic, strong) UIButton *clearBtn;

@end

@protocol eLongDateAndKeywordsSearchBarViewDelegate <NSObject>

- (void)changeDate;

- (void)changeKeywords;

- (void)clearKeywords;
@end
