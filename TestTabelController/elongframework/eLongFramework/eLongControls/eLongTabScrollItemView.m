//
//  eLongTabScrollItemView.m
//  MyElong
//
//  Created by yangfan on 15/12/29.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import "eLongTabScrollItemView.h"
#import "UIColor+eLongExtension.h"
#import "UIView+LY.h"
#import "eLongDefine.h"

#define kTabItemHeight 28

@implementation eLongTabScrollItemView

- (void)dealloc {
    self.titleLabel			= nil;
    self.titleNormalColor		= nil;
    self.titleHighlightedColor	= nil;
    self.titleNormalFont		= nil;
    self.titleHighlightedFont	= nil;
    self.labelBorderNormalColor = nil;
    
    iconImageView = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, frame.size.width, kTabItemHeight)];
        label.textAlignment		= NSTextAlignmentCenter;
        label.textColor			= [UIColor colorWithHexStr:@"#444444"];
        label.numberOfLines     = 0;
        label.font = [UIFont systemFontOfSize:12];
        label.layer.borderColor = [UIColor colorWithHexStr:@"#d3d3d3"].CGColor;
        label.layer.borderWidth = SCREEN_SCALE;
        label.layer.cornerRadius = 2.0;
        
        self.titleLabel			= label;
        [self addSubview:label];
        
        self.titleHighlightedColor = [UIColor colorWithHexStr:@"#4499ff"];
        self.titleNormalColor = [UIColor colorWithHexStr:@"#444444"];
        self.labelBorderNormalColor = [UIColor colorWithHexStr:@"#d3d3d3"];
        
        self.titleHighlightedFont = [UIFont systemFontOfSize:12];
        self.titleNormalFont = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

- (void)changeState:(BOOL)isPressed {
    if (isPressed) {
        self.userInteractionEnabled	= NO;
        self.titleLabel.textColor		= self.titleHighlightedColor;
        self.titleLabel.layer.borderColor = self.titleHighlightedColor.CGColor;
        self.titleLabel.font			= self.titleHighlightedFont;
        iconImageView.highlighted	= YES;
    }
    else {
        self.userInteractionEnabled	= YES;
        self.titleLabel.textColor		= self.titleNormalColor;
        self.titleLabel.font			= self.titleNormalFont;
        self.titleLabel.layer.borderColor = self.labelBorderNormalColor.CGColor;
        iconImageView.highlighted	= NO;
    }
}

- (void)setTitleNormalColor:(UIColor *)color
{
    if (color != _titleNormalColor)
    {
        _titleNormalColor = color;
    }
    
    self.titleLabel.textColor = color;
}


- (void)setTitleNormalFont:(UIFont *)font
{
    if (font != _titleNormalFont)
    {
        _titleNormalFont = font;
    }
    
    self.titleLabel.font = font;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch ) {
        [self.delegate setHighlightedIndex:self.tag];
    }
}

@end
