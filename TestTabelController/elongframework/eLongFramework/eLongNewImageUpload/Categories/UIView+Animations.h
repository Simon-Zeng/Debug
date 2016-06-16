//
//  UIView+Animations.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/27.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, eLongAnimationType) {
    eLongAnimationTypeBigger,
    eLongAnimationTypeSmaller,
};

@interface UIView (Animations)

+ (void)animationWithLayer:(CALayer *)layer type:(eLongAnimationType)type;

+ (CABasicAnimation *)animationWithFromValue:(id)fromValue toValue:(id)toValue duration:(CGFloat)duration forKeypath:(NSString *)keypath;

@end
