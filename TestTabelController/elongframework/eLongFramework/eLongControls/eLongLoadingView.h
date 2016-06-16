//
//  LoadingView.h
//  TestLoading
//
//  Created by bin xing on 11-1-24.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongNetworking.h"

@class eLongWaitingView;
@protocol LoadingViewDelegate;
@interface eLongLoadingView : UIView {
@private
	CGRect alertFrame;
	BOOL alertShowing;			// 警告框正被展示

	UIView *content;
    UIImageView *flashView;
    
    UIButton *cancelReqBtn;
}

@property (nonatomic, assign) int outTime;
@property (nonatomic, assign) BOOL loadHidden;
@property (nonatomic, strong) eLongHTTPRequest *m_util;
@property (nonatomic, weak) id<LoadingViewDelegate> delegate;

+ (eLongLoadingView *)sharedLoadingView;
+ (eLongLoadingView *)sharedBlockLoadingView;
- (void)showAlertMessage:(NSString *)message utils:(eLongHTTPRequest *)httpUtil;
- (void)showAlertMessage:(NSString *)message delegate:(id<LoadingViewDelegate>)delegate;
- (void)showAlertMessageNoCancel;
- (void)hideAlertMessage;
- (void)hideAlertMessageNoDelay;
- (void) refreshTips:(NSString *)tips;
@end

@protocol LoadingViewDelegate <NSObject>

- (void) cancelLoading;

@end