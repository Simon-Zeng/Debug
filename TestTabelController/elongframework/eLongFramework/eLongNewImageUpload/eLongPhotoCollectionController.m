//
//  eLongPhotoCollectionController.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongPhotoCollectionController.h"
#import "eLongPhotoPickerController.h"
#import "eLongPhotoPreviewController.h"

#import "eLongAssetModel.h"
#import "eLongPhotoManager.h"

#import "eLongAssetCell.h"
#import "eLongBottomBar.h"

#import "UIViewController+eLongPhotoHUD.h"

#import "ElongBaseViewController.h"

#import "eLongExtension.h"
#import "eLongAlertView.h"

@interface eLongPhotoCollectionController ()

/** 底部状态栏 */
@property (nonatomic, weak)   eLongBottomBar *bottomBar;

/** 相册内所有的资源 */
@property (nonatomic, copy)   NSArray<eLongAssetModel *> *assets;
/** 选择的所有资源 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;

/** 第一次进入时,自动滚动到底部 */
@property (nonatomic, assign) BOOL autoScrollToBottom;

@end

@implementation eLongPhotoCollectionController

static NSString * const keLongAssetCellIdentifier = @"eLongAssetCell";

-(void)setClickedImageAssets:(NSArray *)clickedImageAssets{
    if (_clickedImageAssets != clickedImageAssets) {
        _clickedImageAssets = clickedImageAssets;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 19)];
    label.backgroundColor	= [UIColor clearColor];
    label.font				= FONT_B18;
    label.textColor			= COLOR_NAV_TITLE;
    label.text				= self.album.name;
    label.textAlignment		= NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"取消" Target:self Action:@selector(_handleCancelAction)];
    
    // leftItem
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT)];
    [leftButton setExclusiveTouch:YES];
    [leftButton setImage:[UIImage imageNamed:@"basevc_navback_normal"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    
    
    self.autoScrollToBottom = NO;
    self.selectedAssets = [NSMutableArray array];
    
    // 初始化collectionView的一些属性
    [self _setupCollectionView];
    
    //从相册中获取所有的资源model
    __weak typeof(*&self) wSelf = self;
    [[eLongPhotoManager sharedManager] getAssetsFromResult:self.album.fetchResult pickingVideoEnable:[(eLongPhotoPickerController *)self.navigationController pickingVideoEnable] completionBlock:^(NSArray<eLongAssetModel *> *assets) {
        __weak typeof(*&self) self = wSelf;
        self.assets = [NSArray arrayWithArray:assets];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __weak typeof(*&self) self = wSelf;
            [self.assets enumerateObjectsUsingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self selectImageAsset:self.clickedImageAssets haveSameObject:obj]) {
                    obj.selected = YES;
                    [self.selectedAssets safeAddObject:obj];
                }
                [obj thumbnail];
            }];
            
            NSInteger diffCount = self.clickedImageAssets.safeCount - self.selectedAssets.safeCount;
            NSMutableArray *diffArray = [[NSMutableArray alloc]initWithCapacity:10];
            if (diffCount > 0) {
                for (int i = 0; i < self.clickedImageAssets.safeCount; i++) {
                    eLongAssetModel *aModel = [self.clickedImageAssets safeObjectAtIndex:i];
                    if (![self haveSameItemInSelectAssetArrayWithAseetModel:aModel]) {
                        [diffArray safeAddObject:aModel];
                    }
                }
            }
            if (ARRAYHASVALUE(diffArray)) {
                [self.selectedAssets addObjectsFromArray:diffArray];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
            });
        });
        
        [self.collectionView reloadData];
    }];
    
}

- (BOOL) haveSameItemInSelectAssetArrayWithAseetModel:(eLongAssetModel *)model {
    for (eLongAssetModel *aModel in self.selectedAssets) {
        if ([aModel compareModelModel:model]) {
            return YES;
        }
    }
    return NO;
}


- (BOOL) selectImageAsset:(NSArray <eLongAssetModel *>*)imageAssetArray haveSameObject:(eLongAssetModel *)assetModel{
    for (eLongAssetModel *oneAssetModel in imageAssetArray) {
        if ([oneAssetModel.imageUrl isEqualToString:assetModel.imageUrl]) {
            return YES;
        }else{
            continue;
        }
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.autoScrollToBottom ?  [self.collectionView setContentOffset:CGPointMake(0, (self.assets.count / 4) * keLongThumbnailWidth)] : nil;
    self.autoScrollToBottom = NO;
    self.bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"photo collection dealloc ");
}

#pragma mark - Methods

