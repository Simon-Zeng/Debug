//
//  UIImage+Resizable.m
//
//
//  Created by dayu on 15/7/8.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "UIImage+Resizable.h"

@implementation UIImage (Resizable)

+ (UIImage *)resizableImage:(NSString *)imageName {
    UIImage *normal = [UIImage imageNamed:imageName];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
