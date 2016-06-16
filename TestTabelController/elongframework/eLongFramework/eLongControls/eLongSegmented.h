//
//  eLongSegmented.h
//  ElongClient
//  自定义的segmented
//
//  Created by haibo on 11-10-27.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongSegItem.h"

@protocol eLongSegmentedDelegate <NSObject>

@optional
- (void)segmentedClick:(id)sender;
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index;
- (void)segmentedClickOver:(id)sender;


@end

@interface eLongSegmented : UIView <SegItemDelegate> {
@private
    NSInteger lastSelectedIndex;
    BOOL adjustTitleHeight;
    NSMutableArray  *segAr;
}

@property (nonatomic, assign) NSInteger selectedIndex;		// 被选中的segment序号
@property (nonatomic, assign) id<eLongSegmentedDelegate> delegate;
@property (nonatomic,assign) NSArray  *titleAr;
@property (nonatomic,assign) NSArray  *titleNum;

- (void)setIndexSegment:(NSInteger)index switchColor:(UIColor *)color;

- (void)setNumIndexSegment:(NSInteger)index switchColor:(UIColor *)color;

// 使用Autolayout初始化
- (id)initWithTitles:(NSArray *)titleArray withLeftMargin:(NSNumber *)leftMargin withRightMargin:(NSNumber *)rightMargin;

// 用图片进行初始化
- (id)initWithNormalImages:(NSArray *)nImages highlightedImages:(NSArray *)hImages Frame:(CGRect)rect;

- (id)initWithTitles:(NSArray *)titles;

// 用文字、字体大小、文字颜色初始化
- (id)initWithTitles:(NSArray *)titles
          NormalFont:(UIFont *)normalFont
    HightLightedFont:(UIFont *)highLightedFont
    NormalTitleColor:(UIColor *)normalColor
HightLightTitleColor:(UIColor *)hightLightColor
               Frame:(CGRect)rect;

// 不同图片、文字、按键间距初始化
- (id)initWithNormalImages:(NSArray *)nImages
         highlightedImages:(NSArray *)hImages
                    titles:(NSArray *)titleArray
                 titleFont:(UIFont *)font
          titleNormalColor:(UIColor *)normalColor
     titleHighlightedColor:(UIColor *)highlightedColor
                  interval:(NSInteger)pixel;

// 相同图片、文字、按键间距、frame初始化
- (id)initWithFrame:(CGRect)rect
        NormalImage:(UIImage *)nImage
   highlightedImage:(UIImage *)hImage
             titles:(NSArray *)titleArray
          titleFont:(UIFont *)font
   titleNormalColor:(UIColor *)normalColor
titleHighlightedColor:(UIColor *)highlightedColor
           interval:(NSInteger)pixel;


// 用文字、字体大小、文字颜色，BottomLineColor 初始化
// add by yangfan 2015.12.3
- (id)initWithTitles:(NSArray *)titles
          NormalFont:(UIFont *)normalFont
    HightLightedFont:(UIFont *)highLightedFont
    NormalTitleColor:(UIColor *)normalColor
HightLightTitleColor:(UIColor *)hightLightColor
 ItemBottomLineColor:(UIColor *)lineColor
               Frame:(CGRect)rect;

// 用文字、字体大小、文字颜色，SegItemBackgroundColor BottomLineColor 初始化
- (id)initWithTitles:(NSArray *)titles
          NormalFont:(UIFont *)normalFont
    HightLightedFont:(UIFont *)highLightedFont
    NormalTitleColor:(UIColor *)normalColor
HightLightTitleColor:(UIColor *)hightLightColor
 ItemBackgroundColor:(UIColor *)itemBackgroundColor
 ItemBottomLineColor:(UIColor *)lineColor
               Frame:(CGRect)rect;

// v3.0通用的灰底蓝框选择器,默认位置在顶部
- (id)initCommanSegmentedWithTitles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons;

// 自定义位置的灰底蓝框选择器
- (id)initSegmentedWithFrame:(CGRect)rect titles:(NSArray *)titles normalIcons:(NSArray *)nIcons highlightIcons:(NSArray *)hIcons;

// 团购详情样式的书签样式
- (id)initBookMarkWithFrame:(CGRect)rect Titles:(NSArray *)titleArray;

// 设置segment中的item自动居中
- (void)setIndexSegment:(NSInteger)index;


- (void)didSelect:(NSInteger)index;

@end
