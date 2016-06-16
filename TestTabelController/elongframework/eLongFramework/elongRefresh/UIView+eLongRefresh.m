//
//  UIView+elongRefresh.m
//  elongRefresh
//
//  Created by zhaoyan on 15/7/6.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "UIView+elongRefresh.h"

@implementation UIView (eLongRefresh)

-(CGFloat)left{
    return self.frame.origin.x;
}

-(CGFloat)top{
    return self.frame.origin.y;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)width{
    return self.size.width;
}

-(CGFloat)height{
    return self.size.height;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setLeft:(CGFloat)left{
    CGRect rect  = self.frame;
    rect.origin.x = left;
    self.frame = rect;
}

-(void)setTop:(CGFloat)top{
    CGRect rect  = self.frame;
    rect.origin.y = top;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect  = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height{
    CGRect rect  = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect rect  = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setSize:(CGSize)size{
    CGRect rect  = self.frame;
    rect.size = size;
    self.frame = rect;
}

@end
