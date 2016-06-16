//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "eLongAttributedLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "eLongDefine.h"

@interface eLongAttributedLabel(){
    BOOL lineBreak;
}
@property (nonatomic,retain)NSMutableAttributedString          *attString;
@end

@implementation eLongAttributedLabel
@synthesize attString = _attString;
@synthesize textLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineBreak = NO;
        _textCenter = NO;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame wrapped:(BOOL)wrapped{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lineBreak = wrapped;
        _textCenter = NO;
    }
    return self;
}

- (void)setWrapped:(BOOL)wrapped
{
    _wrapped = wrapped;
    lineBreak = _wrapped;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
    [super setFrame:frameNew];
}

- (void)drawRect:(CGRect)rect{
    if (textLayer) {
        [textLayer removeFromSuperlayer];
    }
    
    textLayer = [CATextLayer layer];
    textLayer.string = _attString;
    textLayer.wrapped = lineBreak;
    textLayer.truncationMode = @"none";
    textLayer.foregroundColor = RGBACOLOR(153, 153, 153, 1).CGColor;
    //textLayer.transform = CATransform3DMakeScale(SCREEN_SCALE,SCREEN_SCALE,1);
    textLayer.contentsScale = 1.0/SCREEN_SCALE;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    switch (self.textCenter) {
        case labelTextAlignmentLeft:
        {
        
        }
            break;
        case labelTextAlignmentCenter:
        {
            textLayer.alignmentMode = @"center";
        }
            break;

        case labelTextAlignmentRight:
        {
            textLayer.alignmentMode = @"right";
        }
            break;
        default:
            break;
    }
    [self.layer addSublayer:textLayer];
    
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)color.CGColor
                        range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName,
                                              font.pointSize,
                                              NULL);
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                        value:(__bridge id)fontRef
                        range:NSMakeRange(location, length)];
    CFRelease(fontRef);
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:style]
                        range:NSMakeRange(location, length)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
