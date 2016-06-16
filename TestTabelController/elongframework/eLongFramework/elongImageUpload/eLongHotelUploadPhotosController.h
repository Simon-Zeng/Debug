//
//  eLongHotelUploadPhotosController.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "eLongHttpUploadImage.h"
#import "eLongHotelUploadImageCell.h"
#import "eLongButtonView.h"
#import "eLongHotelDetailModel.h"


@interface eLongHotelUploadPhotosController : ElongBaseViewController<UITableViewDelegate, UITableViewDataSource, eLongHttpUploadImageDelegate, eLongHotelUploadImageCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,ButtonViewDelegate>

@property (nonatomic, assign) BOOL withRoomId;
@property (nonatomic,strong) eLongHotelDetailModel *hotelDetailModel;

- (id)initWithAssets:(NSArray *)assetsArray WithTitleString:(NSString *)titleString;
- (id) initWithAssets:(NSArray *)assetsArray WithTitleString:(NSString *)titleString hotelDetailModel:(eLongHotelDetailModel *)hotelDetailModel;
- (NSString *)addWithAssets:(NSArray *)assetsArray;

@end
