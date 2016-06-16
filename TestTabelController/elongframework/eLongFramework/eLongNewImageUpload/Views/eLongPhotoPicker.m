//
//  eLongPhotoPicker.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/1.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongPhotoPicker.h"
#import "eLongAssetCell.h"

#import "eLongPhotoPickerController.h"
#import "eLongPhotoPreviewController.h"

#import "eLongPhotoManager.h"
#import "eLongPhotoPickerDefines.h"

#import "UIView+Animations.h"
#import "UIViewController+eLongPhotoHUD.h"

#import "eLongDefine.h"

@interface eLongPhotoPicker   () <UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonHConstarint;
@property (weak, nonatomic) IBOutlet UIView *cameraLineView;
@property (weak, nonatomic) IBOutlet UIButton *photoLibraryButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) eLongAlbumModel *displayAlbum;
@property (nonatomic, copy) NSArray <eLongAssetModel *>* assets;
@property (nonatomic, strong) NSMutableArray <eLongAssetModel *> *selectedAssets;

@property (nonatomic, assign, readonly) CGFloat contentViewHeight;

@end

@implementation eLongPhotoPicker

+ (instancetype)sharePhotoPicker {
    static id photoPicker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoPicker = [[[self class] alloc] initWithMaxCount:9];
    });
    return photoPicker;
}

- (instancetype)initWithMaxCount:(NSUInteger)maxCount {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"eLongPhotoPicker" owner:nil options:nil];
    if ((self = (eLongPhotoPicker *)[array firstObject])) {
        self.frame = [UIScreen mainScreen].bounds;
        [self _setup];
        self.maxCount = maxCount ? : self.maxCount;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"eLongPhotoPicker dealloc");
}

#pragma mark - Methods

- (void)showAnimated:(BOOL)animated {
    [self.parentController.view addSubview:self];
    if (animated) {
        CGPoint fromPoint = CGPointMake(self.frame.size.width/2, self.contentViewHeight/2 + self.frame.size.height);
        CGPoint toPoint   = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.contentViewHeight/2);
        CABasicAnimation *positionAnim = [UIView animationWithFromValue:[NSValue valueWithCGPoint:fromPoint] toValue:[NSValue valueWithCGPoint:toPoint] duration:.2f forKeypath:@"position"];
        [self.contentView.layer addAnimation:positionAnim forKey:nil];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        CGPoint fromPoint   = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.contentViewHeight/2);
        CGPoint toPoint = CGPointMake(self.frame.size.width/2, self.contentViewHeight/2 + self.frame.size.height);
        CABasicAnimation *positionAnim = [UIView animationWithFromValue:[NSValue valueWithCGPoint:fromPoint] toValue:[NSValue valueWithCGPoint:toPoint] duration:.2f forKeypath:@"position"];
        positionAnim.delegate = self;
        [self.contentView.layer addAnimation:positionAnim forKey:nil];
    }else {
        [self removeFromSuperview];
    }
}

- (void)showPhotoPickerwithController:(UIViewController *)controller animated:(BOOL)animated {
    [self.selectedAssets removeAllObjects];
    [self.assets makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    [self _updatePhotoLibraryButton];
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
    self.hidden = NO;
    self.parentController = controller;
    self.assets ? nil : [self _loadAssets];
    [self showAnimated:animated];
}

- (void)_setup {
    
    self.maxPreviewCount = 20;
    self.maxCount = MIN(self.maxPreviewCount, NSUIntegerMax);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.contentViewHeight);
    cancelButton.tag = keLongCancel;
    [cancelButton addTarget:self action:@selector(_handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    IOSVersion_8 ? [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self] : nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.cameraButtonHConstarint.constant = 40;
        self.cameraButton.hidden = NO;
        self.cameraLineView.hidden = NO;
    }else {
        self.cameraButton.hidden = YES;
        self.cameraLineView.hidden = YES;
        self.cameraButtonHConstarint.constant = 0;
    }
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = keLongMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);

    [self.collectionView registerNib:[UINib nibWithNibName:@"eLongAssetCell" bundle:nil] forCellWithReuseIdentifier:@"eLongAssetCell"];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.selectedAssets = [NSMutableArray array];
    
    self.assets ? nil : [self _loadAssets];
}

