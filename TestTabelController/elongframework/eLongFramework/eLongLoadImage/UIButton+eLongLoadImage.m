//
//  UIButton+eLongLoadImage.m
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "UIButton+eLongLoadImage.h"
#import "SDWebImage/UIButton+WebCache.h"

@implementation UIButton (eLongLoadImage)

- (void)eLongLoadImageWithURL:(NSURL *)url
                     forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder options:SDWebImageRetryFailed];
}

- (void)eLongLoadBackgroundImageWithURL:(NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(UIImage *)placeholder
{
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:SDWebImageRetryFailed];
}

@end
