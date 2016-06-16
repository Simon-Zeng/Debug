//
//  eLongSegmentedControl.h
//  ElongClient
//
//  Created by zhucuirong on 15/10/29.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongSegmentedControl;

@protocol eLongSegmentedControlDelegate <NSObject>

- (void)eLongSegmentedControl:(eLongSegmentedControl *)segmentedControl clickAtIndex:(NSInteger)index;

@end

@interface eLongSegmentedControl : UIView
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, readonly) NSUInteger numberOfSegments;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *hairlineColor;

@property (nonatomic, weak) id<eLongSegmentedControlDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor indicatorView:(UIView *)indicatorView;//indicatorView.frame{0, 0, weight, height}

- (void)setSelectedSegmentIndex:(NSInteger)segment animated:(BOOL)animated;


@end
