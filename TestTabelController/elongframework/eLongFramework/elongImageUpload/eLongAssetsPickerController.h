//
//  eLongAssetsPickerController.h
//  ElongClient
//
//  Created by chenggong on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "eLongHotelUploadPhotosController.h"
#import "eLongAlbumTablePicker.h"
#import "eLongAssetsPickerType.h"

@protocol eLongAssetsPickerControllerDelegate;

@interface eLongAssetsPickerController : ElongBaseViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,eLongAlbumTablePickerDelegate>

/// The assets picker’s delegate object.
//@property (nonatomic, assign) id <eLongAssetsPickerControllerDelegate> delegate;

/// Set the ALAssetsFilter to filter the picker contents.
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

/// The maximum number of assets to be picked.
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

@property (nonatomic, strong) eLongHotelUploadPhotosController *invoker;
@property (nonatomic,strong) eLongHotelDetailModel *hotelDetailModel;

/**
 Determines whether or not the cancel button is visible in the picker
 @discussion The cancel button is visible by default. To hide the cancel button, (e.g. presenting the picker in UIPopoverController)
 set this property’s value to NO.
 */
@property (nonatomic, assign) BOOL showsCancelButton;

@property (nonatomic ,strong) NSArray *clickedImageAssets;

@property (nonatomic, assign) id<eLongAssetsPickerControllerDelegate> delegate;

- (id) initWithTitle:(NSString *)title pickerType:(eLongAssetsPickerType)pickerType;
-(void)setClickedImageAssets:(NSArray *)clickedImageAssets;

@end

@protocol eLongAssetsPickerControllerDelegate <NSObject>
@optional
- (void) eLongAssetsPickerController:(eLongAssetsPickerController *)picker didPickedImages:(NSArray *)images;
@end
