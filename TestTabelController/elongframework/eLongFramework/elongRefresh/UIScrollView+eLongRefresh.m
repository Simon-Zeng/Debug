//
//  UIScrollView+elongRefresh.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "UIScrollView+elongRefresh.h"
#import "eLongRefreshHeader.h"
#import "eLongRefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (eLongRefresh)

- (CGFloat)offsetX{
   return self.contentOffset.x;
}

- (CGFloat)offsetY{
     return self.contentOffset.y;
}

- (CGFloat)insetTop{
    return self.contentInset.top;
}

- (CGFloat)insetLeft{
    return self.contentInset.left;
}

- (CGFloat)insetBottom{
    return self.contentInset.bottom;
}

- (CGFloat)insetRight{
    return self.contentInset.right;
}

- (CGFloat)contentH{
    return self.contentSize.height;
}

-(CGFloat)contentW{
    return self.contentSize.width;
}

- (void)setOffsetX:(CGFloat)offsetX{
    CGPoint point = self.contentOffset;
    point.x = offsetX;
    self.contentOffset = point;
}

- (void)setOffsetY:(CGFloat)offsetY{
    CGPoint point = self.contentOffset;
    point.y = offsetY;
    self.contentOffset = point;
}

- (void)setInsetTop:(CGFloat)insetTop{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top = insetTop;
    self.contentInset = contentInset;
}

- (void)setInsetLeft:(CGFloat)insetLeft{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.left = insetLeft;
    self.contentInset = contentInset;
}

- (void)setInsetRight:(CGFloat)insetRight{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.right = insetRight;
    self.contentInset = contentInset;
}

- (void)setInsetBottom:(CGFloat)insetBottom{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = insetBottom;
    self.contentInset = contentInset;
}

- (void)setContentH:(CGFloat)contentH{
    CGSize size = self.contentSize;
    size.height = contentH;
    self.contentSize = size;
}

- (void)setContentW:(CGFloat)contentW{
    CGSize size = self.contentSize;
    size.width = contentW;
    self.contentSize = size;
}

#pragma mark - header
static const char refreshHeaderKey = '\0';
- (void)setHeader:(eLongRefreshHeader *)header
{
    if (header != self.header) {
        // 删除旧的，添加新的
        [self.header removeFromSuperview];
        [self addSubview:header];
        
        // 存储新的
        [self willChangeValueForKey:@"header"]; // KVO
        objc_setAssociatedObject(self, &refreshHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"]; // KVO
    }
}

- (eLongRefreshHeader *)header
{
    return objc_getAssociatedObject(self, &refreshHeaderKey);
}

#pragma mark - footer
static const char refreshFooterKey = '\0';
- (void)setFooter:(eLongRefreshFooter *)footer
{
    if (footer != self.footer) {
        // 删除旧的，添加新的
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        // 存储新的
        [self willChangeValueForKey:@"footer"]; // KVO
        objc_setAssociatedObject(self, &refreshFooterKey,
                                 footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"]; // KVO
    }
}

- (eLongRefreshFooter *)footer
{
    return objc_getAssociatedObject(self, &refreshFooterKey);
}



@end
