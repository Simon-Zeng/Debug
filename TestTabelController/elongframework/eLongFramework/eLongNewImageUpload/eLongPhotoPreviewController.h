//
//  eLongPhotoPreviewController.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongAssetModel;
@interface eLongPhotoPreviewController : UICollectionViewController

/** 所有的图片资源 */
@property (nonatomic, copy)   NSArray<eLongAssetModel *> *assets;
/** 选择的图片资源 */
@property (nonatomic, strong) NSMutableArray<eLongAssetModel *> *selectedAssets;

/** 当用户更改了选择的图片,点击返回时,回调此block */
@property (nonatomic, copy)   void(^didFinishPreviewBlock)( NSArray<eLongAssetModel *> *selectedAssets);

/** 用户点击底部bottom按钮后 回调 */
@property (nonatomic, copy)   void (^didFinishPickingBlock)(NSArray<UIImage *> *images ,NSArray<eLongAssetModel *> *assets);

/** 用户点击底部bottom按钮后 发送回调 */
@property (nonatomic, copy)   void (^didFinishPicking2SendBlock)(NSArray<UIImage *> *images ,NSArray<eLongAssetModel *> *assets);

/** 当前显示的asset index */
@property (nonatomic, assign) NSUInteger currentIndex;
/** 最大选择数量 */
@property (nonatomic, assign) NSUInteger maxCount;


+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size;

@end
