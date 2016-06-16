//
//  eLongSegmentedControl.m
//  ElongClient
//
//  Created by zhucuirong on 15/10/29.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongSegmentedControl.h"
#import "eLongDefine.h"

@interface eLongSegmentedControl ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *hairline;

@end

@implementation eLongSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor indicatorView:(UIView *)indicatorView
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedSegmentIndex = 0;
        _font = [UIFont systemFontOfSize:17];
        _hairlineColor = [UIColor clearColor];
        
        NSMutableArray *array = [NSMutableArray array];
        CGFloat buttonLength = floorf(CGRectGetWidth(frame)/titleArray.count);
        
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i * buttonLength, 0, buttonLength, CGRectGetHeight(frame));
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:normalColor forState:UIControlStateNormal];
            [button setTitleColor:selectedColor forState:UIControlStateSelected];
            [button setTitleColor:selectedColor forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
            if (i == _selectedSegmentIndex) {
                button.selected = YES;
            }
            [self addSubview:button];
            [array addObject:button];
        }
        self.items = [NSArray arrayWithArray:array];
        
        self.hairline = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        self.hairline.backgroundColor = self.hairlineColor;
        [self addSubview:self.hairline];
        
        CGRect indicatorViewFrame = CGRectMake((buttonLength - CGRectGetWidth(indicatorView.frame))/2.f, CGRectGetHeight(frame) - CGRectGetHeight(indicatorView.frame), CGRectGetWidth(indicatorView.frame), CGRectGetHeight(indicatorView.frame));
        indicatorView.frame = indicatorViewFrame;
        [self addSubview:indicatorView];
        self.indicatorView = indicatorView;
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(eLongSegmentedControl:clickAtIndex:)]) {
        [self.delegate eLongSegmentedControl:self clickAtIndex:[self.items indexOfObject:sender]];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)segment animated:(BOOL)animated {
    if (_selectedSegmentIndex == segment || segment >= self.items.count) {
        return;
    }
    _selectedSegmentIndex = segment;
    
    [self.items enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == segment) {
            obj.selected = YES;
        }
        else {
            obj.selected = NO;
        }
    }];
    
    [self adjustIndicatorViewWithIndex:segment animated:animated];
}

- (void)adjustIndicatorViewWithIndex:(NSInteger)index animated:(BOOL)animated {
    UIButton *selectedBtn = [self.items objectAtIndex:index];
    [UIView animateWithDuration:animated ? 0.2 : 0.f delay:0.f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.indicatorView.center = CGPointMake(selectedBtn.center.x, self.indicatorView.center.y);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - custom accessor
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    [self setSelectedSegmentIndex:selectedSegmentIndex animated:NO];
}

- (NSUInteger)numberOfSegments {
    return self.items.count;
}

- (void)setHairlineColor:(UIColor *)hairlineColor {
    _hairlineColor = hairlineColor;
    self.hairline.backgroundColor = hairlineColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    for (UIButton *button in self.items) {
        button.titleLabel.font = font;
    }
}

@end
