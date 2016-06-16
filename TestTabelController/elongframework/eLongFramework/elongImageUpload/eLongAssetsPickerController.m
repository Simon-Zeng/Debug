//
//  eLongAssetsPickerController.m
//  ElongClient
//
//  Created by chenggong on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongAssetsPickerController.h"
#import "eLongAlbumTablePicker.h"
#import "eLongAssetsLibraryController.h"
#import "eLongDefine.h"
#import "UIImageView+Extension.h"

#define kTableViewTag 1024

#pragma mark - Interfaces

@interface eLongAssetsPickerController ()

@property (nonatomic, strong) NSMutableArray *assetGroups;
@property (nonatomic, strong) UITableView *albumPickerTableView;
@property (nonatomic, assign) eLongAssetsPickerType pickerType;
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, strong) ALAssetsLibrary *library;

@end

#pragma mark - eLongAssetsPickerController

@implementation eLongAssetsPickerController

- (void)dealloc{
    self.assetGroups = nil;
    _albumPickerTableView.dataSource = nil;
    _albumPickerTableView.delegate = nil;
    self.albumPickerTableView = nil;
//    self.library = nil;
    self.invoker = nil;
    self.title = nil;
    self.hotelDetailModel = nil;
    
}

- (id)init{
    if (self = [super initWithTitle:@"上传图片" style:NavBarBtnStyleOnlyBackBtn]) {
        self.title = @"上传图片";
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.assetGroups = tempArray;
        self.pickerType = RoomPhotoPicker;
        
//        UIBarButtonItem *takePhotoItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"     拍照"
//                                                                            Target:self
//                                                                            Action:@selector(takePhoto:)];
//        self.navigationItem.rightBarButtonItem = takePhotoItem;
    }
    return self;
}

- (id) initWithTitle:(NSString *)title pickerType:(eLongAssetsPickerType)pickerType{
    if (self = [super initWithTitle:title style:NavBarBtnStyleOnlyBackBtn]) {
        self.title = title;
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.assetGroups = tempArray;
        
        self.pickerType = pickerType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 访问相册
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    self.library = assetLibrary;
//    [assetLibrary release];
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
       @autoreleasepool {
           // Group enumerator Block
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
           {
               if (group == nil) {
                   return;
               }
               
               // added fix for camera albums order
               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
               
               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                   [self.assetGroups insertObject:group atIndex:0];
               }
               else {
                   [self.assetGroups addObject:group];
               }
               
               // Load albums
               [self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)setClickedImageAssets:(NSArray *)clickedImageAssets{
    if (_clickedImageAssets != clickedImageAssets) {
        _clickedImageAssets = clickedImageAssets;
    }
}
- (void)createTableView
{
	UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    tempTableView.tag = kTableViewTag;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    [tempTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tempTableView];
}

- (void)reloadSelfTableView
{
    UITableView *selfTableView = (UITableView *)[self.view viewWithTag:kTableViewTag];
    [selfTableView reloadData];
}

#pragma mark - Private method.
- (void)takePhoto:(id)sender
{
    //创建图片选择器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    //指定源类型前，检查图片源是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //指定源的类型
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
//        imagePicker.allowsEditing = YES;
        
        //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
        imagePicker.delegate = self;
        
        //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 重新载入相册
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   return;
                               }
                               
                               // added fix for camera albums order
                               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                               
                               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                                   [self.assetGroups insertObject:group atIndex:0];
                               }
                               else {
                                   [self.assetGroups addObject:group];
                               }
                               
                               // Load albums
                               [self performSelectorOnMainThread:@selector(reloadSelfTableView) withObject:nil waitUntilDone:YES];
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               
                               NSLog(@"A problem occured %@", [error description]);	                                 
                           };	
                           
                           // Enumerate Albums
                           [[eLongAssetsLibraryController shareInstance] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                   usingBlock:assetGroupEnumerator 
                                                 failureBlock:assetGroupEnumberatorFailure];
                           
                       }
                   });
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage],
                                   self,
                                   @selector(imageSavedToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:),
                                   nil);
//    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __block CIImage *image = nil;
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        // sourceType为UIImagePickerControllerSourceTypeCamera的时候
//        // 会有UIImagePickerControllerMediaMetadata
//        image = [CIImage imageWithCGImage:gotImage.CGImage
//                                  options:@{kCIImageProperties : [info  objectForKey:UIImagePickerControllerMediaMetadata]}];
//    } else {
//        // 依赖AssetsLibrary框架
//        void (^resultBlock) (ALAsset*) = ^(ALAsset *asset) {
//            image = [CIImage imageWithCGImage:gotImage.CGImage
//                                      options:@{kCIImageProperties : asset.defaultRepresentation.metadata}];
//        };
//        ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
//        [lib assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
//             resultBlock:resultBlock failureBlock:nil];
//    }
//    NSLog(@"%@", image.properties);
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 57.0f - 0.51f, SCREEN_WIDTH, 0.51f)]];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_assetGroups && [_assetGroups count] > 0) {
        eLongAlbumTablePicker *picker = nil;
        if (self.pickerType == RoomPhotoPicker) {
            picker =  [[eLongAlbumTablePicker alloc] initWithAssetGroup:[self.assetGroups objectAtIndex:indexPath.row]];
            picker.clickedImageAssets = self.clickedImageAssets;

            picker.hotelDetailModel = self.hotelDetailModel;
            
            if (_maximumNumberOfSelection > 0) {
                picker.maxUploadImageNumber = _maximumNumberOfSelection;
            }
            
            picker.delegate = nil;
            //	picker.delegate = self;
            if (_invoker != nil) {
                picker.uploader = _invoker;
            }
        }else{
            picker =  [[eLongAlbumTablePicker alloc] initWithAssetGroup:[self.assetGroups objectAtIndex:indexPath.row] title:self.title pickerType:self.pickerType];
            picker.clickedImageAssets = self.clickedImageAssets;

            picker.hotelDetailModel = self.hotelDetailModel;
            if (_maximumNumberOfSelection > 0) {
                picker.maxUploadImageNumber = _maximumNumberOfSelection;
            }
            
            picker.delegate = self;
        }
        
//        picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//        [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        //	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
        if (picker.assetGroup.numberOfAssets > 0) {
            [self.navigationController pushViewController:picker animated:YES];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 57;
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super back];
}

#pragma mark -
#pragma mark eLongAlbumTablePickerDelegate
- (void) elongAlbumTablePicker:(eLongAlbumTablePicker *)picker didPickedImages:(NSArray *)images{
    if ([self.delegate respondsToSelector:@selector(eLongAssetsPickerController:didPickedImages:)]) {
        [self.delegate eLongAssetsPickerController:self didPickedImages:images];
    }
}
@end
