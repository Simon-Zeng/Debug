//
//  UIButton+eLongExtension.h
//  Pods
//
//  Created by chenggong on 15/6/10.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    eLongArrowOrientationRight,
    eLongArrowOrientationDown,
    eLongPlusSign
}eLongArrowOrientation;			// 按钮后箭头方向

@interface UIButton (eLongExtension)

// 返回验证码按钮，需要传入图片地址
+ (UIButton *)checkcodeButtonWithTarget:(id)target
                                 Action:(SEL)selector
                                  Frame:(CGRect)rect;

// 返回黄底白字的18号大小的按钮
+ (UIButton *)yellowWhitebuttonWithTitle:(NSString *)title
                                  Target:(id)target
                                  Action:(SEL)selector
                                   Frame:(CGRect)rect;

// 返回红底白字的18号大小的按钮
+ (UIButton *)redWhitebuttonWithTitle:(NSString *)title Target:(id)target Action:(SEL)selector Frame:(CGRect)rect;
// 返回蓝底白字的按钮
+ (UIButton *)blueWhitebuttonWithTitle:(NSString *)title
                                Target:(id)target
                                Action:(SEL)selector
                                 Frame:(CGRect)rect;

// 返回带箭头符号的button
+ (UIButton *)arrowButtonWithTitle:(NSString *)title
                            Target:(id)target
                            Action:(SEL)selector
                             Frame:(CGRect)rect
                       Orientation:(eLongArrowOrientation)Orientation;

// 返回带图标带文字的统一规格的按钮
+ (UIButton *)uniformButtonWithTitle:(NSString *)title
                           ImagePath:(NSString *)path
                              Target:(id)target
                              Action:(SEL)selector
                               Frame:(CGRect)rect;

// 返回在底部bar上统一规格按钮
+ (UIButton *)uniformBottomButtonWithTitle:(NSString *)title
                                 ImagePath:(NSString *)path
                                    Target:(id)target
                                    Action:(SEL)selector
                                     Frame:(CGRect)rect;

// 返回统一的更多按钮
+ (UIButton *)uniformMoreButtonWithTitle:(NSString *)title 
                                  Target:(id)target 
                                  Action:(SEL)selector
                                   Frame:(CGRect)rect;

//由颜色返回button大小的的UIImage
- (UIImage *) buttonImageFromColor:(UIColor *)color;

@end
