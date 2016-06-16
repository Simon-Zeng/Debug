//
//  eLongPhotoPreviewController.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongPhotoPreviewController.h"
#import "eLongPhotoPickerController.h"

#import "eLongAssetModel.h"
#import "eLongPhotoPickerDefines.h"

#import "eLongBottomBar.h"
#import "eLongPhotoPreviewCell.h"


#import "UIView+Animations.h"
#import "UIViewController+eLongPhotoHUD.h"

#import "eLongDefine.h"
#import "eLongExtension.h"
#import "eLongAlertView.h"
#import <Photos/Photos.h>


@interface eLongPhotoPreviewController ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, weak)   UIButton *stateButton;

@property (nonatomic, strong) eLongBottomBar *bottomBar;

@end

@implementation eLongPhotoPreviewController

static NSString * const keLongPhotoPreviewIdentifier = @"eLongPhotoPreviewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self _setup];
    [self _setupCollectionView];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    _bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)dealloc {
    NSLog(@"preview dealloc");
}

#pragma mark - Methods

- (void)_setup {
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.bottomBar];
    [self _updateTopBarStatus];
    [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
}

- (void)_setupCollectionView {
    
    [self.collectionView registerClass:[eLongPhotoPreviewCell class] forCellWithReuseIdentifier:keLongPhotoPreviewIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.assets.count, self.view.frame.size.height);
    self.collectionView.pagingEnabled = YES;
    
}

- (void)_handleBackAction {
    self.didFinishPreviewBlock ? self.didFinishPreviewBlock(self.selectedAssets) : nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_handleStateChangeAction {
    if (self.stateButton.selected) {
        [self.selectedAssets removeObject:self.assets[self.currentIndex]];
        self.assets[self.currentIndex].selected = NO;
        [self _updateTopBarStatus];
    }else {
        eLongAssetModel * currectAsset = [self.assets safeObjectAtIndex:self.currentIndex];
        if (currectAsset.asset && [currectAsset.asset isKindOfClass:[PHAsset class]] ) {
            if (![currectAsset isPhotoLocal]) {
                [eLongAlertView showAlertQuiet:@"该照片尚未从iCloud下载，请在系统相册中下载到本地后重新尝试"];
                return;
            }
        }
        if (self.selectedAssets.count < self.maxCount) {
            self.assets[self.currentIndex].selected = YES;
            [self.selectedAssets safeAddObject:self.assets[self.currentIndex]];
            [self _updateTopBarStatus];
            [UIView animationWithLayer:self.stateButton.layer type:eLongAnimationTypeBigger];
        }else {
            [eLongAlertView showAlertTitle:@"提示" Message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)self.maxCount]];

        }
    }
    [self.bottomBar updateBottomBarWithAssets:self.selectedAssets];
}

- (void)_updateTopBarStatus {
    eLongAssetModel *asset = self.assets[self.currentIndex];
    self.stateButton.selected = asset.selected;
    if (asset && asset.previewImage == nil) {
        [eLongAlertView showAlertQuiet:@"该照片尚未从iCloud下载，请在系统相册中下载到本地后重新尝试"];
    }
}

- (void)_setBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (!animated) {
        self.topBar.hidden = self.bottomBar.hidden = hidden;
        return;
    }
    [UIView animateWithDuration:.15 animations:^{
        self.topBar.alpha = self.bottomBar.alpha = hidden ? .0f : 1.0f;
    } completion:^(BOOL finished) {
        self.topBar.hidden = self.bottomBar.hidden = hidden;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    self.currentIndex = offSet.x / self.view.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _updateTopBarStatus];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongPhotoPreviewCell *previewCell = [collectionView dequeueReusableCellWithReuseIdentifier:keLongPhotoPreviewIdentifier forIndexPath:indexPath];
    [previewCell configCellWithItem:self.assets[indexPath.row]];
    __weak typeof(*&self) wSelf = self;
    [previewCell setSingleTapBlock:^{
        __weak typeof(*&self) self = wSelf;
        [self _setBarHidden:!self.topBar.hidden animated:YES];
    }];
    return previewCell;
}


#pragma mark - Getters

- (UIView *)topBar {
    if (!_topBar) {
        
        CGFloat originY = 20;
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, originY + 44)];
        _topBar.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:.7f];
        
        UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        [backButton sizeToFit];
        backButton.frame = CGRectMake(12, _topBar.frame.size.height/2 - backButton.frame.size.height/2 + originY/2, backButton.frame.size.width, backButton.frame.size.height);
        [backButton addTarget:self action:@selector(_handleBackAction) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:backButton];
        if (_maxCount > 1) {
            UIButton *stateButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            [stateButton setImage:[UIImage imageNamed:@"photo_state_normal"] forState:UIControlStateNormal];
            [stateButton setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
            [stateButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
            [stateButton sizeToFit];
            stateButton.frame = CGRectMake(_topBar.frame.size.width - 12 - stateButton.frame.size.width, _topBar.frame.size.height/2 - stateButton.frame.size.height/2 + originY/2, stateButton.frame.size.width, stateButton.frame.size.height);
            
            [stateButton addTarget:self action:@selector(_handleStateChangeAction) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:self.stateButton = stateButton];
        }
    }
    return _topBar;
}

- (eLongBottomBar *)bottomBar {
    eLongBottomBarType bottomType = eLongPreviewBottomBar;
    if (_maxCount < 2) {
        bottomType = eLongPreviewBottomSend;
    }

    if (!_bottomBar) {
        _bottomBar = [[eLongBottomBar alloc] initWithBarType:bottomType];
        _bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
        [_bottomBar updateBottomBarWithAssets:self.selectedAssets];
        
        __weak typeof(*&self) wSelf = self;
        [_bottomBar setConfirmBlock:^{
            __weak typeof(*&self) self = wSelf;
            NSMutableArray *images = [NSMutableArray array];
            [self.selectedAssets enumerateObjectsUsingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [images safeAddObject:obj];
            }];
            self.didFinishPickingBlock ? self.didFinishPickingBlock(images,self.selectedAssets) : nil;
        }];
        
        [_bottomBar setSendBlock:^{
            __weak typeof(*&self) self = wSelf;
            NSMutableArray *images = [NSMutableArray array];
            [self.selectedAssets enumerateObjectsUsingBlock:^(eLongAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [images safeAddObject:obj];
            }];
            self.didFinishPicking2SendBlock ? self.didFinishPicking2SendBlock(images,self.selectedAssets) : nil;
        }];
        
        [_bottomBar setCancelBlock:^{
            __weak typeof(*&self) self = wSelf;
            [self _handleBackAction];
        }];
        
        
        
    }
        _bottomBar.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
        [self.view bringSubviewToFront:_bottomBar];
    return _bottomBar;
}


+ (UICollectionViewLayout *)photoPreviewViewLayoutWithSize:(CGSize)size {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(size.width, size.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}


@end
