//
//  UIImageView+eLongLoadImage.m
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "UIImageView+eLongLoadImage.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation UIImageView (eLongLoadImage)

- (void)eLongLoadImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed];
}

- (void)eLongLoadImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholder
                     progress:(eLongLoadImageProgressBlock)progressBlock
                    completed:(eLongLoadImageCompletionWithFinishedBlock)completedBlock
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, imageURL);
        }
    }];
}

@end
