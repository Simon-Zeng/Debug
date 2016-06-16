//
//  eLongPhotoManager.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "eLongPhotoPickerDefines.h"
#import "eLongAlbumModel.h"
#import "eLongAssetModel.h"

@interface eLongPhotoManager : NSObject

@property (nonatomic, strong, readonly)  PHCachingImageManager * _Nullable cachingImageManager;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
@property (nonatomic, strong, readonly)  ALAssetsLibrary * _Nullable assetLibrary;
#pragma clang diagnostic pop


+ (instancetype _Nonnull)sharedManager;

#pragma mark - Methods

/**
 *  判断用户是否打开了图片授权
 *
 *  @return YES or NO
 */
- (BOOL)hasAuthorized;

/// ========================================
/// @name   获取Album相册相关方法
/// ========================================

/**
 *  获取所有的相册
 *
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAlbumsPickingVideoEnable:(BOOL)pickingVideoEnable
                    completionBlock:(void(^_Nonnull)(NSArray<eLongAlbumModel *> * _Nullable albums))completionBlock;


/**
 *  获取相册中的所有图片,视频
 *
 *  @param result             对应相册  PHFetchResult or ALAssetsGroup<ALAsset>
 *  @param pickingVideoEnable 是否允许选择视频
 *  @param completionBlock    回调block
 */
- (void)getAssetsFromResult:(id _Nonnull)result
         pickingVideoEnable:(BOOL)pickingVideoEnable
            completionBlock:(void(^_Nonnull)(NSArray<eLongAssetModel *> * _Nullable assets))completionBlock;

/// ========================================
/// @name   获取Asset对应信息相关方法
/// ========================================

/**
 *  根据提供的asset 获取原图图片
 *  使用异步获取asset的原图图片
 *  @param asset           具体资源 <PHAsset or ALAsset>
 *  @param completionBlock 回到block
 */
- (void)getOriginImageWithAsset:(id _Nonnull)asset
                completionBlock:(void(^_Nonnull)(UIImage * _Nullable image))completionBlock;

/**
 *  根据提供的asset获取缩略图
 *  使用同步方法获取
 *  @param asset           具体的asset资源 PHAsset or ALAsset
 *  @param size            缩略图大小
 *  @param completionBlock 回调block
 */
- (void)getThumbnailWithAsset:(id _Nonnull)asset
                         size:(CGSize)size
              completionBlock:(void(^_Nonnull)(UIImage *_Nullable image))completionBlock;

/**
 *  根据asset 获取屏幕预览图
 *
 *  @param asset           提供的asset资源 PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getPreviewImageWithAsset:(id _Nonnull)asset
                 completionBlock:(void(^_Nonnull)(UIImage * _Nullable image))completionBlock;

/**
 *  根据asset 获取图片的方向
 *
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getImageOrientationWithAsset:(id _Nonnull)asset
                     completionBlock:(void(^_Nonnull)(UIImageOrientation imageOrientation))completionBlock;
/**
 *  根据asset获取图片的大小信息
 *
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getAssetSizeWithAsset:(id _Nonnull)asset completionBlock:(void(^ _Nonnull)(CGFloat size))completionBlock;

/**
 *  根据asset获取Video信息
 *
 *  @param asset           PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getVideoInfoWithAsset:(id _Nonnull)asset
              completionBlock:(void(^ _Nonnull)(AVPlayerItem * _Nullable playerItem,NSDictionary * _Nullable playetItemInfo))completionBlock;

@end
