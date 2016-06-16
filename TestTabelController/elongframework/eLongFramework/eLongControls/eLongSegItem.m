//
//  eLongSegItem.m
//  ElongClient
//  自定义segmented的组件
//
//  Created by haibo on 11-10-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "eLongSegItem.h"
#import "UIColor+eLongExtension.h"
#import "UIView+LY.h"
@interface eLongSegItem ()


@end

@implementation eLongSegItem

- (void)dealloc {
    self.titleLabel			= nil;
    self.titleNormalColor		= nil;
    self.titleHighlightedColor	= nil;
    self.titleNormalFont		= nil;
    self.titleHighlightedFont	= nil;
    self.titleNumLabel          = nil;
    iconImageView = nil;
    self.bottomLineView = nil;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, frame.size.width, frame.size.height / 2)];
        label.backgroundColor	= [UIColor clearColor];
        label.textAlignment		= NSTextAlignmentCenter;
        label.textColor			= [UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1.0];
        label.numberOfLines     = 0;
        label.font = [UIFont systemFontOfSize:15];
        self.titleLabel			= label;
        [self addSubview:label];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 - 2, frame.size.width, frame.size.height / 2)];
        numLabel.backgroundColor	= [UIColor clearColor];
        numLabel.textAlignment		= NSTextAlignmentCenter;
        numLabel.textColor			= [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        numLabel.numberOfLines     = 0;
        numLabel.font = [UIFont systemFontOfSize:15];
        self.titleNumLabel			= numLabel;
        [self addSubview:numLabel];
        
        self.titleHighlightedColor = [UIColor colorWithHexStr:@"#4499ff"];
        self.titleNormalColor = [UIColor blackColor];
        
        self.titleHighlightedFont = [UIFont systemFontOfSize:15];
        self.titleNormalFont = [UIFont systemFontOfSize:15];
        self.bottomLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, self.height - 2, frame.size.width, 2)];
        self.bottomLineView.centerX = self.width / 2;
        self.bottomLineView.backgroundColor = [UIColor colorWithHexStr:@"#4499ff"];
        self.bottomLineView.hidden = YES;
        
        [self addSubview:self.bottomLineView];
    }
    
    return self;
}
- (id)initWithFrameNew:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.backgroundColor	= [UIColor clearColor];
        label.textAlignment		= NSTextAlignmentCenter;
        label.textColor			= [UIColor colorWithRed:68.0 / 255.0 green:68.0 / 255.0 blue:68.0 / 255.0 alpha:1.0];
        label.numberOfLines     = 0;
        label.font = [UIFont systemFontOfSize:15];
        self.titleLabel			= label;
        [self addSubview:label];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 - 2, frame.size.width, frame.size.height / 2)];
        numLabel.backgroundColor	= [UIColor clearColor];
        numLabel.textAlignment		= NSTextAlignmentCenter;
        numLabel.textColor			= [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        numLabel.numberOfLines     = 0;
        numLabel.font = [UIFont systemFontOfSize:15];
        self.titleNumLabel			= numLabel;
        [self addSubview:numLabel];
        
        self.titleHighlightedColor = [UIColor colorWithHexStr:@"#4499ff"];
        self.titleNormalColor = [UIColor blackColor];
        
        self.titleHighlightedFont = [UIFont systemFontOfSize:15];
        self.titleNormalFont = [UIFont systemFontOfSize:15];
        self.bottomLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, self.height - 2, frame.size.width, 2)];
        self.bottomLineView.centerX = self.width / 2;
        self.bottomLineView.backgroundColor = [UIColor colorWithHexStr:@"#4499ff"];
        self.bottomLineView.hidden = YES;
        
        [self addSubview:self.bottomLineView];
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.backgroundColor	= [UIColor clearColor];
        label.textAlignment		= NSTextAlignmentCenter;
        label.textColor			= [UIColor whiteColor];
        self.titleLabel			= label;
        [self addSubview:label];
        
        self.titleHighlightedColor = self.titleNormalColor = [UIColor blackColor];
    }
    
    return self;
}


- (void)changeState:(BOOL)isPressed {
    if (isPressed) {
        self.highlighted			= YES;
        self.userInteractionEnabled	= NO;
        self.titleLabel.textColor		= self.titleHighlightedColor;
        self.titleLabel.font			= self.titleHighlightedFont;
        self.titleNumLabel.textColor    = self.titleHighlightedColor;
        iconImageView.highlighted	= YES;
        self.bottomLineView.hidden = NO;
    }
    else {
        self.highlighted			= NO;
        self.userInteractionEnabled	= YES;
        self.titleLabel.textColor		= self.titleNormalColor;
        self.titleLabel.font			= self.titleNormalFont;
        self.titleNumLabel.textColor    = [UIColor colorWithRed:153.f / 255.f green:153.f / 255.f blue:153.f / 255.f alpha:1.0];
        iconImageView.highlighted	= NO;
        self.bottomLineView.hidden = YES;
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

- (void)setNormalIcon:(UIImage *)iconNormal hightedIcon:(UIImage *)iconHighted {
    if (iconNormal && [iconNormal isKindOfClass:[UIImage class]]) {
        // 有图标时调整图文字得位置
        if (!iconImageView) {
            iconImageView = [[UIImageView alloc] initWithImage:iconNormal highlightedImage:iconHighted];
            
            CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:self.frame.size];
            iconImageView.frame = CGRectMake((self.frame.size.width - iconNormal.size.width - 10 - titleSize.width) / 2,
                                             (self.frame.size.height - iconNormal.size.height) / 2,
                                             iconNormal.size.width,
                                             iconNormal.size.height);
            [self addSubview:iconImageView];
            
            self.titleLabel.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 10,
                                               (self.frame.size.height - titleSize.height) / 2,
                                               titleSize.width,
                                               titleSize.height);
        }
    }
    else {
        // 没有图标时调整文字位置
        self.titleLabel.frame = self.bounds;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if (touch) {
        [self.delegate setHighlightedIndex:self.tag];
    }
}

@end
