//
//  UIView+Animations.m
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)


+ (void)animationWithLayer:(CALayer *)layer type:(eLongAnimationType)type {
    NSNumber *animationScale1 = type == eLongAnimationTypeSmaller ? @(1.15) : @(0.7);
    NSNumber *animationScale2 = type == eLongAnimationTypeBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

+ (CABasicAnimation *)animationWithFromValue:(id)fromValue toValue:(id)toValue duration:(CGFloat)duration forKeypath:(NSString *)keypath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keypath];
    animation.fromValue = fromValue;
    animation.toValue   = toValue;
    animation.duration = duration;
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    //保证动画不会复原到初始位置
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
@end
