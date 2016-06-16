//
//  eLongPhotoUploadService.m
//  eLongFramework
//
//  Created by 吕月 on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongPhotoUploadService.h"

#import "eLongPhotoPicker.h"
#import "eLongAssetModel.h"
#import <Photos/Photos.h>
#import "eLongPhotoPickerController.h"
#import "eLongPhotoManager.h"
#import "eLongBus.h"
#import "eLongAssetsLibraryController.h"
#import "eLongDefine.h"


@implementation eLongPhotoUploadService

- (void)eLongPhotoUploadRetryModelDic:(NSDictionary *) retryAssetModel
                 MaxPhotoSelectNumber:(NSNumber *) maxSelectNumber
                    BussnisAPIAddress:(NSString *) bussnisAPIAddress
                    AlreadySelectedImageArray:(NSArray *) alreadySelectedImageArray
                     SelectImageArray:(eLongPhotoUploadImageModelArray) selectImageArrayBlock
                     ImageStatusArray:(eLongPhotoUploadProgressStatus) statusImageArrayBlock
                       CancelCallback:(eLongPhotoUploadImageCancel) cancelBlock{

    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   return;
                               }
                               
                               //以下代码进入相册选择页面
                               //1.初始化一个eLongPhotoPickerController
                               NSArray *aSelectImageArray;
                               if (!alreadySelectedImageArray || ![alreadySelectedImageArray isKindOfClass:[NSArray class]]) {
                               }else{
                                   aSelectImageArray = [NSArray arrayWithArray:alreadySelectedImageArray];
                               }
                               eLongPhotoPickerController *photoPickerC = [[eLongPhotoPickerController alloc]initWithMaxCount:[maxSelectNumber integerValue] selectImages:aSelectImageArray delegate:nil];
                               //3.取消注释下面代码,使用代理方式回调,代理方法参考eLongPhotoPickerControllerDelegate
                               //    photoPickerC.photoPickerDelegate = self;
                               
                               //3..设置选择完照片的block 回调
                               __weak typeof(*&photoPickerC) wSelf = photoPickerC;
                               [photoPickerC setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<eLongAssetModel *> *assets) {
                                   __weak typeof(*&photoPickerC) photoPickerC = wSelf;
                                   NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
                                   
                                   //若需要自定义大小的图片 使用下面方法
                                   //        [[eLongPhotoManager sharedManager] getThumbnailWithAsset:<# asset in assets #> size:<# your size #> completionBlock:^(UIImage * _Nullable image) {
                                   //
                                   //        }];
                                   selectImageArrayBlock(assets);
//                                   [self.navigationController popToViewController:self animated:YES];
                                   //eLongPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
//                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   
                                   [photoPickerC dismissViewControllerAnimated:YES completion: nil];
                                   
                               }];
                               
                               //        //4.设置选择完视频的block回调
                               //        [photoPickerC setDidFinishPickingVideoBlock:^(UIImage *coverImage, eLongAssetModel * asset) {
                               //            __weak typeof(*&self) self = wSelf;
                               //            NSLog(@"picker image :%@\n\n asset:%@\n\n",coverImage,asset);
                               //            [self uploadImages:coverImage];
                               //            [self.navigationController popToViewController:self animated:YES];
                               //            //eLongPhotoPickerController 确定选择,并不会自己dismiss掉,需要自己dismiss
                               //            [self dismissViewControllerAnimated:YES completion:nil];
                               //        }];
                               
                               [photoPickerC setDidCancelPickingBlock:^{
                                   NSLog(@"photoPickerC did Cancel");
                                   cancelBlock();
                               }];
                               //6. 显示photoPickerC
//                               [self presentViewController:photoPickerC animated:YES completion:nil];
                               [[eLongBus bus].navigationController presentViewController:photoPickerC animated:YES completion:nil];
                               
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               
                               if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取相册错误" message:[NSString stringWithFormat:@"请在 设置-隐私-照片中，打开%@的访问权限", APP_NAME] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                               }
                               else {
                                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"访问错误" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                               }
                               //               NSLog(@"A problem occured %@", [error description]);
                           };
                           
                           // Enumerate Albums
                           [[eLongAssetsLibraryController shareInstance] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                                                       usingBlock:assetGroupEnumerator
                                                                                     failureBlock:assetGroupEnumberatorFailure];
                           
                       }
                   });
};

@end
