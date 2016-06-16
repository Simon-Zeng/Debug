//
//  CustomTextField.h
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eLongCustomTextFieldKeyboardTypeDefault,    // 默认字符键盘
    eLongCustomTextFieldKeyboardTypeNumber      // 数字键盘
}eLongCustomTextFieldKeyboardType;   // 键盘类型

@class eLongKeyboardView;
@interface eLongCustomTextField : UITextField {
    
@private
	NSInteger numberOfCharacter;
    
}

@property (nonatomic) BOOL abcEnabled;
@property (nonatomic) BOOL abcToSystemKeyboard;			// 按abc切回系统键盘
@property (nonatomic) NSInteger numberOfCharacter;
@property (nonatomic) eLongCustomTextFieldKeyboardType fieldKeyboardType;     // 键盘类型
@property (nonatomic,strong) UIColor *placeholderColor; //placeHolder颜色 不设置为默认

- (void)changeKeyboardStateToSysterm:(BOOL)animated;	// 转换为系统键盘
- (void)showWordKeyboard;								// 展示字母键盘
- (void)resetTargetKeyboard;
- (void)showNumKeyboard;

@end

