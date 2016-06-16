//
//  eLongAlbumModel.h
//  eLongPhotoPickerKitExample
//  专辑相关的model
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    eLongAlbumTypeCarmeraRoll = 1,
    eLongAlbumTypeAll,
} eLongAlbumType;


@interface eLongAlbumModel : NSObject

#pragma mark - Properties

/** 相册的名称 */
@property (nonatomic, copy, readonly, nonnull)   NSString *name;

/** 照片的数量 */
@property (nonatomic, assign, readonly) NSUInteger count;

/** PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset> */
@property (nonatomic, strong, readonly, nonnull) id fetchResult;

#pragma mark - Methods


+ (eLongAlbumModel * _Nonnull )albumWithResult:(_Nonnull id)result name:( NSString * _Nonnull )name;

@end
