//
//  UIImage+eLongExtension.h
//  Pods
//
//  Created by chenggong on 15/6/2.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (eLongExtension)

+ (UIImage *)stretchableImageWithPath:(NSString *)path;

// 无缓存读取图片
+ (UIImage *)noCacheImageNamed:(NSString *)name;

// 根据传入的size来生成相应大小的压缩图片
- (id)compressImageWithSize:(CGSize)size;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
