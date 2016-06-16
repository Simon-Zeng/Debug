//
//  eLongAssetModel.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongAssetModel.h"

#import "eLongPhotoPickerDefines.h"
#import "eLongPhotoManager.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface eLongAssetModel ()


/** PHAsset or ALAsset */
@property (nonatomic, strong) _Nonnull id asset;
/** asset  类型 */
@property (nonatomic, assign) eLongAssetType type;

/// ========================================
/// @name   视频,audio相关信息
/// ========================================

/** asset为Video时 video的时长 */
@property (nonatomic, copy) NSString *timeLength;


@end

@implementation eLongAssetModel
@synthesize originImage = _originImage;
@synthesize thumbnail = _thumbnail;
@synthesize previewImage = _previewImage;
@synthesize imageOrientation = _imageOrientation;
@synthesize playerItem = _playerItem;
@synthesize playerItemInfo = _playerItemInfo;


#pragma mark - Methods



/// ========================================
/// @name   Class Methods
/// ========================================

/**
 *  根据asset,type获取eLongAssetModel实例
 *
 *  @param asset 具体的Asset类型 PHAsset or ALAsset
 *  @param type  asset类型
 *
 *  @return eLongAssetModel实例
 */
+ ( eLongAssetModel  * _Nonnull )modelWithAsset:(_Nonnull id)asset type:(eLongAssetType)type {
    return [self modelWithAsset:asset type:type timeLength:@""];
}

/**
 *  根据asset,type,timeLength获取eLongAssetModel实例
 *
 *  @param asset      asset 非空
 *  @param type       asset 类型
 *  @param timeLength video时长
 *
 *  @return eLongAssetModel实例
 */
+ ( eLongAssetModel * _Nonnull )modelWithAsset:(_Nonnull id)asset type:(eLongAssetType)type timeLength:(NSString * _Nullable )timeLength {
    eLongAssetModel *model = [[eLongAssetModel alloc] init];
    model.asset = asset;
    model.type = type;
    model.timeLength = timeLength;
    return model;
}

#pragma mark - Getters

- (UIImage *)originImage {
    if (_originImage) {
        return _originImage;
    }
    __block UIImage *resultImage;
    [[eLongPhotoManager sharedManager] getOriginImageWithAsset:self.asset completionBlock:^(UIImage *image){
        resultImage = image;
    }];
    _originImage = resultImage;
    return resultImage;
}

- (UIImage *)thumbnail {
    if (_thumbnail) {
        return _thumbnail;
    }
    __block UIImage *resultImage;
    [[eLongPhotoManager sharedManager] getThumbnailWithAsset:self.asset size:keLongThumbnailSize completionBlock:^(UIImage *image){
        resultImage = image;
    }];
    _thumbnail = resultImage;
    return _thumbnail;
}

- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    }
    __block UIImage *resultImage;
    [[eLongPhotoManager sharedManager] getPreviewImageWithAsset:self.asset completionBlock:^(UIImage *image) {
        resultImage = image;
    }];
    _previewImage = resultImage;
    return _previewImage;
}

- (UIImageOrientation)imageOrientation {
    if (_imageOrientation) {
        return _imageOrientation;
    }
    __block UIImageOrientation resultOrientation;
    [[eLongPhotoManager sharedManager] getImageOrientationWithAsset:self.asset completionBlock:^(UIImageOrientation imageOrientation) {
        resultOrientation = imageOrientation;
    }];
    _imageOrientation = resultOrientation;
    return _imageOrientation;
}

- (NSString *)imageUrl{
    if (self.asset && [self.asset isKindOfClass:[ALAsset class]]) {
        return [NSString stringWithFormat:@"%@",[self.asset valueForProperty:ALAssetPropertyAssetURL]];
    }else if(self.asset && [self.asset isKindOfClass:[PHAsset class]]){
        PHAsset *pset = (PHAsset *)self.asset;
        return [NSString stringWithFormat:@"%@",pset.localIdentifier];
    }else{
        return nil;
    }
}

- (AVPlayerItem *)playerItem {
    if (_playerItem) {
        return _playerItem;
    }
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [[eLongPhotoManager sharedManager] getVideoInfoWithAsset:self.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    _playerItem = resultItem;
    _playerItemInfo = resultItemInfo ? : _playerItemInfo;
    return _playerItem;
}


- (NSDictionary *)playerItemInfo {
    if (_playerItemInfo) {
        return _playerItemInfo;
    }
    __block AVPlayerItem *resultItem;
    __block NSDictionary *resultItemInfo;
    [[eLongPhotoManager sharedManager] getVideoInfoWithAsset:self.asset completionBlock:^(AVPlayerItem *playerItem, NSDictionary *playerItemInfo) {
        resultItem = playerItem;
        resultItemInfo = [playerItemInfo copy];
    }];
    _playerItem = resultItem ? : _playerItem;
    _playerItemInfo = resultItemInfo;
    return _playerItemInfo;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"\n-------eLongAssetModel Desc Start-------\ntype : %d\nsuper :%@\n-------eLongAssetModel Desc End-------",(int)self.type,[super description]];
}

- (BOOL ) compareModelModel:(eLongAssetModel *_Nonnull)aModel{
    if ([aModel.imageUrl isEqualToString:self.imageUrl]) {
        return YES;
    }
    return NO;
}

- (BOOL) isPhotoLocal{
    __block BOOL local = NO;
    [[eLongPhotoManager sharedManager] getAssetSizeWithAsset:_asset completionBlock:^(CGFloat size) {
        if (size > 0) {
            local = YES;
        }else{
            local = NO;
        }
    }];
    return local;
}


@end
