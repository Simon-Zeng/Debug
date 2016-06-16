//
//  UIImage+Resizable.h
//
//
//  Created by dayu on 15/7/8.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizable)
+ (UIImage *)resizableImage:(NSString *)imageName;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize) size;
@end
