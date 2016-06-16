//
//  eLongPhotoPickerController.h
//  eLongPhotoPickerKitExample
//  照片选择控件
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

/**
 *  只有在用户点击了cancel后才会主动dismiss掉
 */


#import <UIKit/UIKit.h>

@class eLongAssetModel;
@protocol eLongPhotoPickerControllerDelegate;
@interface eLongPhotoPickerController : UINavigationController

#pragma mark - Properties

/** 是否允许选择视频 默认NO */
@property (nonatomic, assign) BOOL pickingVideoEnable;
/** 是否自动push到相册页面 默认 NO */
@property (nonatomic, assign) BOOL autoPushToPhotoCollection;
/** 每次最多可以选择带图片数量 默认9*/
@property (nonatomic, assign) NSUInteger maxCount;

/** delegate 回调 */
@property (nonatomic, weak , nullable)   id<eLongPhotoPickerControllerDelegate> photoPickerDelegate;

/** 用户选择完照片的回调 images<previewImage>  assets<eLongAssetModel>*/
@property (nonatomic, copy, nullable)   void(^didFinishPickingPhotosBlock)(NSArray<UIImage *> * _Nullable images, NSArray<eLongAssetModel *>* _Nullable assets);

/** 用户选择完视频的回调 coverImage:视频的封面,asset 视频资源地址 */
@property (nonatomic, copy, nullable)   void(^didFinishPickingVideoBlock)(UIImage  * _Nullable coverImage, eLongAssetModel * _Nullable asset);

/** 用户点击取消的block 回调 */
@property (nonatomic, copy, nullable)   void(^didCancelPickingBlock)();

/** 已选中的图片 */
@property (nonatomic ,strong) NSArray<eLongAssetModel *>  * _Nullable clickedImageAssets;



#pragma mark - Life Cycle

/**
 *  初始化eLongPhotoPickerController
 *
 *  @param maxCount 最大选择数量 0则不限制
 *  @param delegate 使用delegate 回调
 *
 *  @return eLongPhotoPickerController实例 或者 nil
 */
- (instancetype _Nonnull )initWithMaxCount:(NSUInteger)maxCount selectImages:(NSArray<eLongAssetModel *> * _Nullable)selectImagesAsset delegate:(_Nullable id<eLongPhotoPickerControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

#pragma mark - Methods

/**
 *  call photoPickerDelegate & didFinishPickingPhotosBlock
 *  
 *  @param assets 具体回传的资源
 */
- (void)didFinishPickingPhoto:(NSArray<eLongAssetModel *> * _Nullable)assets;
/**
 *  call photoPickerDelegate  & didFinishPickingVideoBlock
 *
 *  @param asset 具体选择的视频资源
 */
- (void)didFinishPickingVideo:(eLongAssetModel * _Nullable )asset;

/**
 *  call photoPickerDelegate & didCancelPickingPhotosBlock
 */
- (void)didCancelPickingPhoto;


@end


@protocol eLongPhotoPickerControllerDelegate <NSObject>

@optional

/**
 *  photoPickerController 点击确定后 代理回调
 *
 *  @param picker 具体的pickerController
 *  @param photos 选择的照片 -- 预览图
 *  @param assets 选择的原图数组  NSArray<PHAsset *>  or NSArray<ALAsset *> or nil
 */
- (void)photoPickerController:(eLongPhotoPickerController * _Nonnull)picker didFinishPickingPhotos:(NSArray<UIImage *> * _Nullable)photos sourceAssets:(NSArray<eLongAssetModel *> * _Nullable)assets;

/**
 *  photoPickerController 点击取消后回调
 *
 *  @param picker 具体的pickerController
 */
- (void)photoPickerControllerDidCancel:(eLongPhotoPickerController * _Nonnull)picker;

/**
 *  photoPickerController选择一个视频后的回调
 *
 *  @param picker     具体的photoPickerController
 *  @param coverImage 视频的预览图
 *  @param asset      视频的具体资源
 */
- (void)photoPickerController:(eLongPhotoPickerController * _Nonnull)picker didFinishPickingVideo:(UIImage * _Nullable)coverImage sourceAssets:(eLongAssetModel * _Nullable)asset;

@end


@interface eLongAlbumListController : UITableViewController

@property (nonatomic, copy, nullable)   NSArray *albums;

/** 已选中的图片 */
@property (nonatomic ,strong) NSArray<eLongAssetModel *>* _Nullable clickedImageAssets;

@end