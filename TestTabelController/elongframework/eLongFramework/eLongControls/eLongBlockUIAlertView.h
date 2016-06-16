//
//  eLongBlockUIAlertView.h
//  eLongFramework
//
//  Created by zhaoyan on 15/7/13.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(NSInteger);

@interface eLongBlockUIAlertView : UIAlertView

@property(nonatomic,copy)ButtonBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        buttonBlock:(ButtonBlock)block;

@end
