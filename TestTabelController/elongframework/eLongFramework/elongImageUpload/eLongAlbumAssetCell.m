//
//  eLongAlbumAssetCell.m
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongAlbumAssetCell.h"
#import "eLongAlbumAsset.h"
#import "eLongDefine.h"

@interface eLongAlbumAssetCell ()

@property (nonatomic, retain) NSArray *rowAssets;
@property (nonatomic, retain) NSMutableArray *imageViewArray;
@property (nonatomic, retain) NSMutableArray *overlayViewArray;

@end

@implementation eLongAlbumAssetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (UIImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {
        
        eLongAlbumAsset *asset = [_rowAssets objectAtIndex:i];
        
        if (i < [_imageViewArray count]) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        if (i < [_overlayViewArray count]) {
            UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
        } else {
            if (overlayImage == nil) {
                // TODO: Need two resolution images.
                overlayImage = [UIImage imageNamed:@"framework_Overlay"];
            }
            UIImageView *overlayView = [[UIImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:self];
//    CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
//    CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
//    
//	CGRect frame = CGRectMake(startX, 2, 75, 75);
    CGFloat margin = 4.0f;
    CGFloat imageW = (SCREEN_WIDTH - 5 * margin) / 4;
    CGFloat imageH = imageW;
	CGRect frame = CGRectMake(4.0f, 2, imageW, imageH);
    
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            eLongAlbumAsset *asset = [_rowAssets objectAtIndex:i];
            if (self.selectable) {
                asset.selected = !asset.selected;
                UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
                overlayView.hidden = !asset.selected;
                if ([self.delegate respondsToSelector:@selector(elongAlbumAssetCell:selected:)]) {
                    [self.delegate elongAlbumAssetCell:self selected:asset.selected];
                }
            }else if(asset.selected){
                asset.selected = !asset.selected;
                UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
                overlayView.hidden = !asset.selected;
                if ([self.delegate respondsToSelector:@selector(elongAlbumAssetCell:selected:)]) {
                    [self.delegate elongAlbumAssetCell:self selected:asset.selected];
                }
            }
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + 4;
    }
}

- (void)layoutSubviews
{
//    CGFloat totalWidth = self.rowAssets.count * 75 + (self.rowAssets.count - 1) * 4;
//    CGFloat startX = (self.bounds.size.width - totalWidth) / 2;
    CGFloat margin = 4;
    CGFloat imageW = (SCREEN_WIDTH - 5 * margin) / 4;
    CGFloat imageH = imageW;
	CGRect frame = CGRectMake(4.0f, 2, imageW, imageH);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
		
		frame.origin.x = frame.origin.x + frame.size.width + 4;
	}
}

@end
