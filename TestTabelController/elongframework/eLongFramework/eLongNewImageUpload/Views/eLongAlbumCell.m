//
//  eLongAlbumCell.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "eLongAlbumCell.h"

#import "eLongAlbumModel.h"
#import "eLongPhotoManager.h"

@interface eLongAlbumCell ()
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation eLongAlbumCell


- (void)configCellWithItem:(eLongAlbumModel * _Nonnull)item {
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:item.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",item.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLabel.attributedText = nameString;
    
    __weak typeof(*&self) wSelf = self;
    
    id asset = nil;
    if ([item.fetchResult isKindOfClass:[ALAssetsGroup class]]) {
        //IOS7
        ALAssetsGroup *resultGroup = item.fetchResult;
        @autoreleasepool {
            [resultGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
             {
                 [[eLongPhotoManager sharedManager] getThumbnailWithAsset:result size:keLongThumbnailSize completionBlock:^(UIImage *image) {
                     __weak typeof(*&self) self = wSelf;
                     self.albumCoverImageView.image = image;
                 }];
                 
             }];
        }
        
    }
    else if ([item.fetchResult isKindOfClass:[PHFetchResult class]]){
        //IOSVersion_8
        PHFetchResult *result = item.fetchResult;
        asset = [result lastObject];
        
        [[eLongPhotoManager sharedManager] getThumbnailWithAsset:asset size:keLongThumbnailSize completionBlock:^(UIImage *image) {
            __weak typeof(*&self) self = wSelf;
            self.albumCoverImageView.image = image;
        }];
    }else{
    
    }
    _albumCoverImageView.clipsToBounds = YES;
}

@end
