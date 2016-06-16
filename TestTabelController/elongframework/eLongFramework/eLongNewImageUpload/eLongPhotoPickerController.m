//
//  eLongPhotoPickerController.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongPhotoPickerController.h"
#import "eLongPhotoCollectionController.h"

#import "eLongPhotoManager.h"

#import "eLongAlbumCell.h"

#import "eLongDefine.h"

#import "ElongBaseViewController.h"

#import "eLongExtension.h"

@implementation eLongPhotoPickerController{
    UILabel *textLB;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#pragma mark - eLongPhotoPickerController Life Cycle

- (instancetype _Nonnull )initWithMaxCount:(NSUInteger)maxCount selectImages:(NSArray<eLongAssetModel *> * _Nullable)selectImagesAsset delegate:(_Nullable id<eLongPhotoPickerControllerDelegate>)delegate{
    _clickedImageAssets = selectImagesAsset;
    eLongAlbumListController *albumListC = [[eLongAlbumListController alloc] init];
    albumListC.clickedImageAssets = selectImagesAsset;
    if (self = [super initWithRootViewController:albumListC]) {
        _photoPickerDelegate = delegate;
        _maxCount = maxCount ? : NSUIntegerMax;
        _autoPushToPhotoCollection = YES;
        _pickingVideoEnable = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupNavigationBarAppearance];
    [self _setupUnAuthorizedTips];
}

/**
 *  重写viewWillAppear方法
 *  判断是否需要自动push到第一个相册专辑内
 *  @param animated 是否需要动画
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.autoPushToPhotoCollection) {
        eLongPhotoCollectionController *photoCollectionC = [[eLongPhotoCollectionController alloc] initWithCollectionViewLayout:[eLongPhotoCollectionController photoCollectionViewLayoutWithWidth:self.view.frame.size.width]];
        photoCollectionC.clickedImageAssets = self.clickedImageAssets;
        __weak typeof(*&self) wSelf = self;
        [[eLongPhotoManager sharedManager] getAlbumsPickingVideoEnable:self.pickingVideoEnable completionBlock:^(NSArray<eLongAlbumModel *> *albums) {
            __weak typeof(*&self) self = wSelf;
            photoCollectionC.album = [albums firstObject];
            [self.navigationController pushViewController:photoCollectionC animated:NO];
        }];
    }
}

- (void)dealloc {
    NSLog(@"photo picker dealloc");
}

#pragma mark - eLongPhotoPickerController Methods

/**
 *  call photoPickerDelegate & didFinishPickingPhotosBlock
 *
 *  @param assets 具体回传的资源
 */
- (void)didFinishPickingPhoto:(NSArray<eLongAssetModel *> *)assets {
    NSMutableArray *images = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [images safeAddObject:obj.previewImage];
    }];
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerController:didFinishPickingPhotos:sourceAssets:)]) {
        [self.photoPickerDelegate photoPickerController:self didFinishPickingPhotos:images sourceAssets:assets];
    }
    self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
}

- (void)didFinishPickingVideo:(eLongAssetModel *)asset {
    
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerController:didFinishPickingVideo:sourceAssets:)]) {
        [self.photoPickerDelegate photoPickerController:self didFinishPickingVideo:asset.previewImage sourceAssets:asset];
    }
    
    self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
}

- (void)didCancelPickingPhoto {
    if (self.photoPickerDelegate && [self.photoPickerDelegate respondsToSelector:@selector(photoPickerControllerDidCancel:)]) {
        [self.photoPickerDelegate photoPickerControllerDidCancel:self];
    }
    self.didCancelPickingBlock ? self.didCancelPickingBlock() : nil;
}

/**
 *  设置当用户未授权访问照片时提示
 */
