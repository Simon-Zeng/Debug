//
//  eLongNoCustomKeyboardTextField.h
//  MyElong
//
//  Created by yongxue on 15/11/19.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface eLongNoCustomKeyboardTextField : UITextField {
    
}

@property (nonatomic) NSInteger numberOfCharacter;
@property (nonatomic,strong) UIColor *placeholderColor; //placeHolder颜色 不设置为默认

//
- (void)showWordKeyboard;								// 展示字母键盘
- (void)resetTargetKeyboard;
- (void)showNumKeyboard;

@end

