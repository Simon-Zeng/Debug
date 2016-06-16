//
//  UIButton+eLongLoadImage.h
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (eLongLoadImage)

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)eLongLoadImageWithURL:(NSURL *)url
                     forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

/**
 * Set the backgroundImageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param state       The state that uses the specified title. The values are described in UIControlState.
 * @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)eLongLoadBackgroundImageWithURL:(NSURL *)url
                               forState:(UIControlState)state
                       placeholderImage:(UIImage *)placeholder;


@end
