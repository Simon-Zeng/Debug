//
//  eLongAlertView.m
//  eLongFramework
//
//  Created by Kirn on 15/5/12.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongAlertView.h"
#import <UIKit/UIKit.h>
#import "eLongDefine.h"
#import "NSString+TextSize.h"
#import "eLongBus.h"

@implementation eLongAlertView

+ (void)showDefaultAlertQuiet:(NSString *)title {
    [eLongAlertView showAlertQuiet:title canReplacedByUIAlert:NO totalDuration:1.5f];
}

+ (void)showAlertQuiet:(NSString *)title canReplacedByUIAlert:(BOOL)canReplace totalDuration:(NSTimeInterval)duration{
    if(title.length > 17 && canReplace){
        [self showAlertTitle:title Message:nil];
        return;
    }
    UILabel *tipsLbl = (UILabel *)[[UIApplication sharedApplication].keyWindow viewWithTag:7451];
    if (tipsLbl) {
        [tipsLbl removeFromSuperview];
        tipsLbl = nil;
    }
    tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
    tipsLbl.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.text = title;
    [tipsLbl sizeToFit];
    //add by jin.li
    CGRect frame = tipsLbl.frame;
    if (frame.size.width<SCREEN_WIDTH/4-20) {
        tipsLbl.frame = CGRectMake(0, 0,SCREEN_WIDTH/4, tipsLbl.frame.size.height + 20);
    }
    else{
        tipsLbl.frame = CGRectMake(0, 0, tipsLbl.frame.size.width + 20, tipsLbl.frame.size.height + 20);
        
    }
    
    //tipsLbl.frame = CGRectMake(0, 0, tipsLbl.frame.size.width + 20, tipsLbl.frame.size.height + 10);
    tipsLbl.textColor = [UIColor whiteColor];
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    tipsLbl.tag = 7451;
    tipsLbl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    tipsLbl.layer.cornerRadius = 5.0f;
    tipsLbl.layer.masksToBounds = YES;
    
    tipsLbl.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:tipsLbl];
    [UIView animateWithDuration:duration/2 animations:^{
        tipsLbl.alpha = 1.0f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:duration/2 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            tipsLbl.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [tipsLbl removeFromSuperview];
        }];
    }];

}
+ (void) showAlertQuiet:(NSString *)title {
    
    [eLongAlertView showAlertQuiet:title canReplacedByUIAlert:YES totalDuration:0.6];
    
}

+ (void) showAlertTitle:(NSString *)title Message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


+ (void)showTip:(NSString *)tip
{
    [eLongAlertView showTip:tip duration:1.5f];
}

+ (void)showTip:(NSString *)tip duration:(float)duration
{
    if (!STRINGHASVALUE(tip)) {
        return;
    }
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [UIFont systemFontOfSize:14.0f];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    tipLabel.text = tip;
    
    CGFloat padding = 40.f;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    CGFloat textMaxWidth = SCREEN_WIDTH - (padding * 2 + edgeInsets.left + edgeInsets.right);
    CGSize textSize = [tipLabel.text boundingRectWithSize:CGSizeMake(textMaxWidth, SCREEN_HEIGHT - 64.f)
                                                     font:tipLabel.font
                       ];
    tipLabel.frame = CGRectMake(edgeInsets.left, edgeInsets.top, textSize.width, textSize.height);
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textSize.width + edgeInsets.left + edgeInsets.right, textSize.height + edgeInsets.top + edgeInsets.bottom)];
    containerView.layer.cornerRadius = 5.0f;
    containerView.layer.masksToBounds = YES;
    containerView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    [containerView addSubview:tipLabel];
    
    
    UIWindow *window = [eLongBus bus].window;
    containerView.center = window.center;
    [window addSubview:containerView];
    
    containerView.alpha = 0.0f;
    [UIView animateWithDuration:0.3 animations:^{
        containerView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:duration options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            containerView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
        }];
    }];
}


@end