- (void)_loadAssets {
    
    __weak typeof(*&self) wSelf = self;
    self.loadingView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[eLongPhotoManager sharedManager] getAlbumsPickingVideoEnable:YES completionBlock:^(NSArray<eLongAlbumModel *> *albums) {
            if (albums && [albums firstObject]) {
                self.displayAlbum = [albums firstObject];
                [[eLongPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:YES completionBlock:^(NSArray<eLongAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __weak typeof(*&self) self = wSelf;
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > self.maxPreviewCount);
                    }];
                    self.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        self.loadingView.hidden = YES;
                        [self.collectionView reloadData];
                    });
                }];
            }
        }];
    });
    
}

- (IBAction)_handleButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case keLongCancel:
            [self hideAnimated:YES];
            break;
        case keLongConfirm:
        {
            if (self.selectedAssets.count == 1 && [self.selectedAssets firstObject].type == eLongAssetTypeVideo) {
                self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock([self.selectedAssets firstObject].previewImage,[self.selectedAssets firstObject]) : nil;
            }else {
                NSMutableArray *images = [NSMutableArray array];
                [self.selectedAssets enumerateObjectsUsingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [images addObject:obj.previewImage];
                }];
                self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,self.selectedAssets) : nil;
            }
            [self hideAnimated:YES];
        }
            
            break;
        case keLongCamera:
        {
            [self _showImageCameraController];
        }
            break;
        case keLongPhotoLibrary:
        {
            [self _showPhotoPickerController];
        }
            break;
        default:
            break;
    }
}

