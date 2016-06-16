//
//  eLongAlbumAssetCell.h
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol eLongAlbumAssetCellDelegate;
@interface eLongAlbumAssetCell : UITableViewCell

- (void)setAssets:(NSArray *)assets;
@property (nonatomic,assign) id<eLongAlbumAssetCellDelegate> delegate;
@property (nonatomic,assign) BOOL selectable;
@end

@protocol eLongAlbumAssetCellDelegate <NSObject>
@optional
- (void) elongAlbumAssetCell:(eLongAlbumAssetCell *)cell selected:(BOOL)selected;

@end
