//
//  eLongTabScrollItemView.h
//  MyElong
//
//  Created by yangfan on 15/12/29.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eLongTabScrollItemViewDelegate;

@interface eLongTabScrollItemView : UIView{
@private
    UIImageView *iconImageView;
}

@property (nonatomic, weak) id<eLongTabScrollItemViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;				// 显示标题的label
@property (nonatomic, strong) UIFont *titleNormalFont;			// 标题字体
@property (nonatomic, strong) UIFont *titleHighlightedFont;		// 按下状态时标题字体
@property (nonatomic, strong) UIColor *titleNormalColor;		// 标题颜色，默认为白色
@property (nonatomic, strong) UIColor *titleHighlightedColor;	// 按下状态时标题颜色，默认为白色
// 默认label 边框颜色
@property (nonatomic, strong) UIColor * labelBorderNormalColor;

- (void)changeState:(BOOL)isPressed;		// 是否被按下

@end

@protocol eLongTabScrollItemViewDelegate
@required
- (void)setHighlightedIndex:(NSInteger)index;

@end
