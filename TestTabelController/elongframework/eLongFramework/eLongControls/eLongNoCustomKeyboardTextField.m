//
//  eLongNoCustomKeyboardTextField.m
//  MyElong
//
//  Created by yongxue on 15/11/19.
//  Copyright © 2015年 lvyue. All rights reserved.
//

#import "eLongNoCustomKeyboardTextField.h"

@interface eLongNoCustomKeyboardTextField ()

- (UIImage *)stretchableImageWithPath:(NSString *)path;
- (UIImage *)noCacheImageNamed:(NSString *)name;

@end

@implementation eLongNoCustomKeyboardTextField
@synthesize numberOfCharacter;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initate {
    numberOfCharacter = -1;
    
    // 监听text变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

#pragma mark - notifications
- (void)textChanged:(NSNotification *)notification {
    [self dealTextLenght];
}

- (void)dealTextLenght {
    if (self.numberOfCharacter == -1) {
        return;
    }
    
    if([[self text] length] > self.numberOfCharacter) {
        self.text = [self.text substringToIndex:self.numberOfCharacter];
    }
}

#pragma mark params setMethod
- (void)setText:(NSString *)text {
    [super setText:text];
    [self dealTextLenght];
}

- (void) resetTargetKeyboard{
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initate];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initate];
    }
    
    return self;
}

- (void)showWordKeyboard {
}

- (void)showNumKeyboard{
}

- (UIImage *)noCacheImageNamed:(NSString *)name {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    
    return image;
}

- (UIImage *)stretchableImageWithPath:(NSString *)path {
    UIImage *stretchImg = [self noCacheImageNamed:path];
    return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
                                           topCapHeight:stretchImg.size.height / 2];
}

@end
