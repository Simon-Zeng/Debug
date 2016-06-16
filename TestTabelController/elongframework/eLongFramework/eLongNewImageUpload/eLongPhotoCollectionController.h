//
//  eLongPhotoCollectionController.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongAssetModel.h"


@class eLongAlbumModel;
@interface eLongPhotoCollectionController : UICollectionViewController

/** 具体的相册 */
@property (nonatomic, strong) eLongAlbumModel *_Nullable album;

/** 已选中的图片 */
@property (nonatomic ,strong) NSArray<eLongAssetModel *>* _Nullable clickedImageAssets;

/**
 *  根据给定宽度 获取UICollectionViewLayout 实例
 *
 *  @param width collectionView 宽度
 *
 *  @return UICollectionViewLayout实例
 */
+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width;

@end
