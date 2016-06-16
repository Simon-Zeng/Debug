//
//  NSString+eLongExtension.h
//  eLongFramework
//
//  Created by Dawn on 15/5/2.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (eLongExtension)
- (BOOL)empty;
- (BOOL)notEmpty;
// 判断字符串是否由纯数字组成【仅限long long范围内
- (BOOL)isNumber;
// 判断字符串是否为敏感词，如果是敏感词，返回该词，如果不是返回nil
- (NSString *)sensitiveWord;
// 将一串字符的前xx位变为"*"号
- (NSString *)stringByReplaceWithAsteriskToIndex:(NSInteger)length;

// 将一串字符的后xx位变为"*"号
- (NSString *)stringByReplaceWithAsteriskFromIndex:(NSInteger)length;

// 将一串字符给定的range变为*
- (NSString *)stringByReplaceWithAsteriskWithRange:(NSRange)range;

- (id)JSONValue;

// 返回一串字符中满足形式的字符串
- (NSString *)stringByPattern:(NSString *)format;

//// 将一串字符的前xx位变为"*"号
//- (NSString *)stringByReplaceWithAsteriskToIndex:(NSInteger)length;
//
//// 将一串字符的后xx位变为"*"号
//- (NSString *)stringByReplaceWithAsteriskFromIndex:(NSInteger)length;

// 信用卡格式的字符串，4位一组
- (NSString *)stringWithCreditFromat;

// 手机号隐藏设置
- (NSString *)stringPhoneCodeHidden;

// 使用md5编码后的字符串
- (NSString *)md5Coding;

// 每x位用指定字符分隔字符串
- (NSString *)stringByInsertingWithFormat:(NSString *)format perDigit:(NSInteger)digit;

// 将字符串中的电话号码加上html标签
- (NSString *)addHtmlPhoneMark;

// 封装成html语句
- (NSString *)htmlStringWithFont:(NSString *)family textSize:(CGFloat)size textColor:(NSString *)color;

// 显示'\U...'unicode编码的正确文字
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange;
//反转
+ (NSString *)reverse:(NSString *)str;

@end
