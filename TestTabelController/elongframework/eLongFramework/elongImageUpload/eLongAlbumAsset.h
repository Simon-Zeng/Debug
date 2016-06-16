//
//  eLongAlbumAsset.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class eLongAlbumAsset;

@protocol eLongAlbumAssetDelegate <NSObject>

@optional

- (void)assetSelected:(eLongAlbumAsset *)asset;
- (BOOL)shouldSelectAsset:(eLongAlbumAsset *)asset;

@end

@interface eLongAlbumAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) id<eLongAlbumAssetDelegate> delegate;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;

@end
