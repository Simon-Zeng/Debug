//
//  eLongAjustNumButton.m
//  数量增减控件
//
//  Created by dayu on 15/6/4.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "eLongAjustNumButton.h"
#import "NSTimer+Extension.h"

@interface eLongAjustNumButton ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *decreaseBtn;
@property (nonatomic, strong) UIButton *increaseBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *oneLine;
@property (nonatomic, strong) UIView *twoLine;
@property (nonatomic, strong) NSTimer *timer;

/** 文本框内容 */
@property (nonatomic, copy) NSString *currentNum;

@property (nonatomic, assign) BOOL hasError;

@end

@implementation eLongAjustNumButton

+ (eLongAjustNumButton *)ajustNumButtonWithDefaultNum:(CGFloat)defaultNum {
    return [[eLongAjustNumButton alloc] initWithDefaultNum:defaultNum];
}

- (instancetype)initWithDefaultNum:(CGFloat)defaultNum {
    if (self = [super init]) {
        self.maxNum = CGFLOAT_MAX;
        self.minNum = 1;
        self.defaultNum = defaultNum;
        self.increment = 1;
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    return [self initWithDefaultNum:1];
}

- (void)setupViews {
    
    UIColor *lineColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    
    self.frame = CGRectMake(0, 0, 110, 30);
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [lineColor CGColor];
    
    _oneLine = [[UIView alloc] init];
    _oneLine.backgroundColor = lineColor;
    [self addSubview:_oneLine];
    
    _twoLine = [[UIView alloc] init];
    _twoLine.backgroundColor = lineColor;
    [self addSubview:_twoLine];
    
    _decreaseBtn = [[UIButton alloc] init];
    [self setupButton:_decreaseBtn normalImage:@"decrease_normal" diabledImage:@"decrease_disabled"];
    [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    [self setupButton:_increaseBtn normalImage:@"increase_normal" diabledImage:@"increase_disabled"];
    [self addSubview:_increaseBtn];
    
    _textField = [[UITextField alloc] init];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    _textField.text = [NSString stringWithFormat:@"%.0f", self.defaultNum];
    [_textField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textField];
    
    [self commonSetup];
}

- (void)commonSetup {
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    _oneLine.frame = CGRectMake(viewH, 0, 1, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _twoLine.frame = CGRectMake(viewW - viewH, 0, 1, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self commonSetup];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    self.layer.borderColor = [lineColor CGColor];
    _oneLine.backgroundColor = lineColor;
    _twoLine.backgroundColor = lineColor;
}

- (void)setCurrentNum:(NSString *)currentNum {
    if ([currentNum integerValue] < self.minNum) {
        currentNum = [NSString stringWithFormat:@"%.0f", self.defaultNum];
    }
    _textField.text = currentNum;
}

- (void)setAllowInputNum:(BOOL)allowInputNum {
    _allowInputNum = allowInputNum;
    self.textField.userInteractionEnabled = allowInputNum;
}

- (NSString *)currentNum {
    return _textField.text;
}

- (void)setMinNum:(CGFloat)minNum {
    _minNum = minNum;
    NSLog(@"currentNum = %@ minNum = %@", self.currentNum, @(self.minNum));
    _decreaseBtn.enabled = _decreaseBtn.enabled ? ([self.currentNum doubleValue] > self.minNum) : NO;
}

- (void)setMaxNum:(CGFloat)maxNum {
    _maxNum = maxNum;
    _increaseBtn.enabled = _increaseBtn.enabled ? ([self.currentNum doubleValue] < self.maxNum) : NO;
}

- (void)setIncrement:(CGFloat)increment {
    _increment = increment;
    _increaseBtn.enabled = _increaseBtn.enabled ? (([self.currentNum doubleValue] + increment) <= self.maxNum) : NO;
    _decreaseBtn.enabled = _decreaseBtn.enabled ? (([self.currentNum doubleValue] - increment) <= self.minNum) : NO;
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage diabledImage:(NSString *)highImage {
    [btn setImage:[self readImageFromBundle:norImage] forState:UIControlStateNormal];
    [btn setImage:[self readImageFromBundle:highImage] forState:UIControlStateDisabled];
    btn.adjustsImageWhenHighlighted = NO;
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel];
}

- (void)btnTouchDown:(UIButton *)btn {
    _hasError = NO;
    [_textField resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    if (btn == _increaseBtn) {
        _timer = [NSTimer eLongScheduledTimerWithTimeInterval:0.2 block:^{
            [weakSelf increase];
        } repeats:YES];
    } else {
        _timer = [NSTimer eLongScheduledTimerWithTimeInterval:0.2 block:^{
            [weakSelf decrease];
        } repeats:YES];
    }
    [_timer fire];
}

- (void)btnTouchUp:(UIButton *)btn {
    _hasError = NO;
    [self cleanTimer];
}

- (void)increase {
    if (_textField.text.length == 0) {
        _textField.text = [NSString stringWithFormat:@"%.0f", self.defaultNum];
    }
    CGFloat newNum = [_textField.text doubleValue] + self.increment;
    _decreaseBtn.enabled = newNum > self.minNum;
    if (newNum < self.maxNum) {
        _textField.text = [NSString stringWithFormat:@"%.0f", newNum];
        if (self.completionHandler) {
            self.completionHandler(_textField.text);
        }
        _increaseBtn.enabled = (newNum + self.increment) <= self.maxNum;
    }else {
        _increaseBtn.enabled = NO;
        if (newNum == self.maxNum) {
            _textField.text = [NSString stringWithFormat:@"%.0f", newNum];
            if (self.completionHandler) {
                self.completionHandler(_textField.text);
            }
        }else {
            if (self.errorHandler && !_hasError) {
                NSLog(@"num can not more than %.0f", self.maxNum);
                self.errorHandler(eLongAjustNumErrorMoreThanMax);
                _hasError = YES;
            }
        }
    }
}

- (void)decrease {
    if (_textField.text.length == 0) {
        _textField.text = [NSString stringWithFormat:@"%.0f", self.defaultNum];
    }
    CGFloat newNum = [_textField.text floatValue] - self.increment;
    _increaseBtn.enabled = newNum < self.maxNum;
    if (newNum > self.minNum) {
        _textField.text = [NSString stringWithFormat:@"%.0f", newNum];
        if (self.completionHandler) {
            self.completionHandler(_textField.text);
        }
        _decreaseBtn.enabled = (newNum - self.increment) >= self.minNum;
    } else {
        _decreaseBtn.enabled = NO;
        if (newNum == self.minNum) {
            _textField.text = [NSString stringWithFormat:@"%.0f", newNum];
            if (self.completionHandler) {
                self.completionHandler(_textField.text);
            }
        }else {
            if (self.errorHandler && !_hasError) {
                NSLog(@"num can not less than %.0f", self.minNum);
                self.errorHandler(eLongAjustNumErrorLessThanMin);
                _hasError = YES;
            }
        }
    }
}

- (UIImage *)readImageFromBundle:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"eLongAdjustNumButton.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *(^getBundleImage)(NSString *) = ^(NSString *n) {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:n ofType:@"png"]];
    };
    UIImage *myImg = getBundleImage(imageName);
    return myImg;
}

- (void)dealloc {
    [self cleanTimer];
}

- (void)cleanTimer {
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 
- (void)textFieldTextDidChange:(UITextField *)textField {
    if (textField == _textField) {
        NSString *text = textField.text;
        CGFloat maxLength = [NSString stringWithFormat:@"%.0f", self.maxNum].length;
        CGFloat currentNum = [text doubleValue];
        text = [NSString stringWithFormat:@"%.0f", currentNum];
        if ([text integerValue] > self.maxNum) {
            if (text.length > maxLength) {
                textField.text = [text substringToIndex:maxLength];
            }else {
                textField.text = [text substringToIndex:maxLength-1];
            }
        }else {
            textField.text = text;
        }
        if (textField.text.length == 0 || [textField.text integerValue] < self.minNum || [textField.text integerValue] > self.maxNum) {
            textField.text = [NSString stringWithFormat:@"%.0f", self.defaultNum];
        }
        self.increaseBtn.enabled = ([textField.text integerValue] < self.maxNum);
        self.decreaseBtn.enabled = ([textField.text integerValue] > self.minNum);
    }
}
@end
