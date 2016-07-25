//
//  BubbleView.h
//  TestTabelController
//
//  Created by wzg on 16/7/22.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleView : UIView

@property (nonatomic, strong)UIView *containerView;

@property (nonatomic, strong)UILabel *title;

@property (nonatomic, assign) CGFloat bWidth;

@property (nonatomic, assign) CGFloat viscosity;

@property (nonatomic, strong)UIColor *bColor;

@property (nonatomic, strong)UIView *frontView;

- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)view;
- (void)setup;
- (void)removeAnimate:(BOOL)remove;
@end
