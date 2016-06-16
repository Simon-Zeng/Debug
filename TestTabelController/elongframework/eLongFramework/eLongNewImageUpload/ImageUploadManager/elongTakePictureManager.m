//
//  elongTakePictureManager.m
//  Pods
//
//  Created by 吕月 on 16/4/19.
//
//

#import "elongTakePictureManager.h"
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


@implementation elongTakePictureManager

static elongTakePictureManager *instanse = nil;


+ (elongTakePictureManager *)sharedInstance
{
    @synchronized(self) {
        
        if(!instanse) {
            
            instanse = [[elongTakePictureManager alloc] init];
        }
    }
    
    return instanse;
}



- (void) initWithBussnisAPIAddress:(NSString *) bussnisAPIAddress
                           SelectImage:(eLongTakePictureImageBlock) selectImageBlock
                        CancelCallback:(eLongTabkePictureUploadImageCancelBlock) cancelBlock{

    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        NSLog(@"kABAuthorizationStatusDenied");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"未开启相机使用权限"
                                                     message:@"请进入“设置-隐私-相机”打开艺龙的相机授权"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"知道了", nil];
        [av show];
        return;
    }
    if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                
                //创建图片选择器
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                //指定源类型前，检查图片源是否可用
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    //指定源的类型
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
                    //        imagePicker.allowsEditing = YES;
                    
                    //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
                    imagePicker.delegate = self;
                    self.imageBlock = selectImageBlock;
                    //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
                    //                    [self presentViewController:imagePicker animated:YES completion:nil];
                    [[eLongBus bus].navigationController presentViewController:imagePicker animated:YES completion:nil];
                    
                }
                else{
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                    [alert show];
                    
                    
                }
                
            }
            else {
                NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"未开启相机使用权限"
                                                             message:@"请进入“设置-隐私-相机”打开艺龙的相机授权"
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"知道了", nil];
                [av show];
                return;
                
            }
        }];
        
    }else{
        
        
        //创建图片选择器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //指定源类型前，检查图片源是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //指定源的类型
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
            //        imagePicker.allowsEditing = YES;
            
            //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
            imagePicker.delegate = self;
            self.imageBlock = selectImageBlock;
            //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
            [[eLongBus bus].navigationController presentViewController:imagePicker animated:YES completion:nil];
            
        }
        else{
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            
            
        }
        
    }


}


#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [[eLongLoadingView sharedLoadingView] showAlertMessageNoCancel];
    __block typeof(self)this = self;
    [[eLongAssetsLibraryController shareInstance] writeImageToSavedPhotosAlbum:[[info safeObjectForKey:UIImagePickerControllerOriginalImage] CGImage] orientation:(ALAssetOrientation)[[info safeObjectForKey:UIImagePickerControllerOriginalImage] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        [[eLongLoadingView sharedLoadingView] hideAlertMessage];
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
            //            [this uploadImages:[NSArray arrayWithObject:[eLongAssetModel modelWithAsset:asset type:eLongAssetTypePhoto]]];
            this.imageBlock([NSArray arrayWithObject:[eLongAssetModel modelWithAsset:asset type:eLongAssetTypePhoto]]);
            [this clearBlock];
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            /*  A failure here typically indicates that the user has not allowed this app access
             to location data. In that case the error code is ALAssetsLibraryAccessUserDeniedError.
             In principle you could alert the user to that effect, i.e. they have to allow this app
             access to location services in Settings > General > Location Services and turn on access
             for this application.
             */
            NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
            // This sample will abort since a shipping product MUST do something besides logging a
            // message. A real app needs to inform the user appropriately.
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"存取相册错误" message:[NSString stringWithFormat:@"请在 设置-隐私-照片中，打开%@的访问权限", APP_NAME] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        };
        
        // Get the asset for the asset URL to create a screen image.
        [[eLongAssetsLibraryController shareInstance] assetForURL:assetURL resultBlock:resultsBlock failureBlock:failureBlock];
    }];
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self clearBlock];
}

- (void) clearBlock{

    self.imageBlock = nil;
}

@end
