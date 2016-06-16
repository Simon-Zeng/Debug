//
//  eLongBlockUIAlertView.m
//  eLongFramework
//
//  Created by zhaoyan on 15/7/13.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongBlockUIAlertView.h"

@implementation eLongBlockUIAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        buttonBlock:(ButtonBlock)block {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self != nil) {
        self.block = block;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _block(buttonIndex);
}

@end
