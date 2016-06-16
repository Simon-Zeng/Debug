//
//  eLongSegItem.h
//  ElongClient
//  自定义segmented的组件
//
//  Created by haibo on 11-10-28.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SegItemDelegate;
@interface eLongSegItem : UIImageView {
@private
    UIImageView *iconImageView;
}

@property (nonatomic, weak) id<SegItemDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;				// 显示标题的label
@property (nonatomic, strong) UILabel *titleNumLabel;				// 显示标题下标数目的label
@property (nonatomic, strong) UIFont *titleNormalFont;			// 标题字体
@property (nonatomic, strong) UIFont *titleHighlightedFont;		// 按下状态时标题字体
@property (nonatomic, strong) UIColor *titleNormalColor;		// 标题颜色，默认为白色
@property (nonatomic, strong) UIColor *titleHighlightedColor;	// 按下状态时标题颜色，默认为白色
@property (nonatomic,strong) UIImageView *bottomLineView;


- (id)initWithFrameNew:(CGRect)frame;
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

- (void)changeState:(BOOL)isPressed;		// 是否被按下
- (void)setNormalIcon:(UIImage *)iconNormal hightedIcon:(UIImage *)iconHighted;			// 设置标题旁边的icon图标

@end

@protocol SegItemDelegate
@required
- (void)setHighlightedIndex:(NSInteger)index;

@end
