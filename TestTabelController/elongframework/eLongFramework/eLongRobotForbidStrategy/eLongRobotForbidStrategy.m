//
//  eLongRobotForbidStrategy.m
//  eLongFramework
//
//  Created by Dean on 15/6/29.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongRobotForbidStrategy.h"
#import "UIImageView+WebCache.h"
#import "eLongNetworkRequest.h"
#import "eLongDefine.h"
#import "eLongCONST.h"
#import "UIImageView+Extension.h"
#import "UIButton+eLongExtension.h"
#import "eLongAlertView.h"
#import "UIView+LY.h"

#define kELong_ROBOTFORBID_TAG 5110

@interface eLongRobotForbidStrategy ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIButton *codeImageBtn;
@property (nonatomic, copy) NSString *url;
@end

@implementation eLongRobotForbidStrategy
- (void) dealloc
{
    [self removeKeyBoardNotification];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addKeyBoardNotification
{
    //添加键盘监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyBoardNotification
{
    //移除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil
     ];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil
     ];
}



- (void)showCheckCodeViewWithURL:(NSString *)url{
    if ([[self mainWindow] viewWithTag:kELong_ROBOTFORBID_TAG]) {
        return;
    }
    
    self.url = url;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.0f;
    self.tag = kELong_ROBOTFORBID_TAG;
    [[self mainWindow] addSubview:self];
    
    // content view 内容页
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 160)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.alpha = 0.0f;
    self.contentView.userInteractionEnabled = YES;
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [[self mainWindow] addSubview:self.contentView];
    
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 50)];
    tipsLbl.textAlignment = NSTextAlignmentCenter;
    tipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    tipsLbl.font = [UIFont systemFontOfSize:16];
    tipsLbl.text = @"您的请求过于频繁，请输入验证码！";
    [self.contentView addSubview:tipsLbl];
    
    [self.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 50, self.contentView.frame.size.width, SCREEN_SCALE)]];
    
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, self.contentView.frame.size.width - 20 - 20 - 88, 44)];
    self.codeField.borderStyle = UITextBorderStyleNone;
    self.codeField.placeholder = @"验证码";
    //self.codeField.delegate = self;
    self.codeField.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeField.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.contentView addSubview:self.codeField];
    
    [self.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 50 + 44, self.contentView.frame.size.width, SCREEN_SCALE)]];
    
    self.codeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.codeImageBtn.frame = CGRectMake(self.contentView.frame.size.width - 88, 50, 88, 44);
    [self.contentView addSubview:self.codeImageBtn];
    [self.codeImageBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] forState:UIControlStateNormal];
    [self.codeImageBtn addTarget:self action:@selector(codeImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn = [UIButton yellowWhitebuttonWithTitle:@"确定" Target:self Action:@selector(checkBtnClick:) Frame:CGRectMake(20, self.contentView.frame.size.height - 50, self.contentView.frame.size.width - 40, 40)];
    [self.contentView addSubview:btn];
    
    // 手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.6;
        self.contentView.alpha = 1.0f;
    }];
    
    [self addKeyBoardNotification];
    
    [self.codeField becomeFirstResponder];
}

- (void)codeImageBtnClick:(id)sender{
    [self.codeImageBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]]] forState:UIControlStateNormal];
}

- (void)checkBtnClick:(id)sender{
    if (!STRINGHASVALUE(self.codeField.text)) {
        [eLongAlertView showAlertQuiet:@"验证码不能为空"];
        return;
    }
    //    [[TokenReq shared] setCheckCode:self.codeField.text];
    
    // 新的网络框架赋值
    [eLongNetworkRequest sharedInstance].checkCode = self.codeField.text;
    [self close];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ELONG_ROBOTFORBIDACTION object:nil];
}

- (void)close{
    [self.codeField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeKeyBoardNotification];
        [self.contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark -- UITextFieldDelegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


#pragma mark -- UIKeyboardNotication method
-(void) keyboardWillShow:(NSNotification *)notification
{
    // get keyboard size and loctaion
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
    
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue: &keyboardBounds];
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.contentView.centerY = (SCREEN_HEIGHT - keyboardBounds.size.height)/2;
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    self.contentView.centerY = SCREEN_HEIGHT/2;
    // commit animations
    [UIView commitAnimations];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    }else {
        return [app keyWindow];
    }
}

@end