- (void)_setupCollectionView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceHorizontal = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 54, 4);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, ((self.assets.count + 3) / 4) * self.view.frame.size.width);
    [self.collectionView registerNib:[UINib nibWithNibName:keLongAssetCellIdentifier bundle:nil] forCellWithReuseIdentifier:keLongAssetCellIdentifier];
    
    eLongPhotoPickerController *photoPickerC = (eLongPhotoPickerController *)self.navigationController;
    if (photoPickerC.maxCount > 1) {
        eLongBottomBar *bottomBar = [[eLongBottomBar alloc] initWithBarType:eLongCollectionBottomBar];
        if (!IOSVersion_8) {
            bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50 + 20, self.view.frame.size.width, 50);
        }else{
            bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
        }
        __weak typeof(*&self) wSelf = self;
        [bottomBar setConfirmBlock:^{
            __weak typeof(*&self) self = wSelf;
            [(eLongPhotoPickerController *)self.navigationController didFinishPickingPhoto:self.selectedAssets];
        }];
        [self.view addSubview:self.bottomBar = bottomBar];
    }
    
}

- (void)_handleCancelAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    eLongPhotoPickerController *photoPickerVC = (eLongPhotoPickerController *)self.navigationController;
    [photoPickerVC didCancelPickingPhoto];
}

- (void) back{
    @try {
        [self.view endEditing:YES];
    }
    @catch (NSException *ex){
        NSLog(@"%@", ex.reason);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongAssetCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:keLongAssetCellIdentifier forIndexPath:indexPath];
    [assetCell configCellWithItem:self.assets[indexPath.row]];
    eLongPhotoPickerController *photoPickerC = (eLongPhotoPickerController *)self.navigationController;
    if (photoPickerC.maxCount < 2) {
        [assetCell setCanSelect:NO];
    }
    __weak typeof(*&self) wSelf = self;
    
    // 设置assetCell willChangeBlock
    [assetCell setWillChangeSelectedStateBlock:^BOOL(eLongAssetModel *asset) {
        __weak typeof(*&self) self = wSelf;
        if (!asset.selected) {
            if (asset.asset && [asset.asset isKindOfClass:[PHAsset class]]) {
                if(![asset isPhotoLocal]){
                    [eLongAlertView showAlertQuiet:@"该照片尚未从iCloud下载，请在系统相册中下载到本地后重新尝试"];
                    return NO;
                }
            }
            eLongPhotoPickerController *photoPickerC = (eLongPhotoPickerController *)self.navigationController;
            if (asset.type == eLongAssetTypeVideo && self.selectedAssets.count > 0) {
                NSLog(@"同时选择视频和图片,视频将作为图片发送");
                [self showAlertWithMessage:@"同时选择视频和图片,视频将作为图片发送"];
                return YES;
            }else if (self.selectedAssets.count >= photoPickerC.maxCount) {
                [eLongAlertView showAlertTitle:@"提示" Message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)photoPickerC.maxCount]];
                
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
            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets safeAddObject:asset];
            asset.selected = YES;
        }else {
            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
            asset.selected = NO;
        }
        [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
    }];
    
    return assetCell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongAssetModel *assetModel = self.assets[indexPath.row];
    if (assetModel.type == eLongAssetTypeVideo) {
        //音频不要
        //        eLongVideoPreviewController *videoPreviewC = [[eLongVideoPreviewController alloc] init];
        //        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
        //        videoPreviewC.asset = assetModel;
        //        __weak typeof(*&self) wSelf = self;
        //        [videoPreviewC setDidFinishPickingVideo:^(UIImage *coverImage, eLongAssetModel *asset) {
        //            __weak typeof(*&self) self = wSelf;
        //            [(eLongPhotoPickerController *)self.navigationController didFinishPickingVideo:asset];
        //        }];
        //        [self.navigationController pushViewController:videoPreviewC animated:YES];
    }else {
        
        eLongAssetModel *currectAsset = [self.assets safeObjectAtIndex:indexPath.row];
        if (currectAsset && currectAsset.previewImage == nil) {
            [eLongAlertView showAlertQuiet:@"该照片尚未从iCloud下载，请在系统相册中下载到本地后重新尝试"];
            return;
        }
        eLongPhotoPreviewController *previewC = [[eLongPhotoPreviewController alloc] initWithCollectionViewLayout:[eLongPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
        previewC.assets = self.assets;
        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
        previewC.currentIndex = indexPath.row;
        previewC.maxCount = [(eLongPhotoPickerController *)self.navigationController maxCount];
        __weak typeof(*&self) wSelf = self;
        [previewC setDidFinishPreviewBlock:^(NSArray<eLongAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
            [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
            [self.collectionView reloadData];
        }];
        
        [previewC setDidFinishPickingBlock:^(NSArray<UIImage *> *images, NSArray<eLongAssetModel *> *selectedAssets) {
            __weak typeof(*&self) self = wSelf;
            [(eLongPhotoPickerController *)self.navigationController didFinishPickingPhoto:selectedAssets];
        }];
        
        [self.navigationController pushViewController:previewC animated:YES];
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - Getters

+ (UICollectionViewLayout *)photoCollectionViewLayoutWithWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = keLongMargin;
    layout.itemSize = keLongThumbnailSize;
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    return layout;
}

@end
