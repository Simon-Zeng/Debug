//
//  UIColor+eLongExtension.h
//  eLongFramework
//
//  Created by Kirn on 15/5/12.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (eLongExtension)
// 转换16进制数为rgb色值的方法
+ (UIColor *)colorWithHexStr:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexStr:(NSString *)stringToConvert alpha:(CGFloat)alpha;
@end
