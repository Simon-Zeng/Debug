//
//  UIView+TipMessage.m
//  MyElong
//
//  Created by yangfan on 15/6/17.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "UIView+TipMessage.h"
#import "eLongDefine.h"
#import "eLongRoundCornerView.h"
#import "eLongAlertTipView.h"

@implementation UIView (TipMessage)

#define kTipImageTag  10086

+ (id)clearViewWithFrame:(CGRect)rect {
    UIView *clearView = [[UIView alloc] initWithFrame:rect];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}


- (void)endLoading {
    for (UIActivityIndicatorView *aView in self.subviews) {
        if ([aView isKindOfClass:[UIActivityIndicatorView class]]) {
            [aView removeFromSuperview];
            
        }
    }
}


- (void)endUniformLoading {
    for (SmallLoadingView *aView in self.subviews) {
        if ([aView isMemberOfClass:[SmallLoadingView class]]) {
            [aView removeFromSuperview];
        }
    }
}


- (void)removeTipMessage {
    UIImageView *backView = (UIImageView *)[self viewWithTag:kTipImageTag];
    if (backView) {
        [backView removeFromSuperview];
    }
}


- (void)showTipMessage:(NSString *)tips {
    UIImageView *backView	= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    //	backView.image			= [UIImage noCacheImageNamed:@"round_bg.png"];
    backView.tag			= kTipImageTag;
    
    UILabel *tipLabel			= [[UILabel alloc] initWithFrame:backView.frame];
    tipLabel.backgroundColor	= [UIColor clearColor];
    tipLabel.text				= tips;
    tipLabel.textAlignment		= NSTextAlignmentCenter;
    tipLabel.font				= [UIFont boldSystemFontOfSize:16];
    
    [backView addSubview:tipLabel];
    backView.center	= CGPointMake(SCREEN_WIDTH / 2, MAINCONTENTHEIGHT / 2 - 20);
    [self insertSubview:backView atIndex:0];
}


- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style {
    [self startLoadingByStyle:style AtPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
}


- (void)startLoadingByStyle:(UIActivityIndicatorViewStyle)style AtPoint:(CGPoint)activityCenter {
    for (UIActivityIndicatorView *aView in self.subviews) {
        // 这里是对ios6的特殊处理
        if ([aView isKindOfClass:[UIActivityIndicatorView class]]) {
            [aView startAnimating];
            return;
        }
    }
    
    UIActivityIndicatorView *aiView	= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    aiView.center					= activityCenter;
    
    [aiView startAnimating];
    [self addSubview:aiView];
}


- (void)startUniformLoading {
    for (SmallLoadingView *aView in self.subviews) {
        if ([aView isMemberOfClass:[SmallLoadingView class]]) {
            // 已经有时就不再添加
            return;
        }
    }
    
    SmallLoadingView *smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, (self.frame.size.height-50) / 2, 50, 50)];
    [self addSubview:smallLoading];
    [smallLoading startLoading];
}


- (UIImage *) imageByRenderingViewWithSize:(CGSize) size {
    CGFloat oldAlpha = self.alpha;
    
    self.alpha = 1;
    UIGraphicsBeginImageContext(size);
    self.layer.masksToBounds = NO;
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
    
    return resultingImage;
}

#define	TEXT_FIELD_ALERT_TAG		89898

- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect arrowStartPoint:(CGPoint)point {
    eLongAlertTipView *alertTip = (eLongAlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
    if (alertTip) {
        [self removeAlert];
        alertTip = nil;
    }
    
    alertTip = [[eLongAlertTipView alloc] initWithFrame:rect startPoint:point];
    alertTip.tipString = tipString;
    alertTip.stringColor = [UIColor redColor];
    alertTip.tag = TEXT_FIELD_ALERT_TAG;
    [self addSubview:alertTip];
}


- (void)alertMessage:(NSString *)tipString InRect:(CGRect)rect {
    [self alertMessage:tipString InRect:rect arrowStartPoint:CGPointMake(self.bounds.size.width / 2, rect.origin.y)];
}


- (void)alertMessage:(NSString *)tipString {
    [self alertMessage:tipString InRect:CGRectMake(0, self.frame.size.height - 8, self.frame.size.width, 30)];
}


- (void)removeAlert {
    eLongAlertTipView *alertTip = (eLongAlertTipView *)[self viewWithTag:TEXT_FIELD_ALERT_TAG];
    [alertTip removeFromSuperview];
}

@end
