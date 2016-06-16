//
//  eLongImageManager.m
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import "eLongImageManager.h"
#import "SDWebImage/SDWebImageManager.h"

@implementation eLongImageManager

+ (void)loadImageWithURL:(NSURL *)imageURL
                progress:(eLongLoadImageProgressBlock)progressBlock
               completed:(eLongLoadImageCompletionWithFinishedBlock)completedBlock
{
    if (imageURL == nil || !imageURL.host) {
        if (completedBlock) {
            completedBlock(nil, nil);
        }
        
        return;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, imageURL);
        }
    }];
}

+ (BOOL)cachedImageExistsForURL:(NSURL *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    return [manager cachedImageExistsForURL:url];
}

+ (BOOL) diskImageExistsForURL:(NSURL *)imageURl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    return [manager diskImageExistsForURL:imageURl];
}

+ (UIImage *) diskImageForURL:(NSURL *)imageURl{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURl];
    UIImage *launchImage = [manager.imageCache imageFromDiskCacheForKey:key];
    return launchImage;
}

+ (NSUInteger) getSize{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    return [manager.imageCache getSize];
}

+ (void)clearDisk{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache clearDisk];
}

@end
