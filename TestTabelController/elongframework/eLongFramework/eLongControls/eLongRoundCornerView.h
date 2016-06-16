//
//  RoundCornerView.h
//  ElongClient
//  圆角带边框的View
//
//  Created by haibo on 11-9-19.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface eLongRoundCornerView : UIView {
@private
	CGImageRef imageRef;
}

@property(nonatomic, assign) BOOL selected;		
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIColor *borderColor;		// default gray color
@property(nonatomic, retain) UIColor *fillColor;		// default nil
@property(nonatomic, assign) float imageRadius;
@property(nonatomic, retain) UIImage *placeholder;
@property(nonatomic, readonly) UIImageView *downLoadImageView;



- (id)initWithFrame:(CGRect)frame;

- (void)selectedWithColor:(UIColor *)boardColor;		// draw extra board with color
- (void)deselect;										// cancel the board

@end


@interface SmallLoadingView : eLongRoundCornerView {
@private
	UIActivityIndicatorView *indicatorView;
}

- (void)startLoading;
- (void)stopLoading;

@end

@interface SmallLoadingViewWithStatus : eLongRoundCornerView {

}
@property(nonatomic, retain) UIImageView *statusImageView;
@property(nonatomic, retain) UILabel *statusLabel;
@property(nonatomic, retain) NSString *statusString;
@property(nonatomic, assign) NSInteger imageAuditStatus; //图片审核状态 审核状态 0:未审核 1:通过 2:不通过
@end

