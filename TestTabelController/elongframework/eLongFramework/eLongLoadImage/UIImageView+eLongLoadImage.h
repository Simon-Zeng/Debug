//
//  UIImageView+eLongLoadImage.h
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongImageManager.h"

@interface UIImageView (eLongLoadImage)

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)eLongLoadImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholder;


/**
 * Set the imageView `image` with an `url`, placeholder
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed.
 */
- (void)eLongLoadImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholder
                     progress:(eLongLoadImageProgressBlock)progressBlock
                    completed:(eLongLoadImageCompletionWithFinishedBlock)completedBlock;

@end
