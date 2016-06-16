//
//  UIButton+eLongExtension.m
//  Pods
//
//  Created by chenggong on 15/6/10.
//
//

#import "UIButton+eLongExtension.h"
#import "eLongDefine.h"
#import "UIImage+eLongExtension.h"
#import "UIColor+eLongExtension.h"

@implementation UIButton (eLongExtension)

+ (UIButton *)checkcodeButtonWithTarget:(id)target
                                 Action:(SEL)selector
                                  Frame:(CGRect)rect
{
    UIButton *checkcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkcodeBtn.frame = rect;
    checkcodeBtn.titleLabel.font = FONT_14;
    [checkcodeBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [checkcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkcodeBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"eLongExtension_checkcode_btn.png"] forState:UIControlStateNormal];
    
    return checkcodeBtn;
}

// 返回黄底白字的18号大小的按钮
+ (UIButton *)yellowWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
//    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    // 改成蓝色样式按钮
    [commitButton setBackgroundColor:[UIColor colorWithHexStr:@"#4499ff"]];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:title forState:UIControlStateNormal];
    [commitButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    commitButton.titleLabel.font	= FONT_B18;
    commitButton.frame				= rect;
    commitButton.layer.cornerRadius = 3.0f;
    commitButton.layer.masksToBounds = YES;
    
    return commitButton;
}

// 返回红底白字的18号大小的按钮
+ (UIButton *)redWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_roundRect"]stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_roundRect_pressed"]stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:title forState:UIControlStateNormal];
    [commitButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    commitButton.titleLabel.font	= FONT_B18;
    commitButton.frame				= rect;
    
    return commitButton;
}



+ (UIButton *)blueWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_nonMember_login_btn_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[[UIImage imageNamed:@"eLongExtension_nonMember_login_btn_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:title forState:UIControlStateNormal];
    [commitButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    commitButton.titleLabel.font	= FONT_B18;
    commitButton.frame				= rect;
    
    return commitButton;
}


+ (UIButton *)arrowButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect Orientation:(eLongArrowOrientation)Orientation {
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tipButton.backgroundColor = [UIColor whiteColor];
    [tipButton setTitle:title forState:UIControlStateNormal];
    [tipButton setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
    [tipButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [tipButton setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    tipButton.frame	= rect;
    
    UIImage *arrow = nil;
    int offX = 0;
    switch (Orientation) {
        case eLongArrowOrientationDown:
            arrow	= [UIImage imageNamed:@"eLongExtension_ico_downarrow.png"];
            offX	= 8;
            break;
        case eLongArrowOrientationRight:
            arrow	= [UIImage imageNamed:@"eLongExtension_ico_rightarrow.png"];
            offX	= 5;
            break;
        case eLongPlusSign:
            arrow	= [UIImage imageNamed:@"addSign.png"];
            offX	= 0;
            break;
            
        default:
            break;
    }
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithImage:arrow];
    rightArrow.frame = CGRectMake(rect.size.width - offX - arrow.size.width, rect.size.height/2 - arrow.size.height/2, arrow.size.width, arrow.size.height);
    [tipButton addSubview:rightArrow];
    
    return tipButton;
}


+ (UIButton *)uniformButtonWithTitle:(NSString *)title
                           ImagePath:(NSString *)path
                              Target:(id)target
                              Action:(SEL)selector
                               Frame:(CGRect)rect
{
    UIButton *commitButton = [UIButton yellowWhitebuttonWithTitle:@""
                                                           Target:target
                                                           Action:selector
                                                            Frame:rect];
    float contentLength = 0.f;		// 图片文字总长度
    int	distance = 10;				// 图片文字距离
    
    
    if (path == nil || [path isEqualToString:@""]) {
        distance = 0;
    }
    
    UIImage *icon = [UIImage imageNamed:path];
    
    contentLength += icon.size.width + distance;
    
    CGSize size = [title sizeWithFont:FONT_B18];
    contentLength += size.width;
    
    
    UIImageView *nextImage = [[UIImageView alloc] initWithImage:icon];
    nextImage.frame = CGRectMake((commitButton.frame.size.width - contentLength)/2,
                                 (commitButton.frame.size.height - icon.size.height)/2,
                                 icon.size.width,
                                 icon.size.height);
    [commitButton addSubview:nextImage];
    
    
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(nextImage.frame.origin.x + nextImage.frame.size.width + distance,
                                                               (commitButton.frame.size.height - size.height) / 2,
                                                               size.width,
                                                               size.height)];
    label.text				= title;
    label.textColor			= [UIColor whiteColor];
    label.font				= FONT_B18;
    label.backgroundColor	= [UIColor clearColor];
    [commitButton addSubview:label];
    
    return commitButton;
}


+ (UIButton *)uniformBottomButtonWithTitle:(NSString *)title
                                 ImagePath:(NSString *)path
                                    Target:(id)target
                                    Action:(SEL)selector
                                     Frame:(CGRect)rect
{
    UIButton *button = [UIButton uniformButtonWithTitle:title
                                              ImagePath:path
                                                 Target:target
                                                 Action:selector
                                                  Frame:rect];
    
    [button setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage stretchableImageWithPath:@"bottom_bar_btn_press.png"] forState:UIControlStateHighlighted];
    
    return button;
}


+ (UIButton *)uniformMoreButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect {
    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.adjustsImageWhenHighlighted = NO;
    
    [morebutton setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forState:UIControlStateNormal];
    [morebutton setContentMode:UIViewContentModeScaleToFill];
    [morebutton setFrame:rect];
    [morebutton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    [morebutton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [morebutton setTitle:[NSString stringWithFormat:@"%@...",title] forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return morebutton;
}

- (UIImage *) buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
