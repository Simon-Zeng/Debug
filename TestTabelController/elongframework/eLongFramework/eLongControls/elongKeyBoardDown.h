//
//  elongKeyBoardDown.h
//  keyBoard_Demo
//
//  Created by guanghui.wang on 15/7/23.
//  Copyright (c) 2015年 guanghui.wang. All rights reserved.
//
#import "UIColor+eLongExtension.h"
#import <UIKit/UIKit.h>

@interface elongKeyBoardDown : UIView
+ (void)addToTextView:(id<UITextInput>)textView;
+ (void)addToTextView:(id<UITextInput>)textView withBounds:(CGRect)bounds;
@end



// 用法：[elongKeyBoardDown addToTextView:companyTF withBounds:CGRectMake(UI_SCREEN_WIDTH-45, 0, 40, 25)];