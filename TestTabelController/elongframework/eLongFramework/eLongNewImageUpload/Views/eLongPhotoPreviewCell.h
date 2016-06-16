//
//  eLongPhotoPreviewCell.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eLongAssetModel;
@interface eLongPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, copy, nullable)   void(^singleTapBlock)();


- (void)configCellWithItem:(eLongAssetModel * _Nonnull )item;

@end
