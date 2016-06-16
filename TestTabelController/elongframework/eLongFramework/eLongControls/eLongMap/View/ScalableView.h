//
//  ScalableView.h
//  ElongClient
//
//  Created by Wang Shuguang on 12-12-11.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScalableViewDelegate;
@interface ScalableView : UIView

@property (nonatomic, weak) id<ScalableViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *hightlightedArray;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images highlightedImages:(NSArray *)hImages;
- (void) moveBack;
- (void) moveOut;

@end


@protocol ScalableViewDelegate <NSObject>
@optional
- (void) scalableView:(ScalableView *)ScalableView didSelectedAtIndex:(NSInteger)index;
- (void) scalableViewDidMoveout:(ScalableView *)ScalableView;
@end