//
//  AttributedLabel.h
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger,labelTextAlignment) {
    labelTextAlignmentLeft,
    labelTextAlignmentCenter,
    labelTextAlignmentRight
};

@interface eLongAttributedLabel : UILabel{
    NSMutableAttributedString          *_attString;
    CATextLayer *textLayer;
}
@property (nonatomic,readonly) CATextLayer *textLayer;
@property (nonatomic,assign) labelTextAlignment textCenter;//文字是否居中显示（默认是左对齐）传统Label的textAlignment不起作用!
@property  (nonatomic,assign) BOOL  wrapped;
- (id) initWithFrame:(CGRect)frame wrapped:(BOOL)wrapped;

// 设置Frame
- (void)setFrame:(CGRect)frameNew;

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;

@end
