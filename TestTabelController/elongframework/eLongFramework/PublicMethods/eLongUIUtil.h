//
//  eLongUIUtil.h
//  MyElong
//
//  Created by yangfan on 15/6/25.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

@interface eLongUIUtil : NSObject

// 获取url链接的图片，没有图片时返回默认图片(同步方式)
+ (UIImage *)getImageWithURL:(NSString *)urlPath;

// 芝麻关门
+ (void)closeSesameInView:(UIView *)nowView;
+ (void) closeSesameAnimated:(BOOL)animated;

+ (UIView *)addView:(NSString *)string;

// 主window
+ (UIWindow *)mainWindow;

// 进入系统自带map进行导航
+ (void)pushToMapWithDestName:(NSString *)destination;
+ (void)pushToMapWithDesLat:(double)latitude Lon:(double)longitude;
+ (void) openMapListToDestination:(CLLocationCoordinate2D)destination title:(NSString *)title;

//根据字体获得高度
+(CGFloat)labelHeightWithString:(NSString *)text Width:(int)width font:(UIFont *)font;
+(CGFloat)stringWithHeight:(NSString *)text Width:(int)width font:(UIFont *)font;
+(CGSize)stringWithSize:(NSString *)text Width:(int)width font:(UIFont *)font;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;

//屏蔽掉一行字符串中的空格、换行、回车
+(NSString *)dealWithStringForRemoveSpaces:(NSString *)aStr;

+ (void)setButton:(UIButton *)button normalImage:(NSString *)normalImageName pressedImage:(NSString *)pressedImageName;
///view use animation
+ (void)animationView:(UIView *)aView fromFrame:(CGRect)fromFrame
              toFrame:(CGRect)toFrame
                delay:(float)delayTime
             duration:(float)durationTime;

///view use animation
+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                fromY:(float)fromY
                  toX:(float)toX
                  toY:(float)toY
                delay:(float)delayTime
             duration:(float)durationTime;

//给Label根据文本调整大小
+ (CGSize)getRightLabelSizeByText:(NSString *)str
                          strFont:(UIFont *)font
                         maxWidth:(CGFloat)width;

//根据字体获得高度
+ (CGFloat)labelHeightWithString:(NSString *)text
                           Width:(CGFloat)width
                      attributes:(NSDictionary *)dic;
//计算有属性字符串的label的size
+ (CGSize)boundingHeightForWidth:(CGFloat)inWidth
            withAttributedString:(NSAttributedString *)string;

@end
