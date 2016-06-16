//
//  eLongAssetCell.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongAssetModel;
@interface eLongAssetCell : UICollectionViewCell

@property (nonatomic, assign) BOOL canSelect;

/**
 *  按钮点击后的回调
 *  返回按钮的状态是否会被更改
 */
@property (nonatomic, copy, nullable)   BOOL(^willChangeSelectedStateBlock)(eLongAssetModel * _Nonnull asset);

/**
 *  当按钮selected状态改变后,回调
 */
@property (nonatomic, copy, nullable)   void(^didChangeSelectedStateBlock)(BOOL selected, eLongAssetModel * _Nonnull asset);

@property (nonatomic, copy, nullable)   void(^didSendAsset)(eLongAssetModel * _Nonnull asset, CGRect frame);


/**
 *  具体的资源model
 */
@property (nonatomic, strong, readonly, nonnull) eLongAssetModel *asset;

/**
 *  eLongPhotoCollectionController 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configCellWithItem:(eLongAssetModel * _Nonnull )item;

/**
 *  eLongPhotoPicker 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configPreviewCellWithItem:(eLongAssetModel * _Nonnull )item;

@end
