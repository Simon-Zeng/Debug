//
//  eLongPhotoView.h
//  Elong_Shake
//
//  Created by Wang Shuguang on 13-1-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol eLongPhotoViewDelegate;
@interface eLongPhotoView : UIView<UIScrollViewDelegate>{
@private
    NSInteger photoCount;
    NSInteger page;
    CGSize photoSize;
    UIScrollView *photosView;
    NSMutableArray *photoArray;
    BOOL isScaled;
    UITapGestureRecognizer *doubleTap;
    UITapGestureRecognizer *singleTap;
//    id delegate;
}
@property (nonatomic,strong) NSArray *photoUrls;
@property (nonatomic,assign) id<eLongPhotoViewDelegate> delegate;
@property (nonatomic,assign) UIViewContentMode imageContentMode;
@property (nonatomic,assign) BOOL scaleable;
@property (nonatomic, assign) BOOL resetFrame;


- (id)initWithFrame:(CGRect)frame photoUrls:(NSArray *)urs progress:(BOOL) progress_;
- (void)reloadPhotosWith:(NSArray *)urls;
- (void) pageToIndex:(NSInteger)index;
- (void) setGestureDisabled;
- (void)nextPageWithAnimation:(BOOL)animation;
- (void)previousPageWithAnimation:(BOOL)animation;
@end


@protocol eLongPhotoViewDelegate <NSObject>
@optional
- (void) photoView:(eLongPhotoView *)photoView didSelectedAtIndex:(NSInteger)index;
- (void) photoView:(eLongPhotoView *)photoView didPageToIndex:(NSInteger)index;
- (void) photoView:(eLongPhotoView *)photoView didScrollOffsetX:(float)offsetX contentWidth:(float)contentWidth;
@end