//
//  eLongCustomPopView.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/16.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCustomPopView.h"
#import "eLongDefine.h"

@interface eLongCustomPopView()

@property (nonatomic, assign) eLongCustomPopViewStyle style;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation eLongCustomPopView

- (void)popViewWithStyle:(eLongCustomPopViewStyle)popStyle
{
    self.style = popStyle;
    
    UIWindow *mainWindow = (UIWindow *)[UIApplication sharedApplication].keyWindow;
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = RGBCOLOR(0, 0, 0, 1.0f);
    [mainWindow addSubview:self.bgView];
    self.bgView.alpha = 0.0f;
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.bgView addGestureRecognizer:singleTapGesture];
    
    if (self.superview) {
        
        [self removeFromSuperview];
        
        [mainWindow addSubview:self];
    }
    else {
        
        [mainWindow addSubview:self];
    }
    
    CGRect startRect = [self getOutScreenRectWithPopStyle:self.style];
    CGRect endRect = [self getInScreenRectWithPopStyle:self.style];
    
    [self setFrame:startRect];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDuration:0.3f];
    [self setFrame:endRect];
    self.bgView.alpha = 0.8f;
    [UIView commitAnimations];
}

- (void)dismissView
{
    CGRect startRect = [self getInScreenRectWithPopStyle:self.style];
    CGRect endRect = [self getOutScreenRectWithPopStyle:self.style];
    
    [self setFrame:startRect];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self setFrame:endRect];
        self.bgView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [self removeFromSuperview];
    }];
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture {
    
    [self dismissView];
}

- (CGRect)getOutScreenRectWithPopStyle:(eLongCustomPopViewStyle)popStyle
{
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    if (popStyle == eLongCustomPopViewStyleFromTop) {
        
        rect = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
    else if (popStyle == eLongCustomPopViewStyleFromRight) {
        
        rect = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
    }
    else if (popStyle == eLongCustomPopViewStyleFromLeft) {
        
        rect = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    
    return rect;
}

- (CGRect)getInScreenRectWithPopStyle:(eLongCustomPopViewStyle)popStyle
{
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    if (popStyle == eLongCustomPopViewStyleFromTop) {
        
        rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    else if (popStyle == eLongCustomPopViewStyleFromRight) {
        
        rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    else if (popStyle == eLongCustomPopViewStyleFromLeft) {
        
        rect = CGRectMake(SCREEN_WIDTH - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
    
    return rect;
}

@end