- (void)_setupUnAuthorizedTips {
    if (![[eLongPhotoManager sharedManager] hasAuthorized]) {
        if (![[eLongPhotoManager sharedManager] hasAuthorized]) {
            if (!textLB) {
                UILabel *tipsLabel = [[UILabel alloc] init];
                tipsLabel.frame = CGRectMake(8, 64, self.view.frame.size.width - 16, 300);
                tipsLabel.textAlignment = NSTextAlignmentCenter;
                tipsLabel.numberOfLines = 0;
                tipsLabel.font = [UIFont systemFontOfSize:16];
                tipsLabel.textColor = [UIColor blackColor];
                tipsLabel.userInteractionEnabled = YES;
                NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
                if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
                tipsLabel.text = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，\r允许%@访问你的手机相册。",[UIDevice currentDevice].model,appName];
                textLB = tipsLabel;
                [self.view addSubview:textLB];
            }else{
                [textLB setHidden:NO];
            }
            //
            ////        //!!! bug 用户前往设置后,修改授权会导致app崩溃
            ////        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTipsTap)];
            ////        [tipsLabel addGestureRecognizer:tap];
        }else{
            if (textLB) {
                [textLB setHidden:YES];
            }
        
        }
    
    }
}

/**
 *  处理当用户未授权访问相册时 tipsLabel的点击手势,暂时有bug
 */
- (void)_handleTipsTap {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

/**
 *  设置navigationBar的样式
 */
- (void)_setupNavigationBarAppearance {
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
//    if (!IOSVersion_8) {
        self.navigationBar.barTintColor = keLongBarBackgroundColor;
        self.navigationBar.tintColor = COLOR_NAV_BTN_TITLE;
        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    UINavigationBar *navigationBar;
    UIBarButtonItem *barItem;
    if (IOSVersion_9) {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[eLongPhotoPickerController class]]];
        navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[eLongPhotoPickerController class]]];
    } else {
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[eLongPhotoPickerController class], nil];
        navigationBar = [UINavigationBar appearanceWhenContainedIn:[eLongPhotoPickerController class], nil];
    }
    [barItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f],NSForegroundColorAttributeName:COLOR_NAV_BTN_TITLE} forState:UIControlStateNormal];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]}];
    [navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}


@end

@implementation eLongAlbumListController

#pragma mark - eLongAlbumListController Life Cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 19)];
    label.backgroundColor	= [UIColor clearColor];
    label.font				= FONT_B18;
    label.textColor			= COLOR_NAV_TITLE;
    label.text				= @"照片";
    label.textAlignment		= NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"取消" Target:self Action:@selector(_handleCancelAction)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = 70.0f;
    [self.tableView registerNib:[UINib nibWithNibName:@"eLongAlbumCell" bundle:nil ] forCellReuseIdentifier:@"eLongAlbumCell"];
    
    eLongPhotoPickerController *imagePickerVC = (eLongPhotoPickerController *)self.navigationController;
    __weak typeof(*&self) wSelf = self;
    [[eLongPhotoManager sharedManager] getAlbumsPickingVideoEnable:imagePickerVC.pickingVideoEnable completionBlock:^(NSArray<eLongAlbumModel *> *albums) {
        __weak typeof(*&self) self = wSelf;
        self.albums = [NSArray arrayWithArray:albums];
        [self.tableView reloadData];
    }];
    
}

#pragma mark - eLongAlbumListController Methods

- (void)_handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    eLongPhotoPickerController *photoPickerVC = (eLongPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
    
}


#pragma mark - eLongAlbumListController UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    eLongAlbumCell *albumCell = [tableView dequeueReusableCellWithIdentifier:@"eLongAlbumCell"];
    [albumCell configCellWithItem:self.albums[indexPath.row]];
    return albumCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    eLongPhotoCollectionController *photoCollectionC = [[eLongPhotoCollectionController alloc] initWithCollectionViewLayout:[eLongPhotoCollectionController photoCollectionViewLayoutWithWidth:self.view.frame.size.width]];
    photoCollectionC.clickedImageAssets = self.clickedImageAssets;
    photoCollectionC.album = self.albums[indexPath.row];
    [self.navigationController pushViewController:photoCollectionC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


#pragma clang diagnostic pop

