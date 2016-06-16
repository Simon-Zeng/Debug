//
//  eLongGraphicsCodeView.m
//  ElongClient
//
//  Created by Janven Zhao on 14/11/8.
//  Copyright (c) 2014年 elong. All rights reserved.
//本类的frame 应是320*44

#import "eLongGraphicsCodeView.h"
#import "eLongEmbedTextField.h"
#import "eLongRoundCornerView.h"
#import "eLongDefine.h"
#import "eLongCustomTextField.h"

@implementation eLongGraphicsCodeView

-(id)initWithFrame:(CGRect)frame andImageURL:(NSString *)checkCodeUrl{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.checkURL = checkCodeUrl;
        
        // 验证码输入框

        _checkCodeField = [[eLongEmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) IconPath:nil Title:nil TitleFont:FONT_16 TitleOffsetX:10 andContentFieldOffx:150];
        
        _checkCodeField.delegate = self;
        
        _checkCodeField.backgroundColor = [UIColor clearColor];
        
        _checkCodeField.textField.textAlignment = NSTextAlignmentLeft;
                
        _checkCodeField.textFont = FONT_16;
        
        _checkCodeField.abcEnabled = YES;
        
        [self addSubview:_checkCodeField];
        
        [_checkCodeField addBottomLineFromPositionX:0 length:_checkCodeField.frame.size.width];
        
        
        //SepLine
        
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(130, 1, 0.51, 41)];
        
        seperateLine.image = [UIImage imageNamed:@"basevc_dashed.png"];
        
        [self addSubview:seperateLine];
        
        
        
        //RoundCornerView
        
        checkCodeImageView = [[eLongRoundCornerView alloc] initWithFrame:CGRectMake(10, 3, 70, 37)];
        
        [self addSubview:checkCodeImageView];
        
        //checkCodeIndicatorView
        
        checkCodeIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [checkCodeImageView addSubview:checkCodeIndicatorView];
        
        [checkCodeIndicatorView setCenter:CGPointMake(checkCodeImageView.frame.size.width/2, checkCodeImageView.frame.size.height/2)];
        
        
        //Fresh Btn
        
        UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        freshBtn.frame = CGRectMake(80, 0, 44, 44);
        
        [freshBtn setImage:[UIImage imageNamed:@"forgetPwd_fresh"] forState:UIControlStateNormal];
        
        [freshBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 12, 10, 13)];
        
        [freshBtn addTarget:self action:@selector(refreshTheGrapicsCode) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:freshBtn];
        
        [self refreshTheGrapicsCode];
        
    }
    return self;
}


-(void)dealloc{
    [_checkCodeField.textField   resignFirstResponder];

    _checkCodeField = nil;
    
    checkCodeImageView = nil;
    
    checkCodeIndicatorView = nil;
    
    self.checkURL = nil;
    self.checkNums = nil;
    
}

#pragma mark

#pragma mark
#pragma mark  Events

-(void)refreshTheGrapicsCode{
    
    if (!STRINGHASVALUE(self.checkURL)) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.checkURL]];
        
        [checkCodeIndicatorView startAnimating];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *newimage = [[UIImage alloc] initWithData:data];
            
            checkCodeImageView.image=newimage;
            
            
            [checkCodeIndicatorView stopAnimating];
            
        });
        
    });
}

-(void)resignTheKeyBorad{
    if (_checkCodeField) {
        [_checkCodeField.textField resignFirstResponder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark
#pragma mark UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *final = [textField.text stringByReplacingCharactersInRange:range withString:string];
    final = [final stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.checkNums = final;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    self.checkNums  = textField.text;
    return YES;
}
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[eLongCustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    _checkCodeField.abcEnabled = YES;
    [_checkCodeField showNumKeyboard];
    return YES;
}

@end
