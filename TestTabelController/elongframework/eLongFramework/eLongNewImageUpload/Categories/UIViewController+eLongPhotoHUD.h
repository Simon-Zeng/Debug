//
//  UIViewController+HUD.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/2.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (eLongPhotoHUD)

/**
 *  显示一个alert提示框
 *  只显示提示信息,和一个确定按钮
 *  @param title 具体提示的message
 */
- (void)showAlertWithMessage:(NSString *)message;

@end
