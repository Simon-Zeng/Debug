//
//  eLongAlbumTablePicker.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "eLongAlbumAsset.h"
#import "eLongHotelUploadPhotosController.h"
#import "eLongAssetsPickerType.h"
#import "eLongAlbumAssetCell.h"
#import "eLongHotelDetailModel.h"

@protocol eLongAlbumTablePickerDelegate;
@interface eLongAlbumTablePicker : ElongBaseViewController<eLongAlbumAssetDelegate, UITableViewDataSource, UITableViewDelegate,eLongAlbumAssetCellDelegate>

@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *albumAssets;
@property (nonatomic, strong) eLongHotelUploadPhotosController *uploader;
@property (nonatomic, assign) id<eLongAlbumTablePickerDelegate> delegate;
@property (nonatomic, assign) NSString *titleString;
@property (nonatomic, strong) eLongHotelDetailModel *hotelDetailModel;
@property (nonatomic, strong) NSArray *clickedImageAssets;
// 最大上传图片数
@property (nonatomic, assign) NSUInteger maxUploadImageNumber;

- (id)initWithAssetGroup:(ALAssetsGroup *)asGroup;
- (id)initWithAssetGroup:(ALAssetsGroup *)asGroup title:(NSString *)title pickerType:(eLongAssetsPickerType)pickerType;
- (void)setClickedImageAssets:(NSArray *)clickedImageAssets;
@end

@protocol eLongAlbumTablePickerDelegate <NSObject>
@optional
- (void) elongAlbumTablePicker:(eLongAlbumTablePicker *)picker didPickedImages:(NSArray *)images;

@end