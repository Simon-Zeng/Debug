//
//  eLongImageManager.h
//  eLongLoadImage
//
//  Created by top on 14/12/16.
//  Copyright (c) 2014年 top. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^eLongLoadImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^eLongLoadImageCompletionWithFinishedBlock)(UIImage *image, NSURL *imageURL);

@interface eLongImageManager : NSObject
/**
 *  download image simple method 
 *
 *  @param imageURL        The url for the image.
 *  @param progressBlock   A block called while image is downloading
 *  @param completedBlock  A block called when operation has been completed.
 
 * @code
 
 [eLongLoadImage loadImageWithURL:imagePath1 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
 // progress
 } completed:^(UIImage *image, NSURL *imageURL) {
 if (image) {
 // do something with image
 }
 }];

 * @endcode
 */
+ (void)loadImageWithURL:(NSURL *)imageURL
                progress:(eLongLoadImageProgressBlock)progressBlock
               completed:(eLongLoadImageCompletionWithFinishedBlock)completedBlock;

/**
 *  检测图片是否在内存
 *
 *  @param url The url for the image
 *
 *  @return 
 */
+ (BOOL)cachedImageExistsForURL:(NSURL *)url;
/**
 *  检测图片是否存在磁盘
 *
 *  @param imageURl The url for the image.
 *
 *  @return
 */
+ (BOOL) diskImageExistsForURL:(NSURL *)imageURl;

/**
 *  返回磁盘中的图片
 *
 *  @param imageURl The url for the image
 *
 *  @return 
 */
+ (UIImage *) diskImageForURL:(NSURL *)imageURl;

/**
 *  返回缓存数据大小
 *
 *  @return
 */
+ (NSUInteger) getSize;

/**
 *  清空缓存
 */
+ (void)clearDisk;

@end
