//
//  elongKeyBoardDown.m
//  keyBoard_Demo
//
//  Created by guanghui.wang on 15/7/23.
//  Copyright (c) 2015年 guanghui.wang. All rights reserved.
//

#import "elongKeyBoardDown.h"
#import "UIView+LY.h"
#define SCREEN_SCALE    (1.0f/[UIScreen mainScreen].scale)
@interface elongKeyBoardDown () <UIInputViewAudioFeedback>
@property (nonatomic, strong) id<UITextInput> textView;
@end
@implementation elongKeyBoardDown
+ (void)addToTextView:(id<UITextInput>)textView
{
    [self addToTextView:textView withBounds:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, 44)];
}
+ (void)addToTextView:(UIResponder<UITextInput> *)textView withBounds:(CGRect)bounds
{
    elongKeyBoardDown *view = [[elongKeyBoardDown alloc] initWithBounds:bounds];
    view.textView = textView;
    [(id)textView setInputAccessoryView:view];
}

- (id)initWithBounds:(CGRect)bounds
{
    if (self = [super init]) {
        self.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
        self.backgroundColor = [UIColor colorWithHexStr:@"#f0f0f0"];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height)];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexStr:@"#426bf2"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self addLineViewForSuperView:self isTop:YES];
        [self addLineViewForSuperView:self isTop:NO];
    }
    return self;
}

- (void)buttonPressed:(UIButton *)btn
{
    [(UITextView*)self.textView resignFirstResponder];
}

- (void)addLineViewForSuperView:(UIView *)superView isTop:(BOOL)isTop
{
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, isTop ? 0 : superView.height - SCREEN_SCALE, [UIScreen mainScreen].bounds.size.width, SCREEN_SCALE)];
    lineView.backgroundColor = [UIColor colorWithHexStr:@"#d3d3d3"];
    [superView addSubview:lineView];
}

@end
