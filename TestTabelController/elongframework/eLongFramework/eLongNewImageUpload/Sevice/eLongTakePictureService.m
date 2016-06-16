//
//  eLongTakePictureService.m
//  eLongFramework
//
//  Created by 吕月 on 16/4/19.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongTakePictureService.h"
#import "eLongPhotoPicker.h"
#import "eLongAssetModel.h"
#import <Photos/Photos.h>
#import "eLongPhotoPickerController.h"
#import "eLongPhotoManager.h"
#import "eLongBus.h"
#import "eLongAssetsLibraryController.h"
#import "eLongDefine.h"
#import "eLongExtension.h"
#import "eLongLoadingView.h"
#import "elongTakePictureManager.h"


@implementation eLongTakePictureService


- (void)eLongTakePictureWithBussnisAPIAddress:(NSString *) bussnisAPIAddress
                                  SelectImage:(eLongTakePictureImageBlock) selectImageBlock
                               CancelCallback:(eLongTabkePictureUploadImageCancelBlock) cancelBlock{
    [[elongTakePictureManager sharedInstance]initWithBussnisAPIAddress:bussnisAPIAddress SelectImage:^(NSArray *assetModelArray) {
        selectImageBlock(assetModelArray);
    } CancelCallback:^{
        cancelBlock();
    }];
    
}


- (void) dealloc{
    
}

@end
