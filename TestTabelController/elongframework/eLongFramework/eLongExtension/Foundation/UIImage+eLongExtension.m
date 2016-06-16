//
//  UIImage+eLongExtension.m
//  Pods
//
//  Created by chenggong on 15/6/2.
//
//

#import "UIImage+eLongExtension.h"

@implementation UIImage (eLongExtension)

+ (UIImage *)stretchableImageWithPath:(NSString *)path {
    UIImage *stretchImg = [UIImage imageNamed:path];
    return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
                                           topCapHeight:stretchImg.size.height / 2];
}

+ (UIImage *)noCacheImageNamed:(NSString *)name {
    if (!name || [name isEqualToString:@""]) {
        return nil;
    }
    if ([name rangeOfString:@"."].location == NSNotFound) {//无后缀默认添加.png
        name = [name stringByAppendingString:@".png"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    if (!image) {
        image = [UIImage imageNamed:[[name componentsSeparatedByString:@"."] firstObject]];
    }
    
    return image;
}


- (id)compressImageWithSize:(CGSize)size {
    UIImage *image = self;
    UIGraphicsBeginImageContext(size);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [self drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


@end
