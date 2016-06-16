//
//  UIScrollView+elongRefresh.h
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//  scrollView分类 设置和获取对应属性

#import <UIKit/UIKit.h>

@class eLongRefreshFooter,eLongRefreshHeader;
@interface UIScrollView (eLongRefresh)

@property (assign, nonatomic) CGFloat insetTop;
@property (assign, nonatomic) CGFloat insetBottom;
@property (assign, nonatomic) CGFloat insetLeft;
@property (assign, nonatomic) CGFloat insetRight;

@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;

@property (assign, nonatomic) CGFloat contentW;
@property (assign, nonatomic) CGFloat contentH;

/** 下拉刷新控件 */
@property (strong, nonatomic) eLongRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) eLongRefreshFooter *footer;

@end
