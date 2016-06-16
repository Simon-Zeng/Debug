//
//  NSString+eLongTextSize.h
//  InterHotel
//
//  Created by Dean on 15/6/3.
//  Copyright (c) 2015年 eLong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (TextSize)

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font;

- (BOOL)isNotEmpty;

- (BOOL)isEmptyOrNull;

/**
 *  计算字符串的字数。
 *  @param  string:输入字符串。
 *  return  返回输入字符串的字数。
 */
- (NSUInteger)wordsCount;
- (int)byteSize;
@end