- (void)_updatePhotoLibraryButton {
    if (self.selectedAssets.count == 0) {
        self.photoLibraryButton.tag = keLongPhotoLibrary;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"相册"] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }else {
        self.photoLibraryButton.tag = keLongConfirm;
        [self.photoLibraryButton setTitle:[NSString stringWithFormat:@"确定(%d)",(int)self.selectedAssets.count] forState:UIControlStateNormal];
        [self.photoLibraryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)_showPhotoPickerController {
    //暂时不用所以以后修改带入选择

    eLongPhotoPickerController *photoPickerController = [[eLongPhotoPickerController alloc]initWithMaxCount:self.maxCount selectImages:nil delegate:nil];
    __weak typeof(*&self) wSelf = self;
    [photoPickerController setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<eLongAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingPhotosBlock ?self.didFinishPickingPhotosBlock(images,assets) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
        [self hideAnimated:YES];
    }];
    [photoPickerController setDidFinishPickingVideoBlock:^(UIImage *coverImage, id asset) {
        __weak typeof(*&self) self = wSelf;
        self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
        [self hideAnimated:YES];
    }];
    [self.parentController presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)_showImageCameraController {
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = NO;
    imagePickerC.videoQuality = UIImagePickerControllerQualityTypeLow;
    imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.parentController presentViewController:imagePickerC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"eLongAssetCell" forIndexPath:indexPath];
    assetCell.backgroundColor = [UIColor lightGrayColor];
    [assetCell configPreviewCellWithItem:self.assets[indexPath.row]];
    
    __weak typeof(*&self) wSelf = self;
    // 设置assetCell willChangeBlock
    [assetCell setWillChangeSelectedStateBlock:^BOOL(eLongAssetModel *asset) {
        if (!asset.selected) {
            __weak typeof(*&self) self = wSelf;
            if (asset.type == eLongAssetTypeVideo) {
                if ([self.selectedAssets firstObject] && [self.selectedAssets firstObject].type != eLongAssetTypeVideo) {
                    [self.parentController showAlertWithMessage:@"不能同时选择照片和视频"];
                }else if ([self.selectedAssets firstObject]){
                    [self.parentController showAlertWithMessage:@"一次只能发送1个视频"];
                }else {
                    return YES;
                }
                return NO;
            }else if (self.selectedAssets.count > self.maxCount){
                [self.parentController showAlertWithMessage:[NSString stringWithFormat:@"一次最多只能选择%d张图片",(int)self.maxCount]];
                return NO;
            }
            return YES;
        }else {
            return NO;
        }
    }];
    
    // 设置assetCell didChangeBlock
    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, eLongAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (selected) {
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
            asset.selected = YES;
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
            asset.selected = NO;
        }
        [self _updatePhotoLibraryButton];
    }];
    
    [assetCell setDidSendAsset:^(eLongAssetModel *asset, CGRect frame) {
        if (asset.type == eLongAssetTypePhoto) {
            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[asset.previewImage],@[asset]) : nil;
        }else {
            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
        }
    }];
    
    return assetCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    eLongAssetModel *asset = self.assets[indexPath.row];
    CGSize size = asset.previewImage.size;
    CGFloat scale = (size.width - 10)/size.height;
    return CGSizeMake(scale * (self.collectionView.frame.size.height),self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongAssetModel *assetModel = self.assets[indexPath.row];
    if (assetModel.type == eLongAssetTypeVideo) {
        //如果是音频不作处理
//        eLongVideoPreviewController *videoPreviewC = [[eLongVideoPreviewController alloc] init];
//        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
//        videoPreviewC.asset = assetModel;
//        __weak typeof(*&self) wSelf = self;
//        [videoPreviewC setDidFinishPickingVideo:^(UIImage *coverImage, eLongAssetModel *asset) {
//            __weak typeof(*&self) self = wSelf;
//            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
//            [self hideAnimated:NO];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [self.parentController presentViewController:videoPreviewC animated:YES completion:nil];
    }else {
        eLongPhotoPreviewController *previewC = [[eLongPhotoPreviewController alloc] initWithCollectionViewLayout:[eLongPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
        previewC.assets = self.assets;
        previewC.maxCount = self.maxCount;
        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
        previewC.currentIndex = indexPath.row;
        __weak typeof(*&self) wSelf = self;
        [previewC setDidFinishPreviewBlock:^(NSArray<eLongAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
            [self _updatePhotoLibraryButton];
            [self.collectionView reloadData];
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [previewC setDidFinishPickingBlock:^(NSArray<UIImage *> *images, NSArray<eLongAssetModel *> *assets) {
            __weak typeof(*&self) self = wSelf;
            [self.selectedAssets removeAllObjects];
            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
            [self hideAnimated:NO];
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self.parentController presentViewController:previewC animated:YES completion:nil];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.hidden = YES;
    [self removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    [self hideAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[image], nil) : nil;
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
    [self hideAnimated:YES];
    
}

#pragma mark - PHPhotoLibraryChangeObserver


- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    __weak typeof(*&self) wSelf = self;
    // Photos may call this method on a background queue;
    // switch to the main queue to update the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Check for changes to the list of assets (insertions, deletions, moves, or updates).
        PHFetchResultChangeDetails *collectionChanges = [changeInfo changeDetailsForFetchResult:self.displayAlbum.fetchResult];
        if (collectionChanges) {
            // Get the new fetch result for future change tracking.
            eLongAlbumModel *changeAlbumModel = [eLongAlbumModel albumWithResult:collectionChanges.fetchResultAfterChanges name:@"afterChange"];
            self.displayAlbum = changeAlbumModel;
            if (collectionChanges.hasIncrementalChanges)  {
                [[eLongPhotoManager sharedManager] getAssetsFromResult:self.displayAlbum.fetchResult pickingVideoEnable:YES completionBlock:^(NSArray<eLongAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __weak typeof(*&self) self = wSelf;
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > self.maxPreviewCount);
                    }];
                    self.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        [self.collectionView reloadData];
                    });
                }];
            } else {
                // Detailed change information is not available;
                // repopulate the UI from the current fetch result.
                [self.collectionView reloadData];
            }
        }
    });
}

- (NSArray <NSIndexPath *> *)_indexPathsFromIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:self.displayAlbum.count - idx inSection:0]];
    }];
    return indexPaths;
}
#pragma mark - Getters

- (CGFloat)contentViewHeight {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return 41 * 3 + 160 + 8;
    }else {
        return 41 * 2  + 160 + 8;
    }
}

@end
