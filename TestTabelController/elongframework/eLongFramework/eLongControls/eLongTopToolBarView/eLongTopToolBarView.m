//
//  eLongTopToolBarView.m
//  eLongHotel
//
//  Created by top on 16/3/2.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongTopToolBarView.h"
#import "eLongTopToolBarViewItemCell.h"
#import "eLongTopToolBarViewItemCellModel.h"
#import "eLongDefine.h"
#import "eLongFileIOUtils.h"
#import "UIView+LayoutMethods.h"

@interface eLongTopToolBarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *contentCV;

@property (nonatomic, strong) eLongTopToolBarViewItemCellModel *currentOpenedCellModel;

@end

@implementation eLongTopToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(0, 0);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _contentCV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _contentCV.delegate = self;
    _contentCV.dataSource = self;
    _contentCV.backgroundColor = [UIColor whiteColor];
    _contentCV.showsVerticalScrollIndicator = NO;
    _contentCV.clipsToBounds = YES;
    _contentCV.scrollsToTop = NO;
    _contentCV.scrollEnabled = NO;
    [_contentCV registerClass:[eLongTopToolBarViewItemCell class] forCellWithReuseIdentifier:@"Cell"];
    [self addSubview:_contentCV];
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ARRAYHASVALUE(self.itemsArray) ? self.itemsArray.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongTopToolBarViewItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    eLongTopToolBarViewItemCellModel *model = [self.itemsArray safeObjectAtIndex:indexPath.row];
    [cell refreshContentViewWithCellModel:model];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (ARRAYHASVALUE(self.itemsArray)) {
        int width = ceil(self.width/self.itemsArray.count);
        int height = self.height;
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    eLongTopToolBarViewItemCellModel *model = [self.itemsArray safeObjectAtIndex:indexPath.row];
    if (self.currentOpenedCellModel == model) {
        model.hasOpened = !model.hasOpened;
    } else {
        model.hasOpened = YES;
        self.currentOpenedCellModel.hasOpened = NO;
        self.currentOpenedCellModel = model;
    }
    [self.contentCV reloadData];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(eLongTopToolBarView:didOpenItemCellModel:)])
    {
        [self.delegate eLongTopToolBarView:self didOpenItemCellModel:model];
    }
}

#pragma mark - public method
- (void)reloadView {
    if (!ARRAYHASVALUE(self.itemsArray)) {
        return;
    }
    [self.contentCV reloadData];
}

#pragma mark - private method

@end
