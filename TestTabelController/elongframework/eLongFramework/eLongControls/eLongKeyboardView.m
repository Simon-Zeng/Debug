//
//  KeyboardView.m
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "eLongKeyboardView.h"
#import "eLongCustomTextField.h"
#import <QuartzCore/QuartzCore.h>
#import "eLongDefine.h"
#import "UIImageView+Extension.h"
#import "eLongFileIOUtils.h"

@interface eLongKeyboardView()

- (void)configKeypad;

- (UIImage *)stretchableImageWithPath:(NSString *)path;

- (UIImage *)noCacheImageNamed:(NSString *)name;

- (void)backspaceTimework;

- (void)keytone;

- (void)deleteOneword;

- (void)addOneword:(NSString *)word;

- (void)numBtnSwitch:(id) sender;

@property (nonatomic,assign) CGFloat keyboardHeight;

@end

#define KEYBOARDFONT [UIFont systemFontOfSize:22.0f];

@implementation eLongKeyboardView
@synthesize targetTextView;
@synthesize abcEnabled;
@synthesize isBackToSystermKey;
@synthesize showWordKeyboard;

- (void)dealloc
{
    [eLongKeyboardView cancelPreviousPerformRequestsWithTarget:self selector:@selector(backspaceTimework) object:nil];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(!SCREEN_55_INCH){
            self.keyboardHeight = 226;
        }else{
            self.keyboardHeight = 216;
        }
		self.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, self.keyboardHeight);
		
        // 防止初始化时阻塞页面
		[self configKeypad];
		
    }
    return self;
}

- (void)configKeypad
{
	if (!abcBtn) {
        //键盘背景
        UIImageView *keyboardBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.keyboardHeight)];
        keyboardBg.image = [self noCacheImageNamed:@"keyboard_bg.png"];
        [self addSubview:keyboardBg];

        //数字键
        CGFloat numWidth = SCREEN_WIDTH/3.0;
        CGFloat numHeight = self.keyboardHeight/4.0;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                numBtn.frame = CGRectMake(numWidth * i, numHeight * j, numWidth, numHeight);
                
                [numBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg.png"] forState:UIControlStateNormal];
                [numBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg_h.png"] forState:UIControlStateHighlighted];
                numBtn.titleLabel.font = KEYBOARDFONT;
                [numBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                [numBtn setTitle:[NSString stringWithFormat:@"%d",j*3 + i + 1] forState:UIControlStateNormal];
                
                [self addSubview:numBtn];
                [numBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        //删除键
        UIButton *backspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backspaceBtn.frame = CGRectMake(numWidth * 3/2, numHeight * 3, numWidth/2, numHeight);
        [backspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg_h.png"] forState:UIControlStateNormal];
        [backspaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg.png"] forState:UIControlStateHighlighted];
        [backspaceBtn setImage:[UIImage imageNamed:@"keyboard_num_delete.png"] forState:UIControlStateNormal];
        [self addSubview:backspaceBtn];
        [backspaceBtn addTarget:self action:@selector(backspaceBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [backspaceBtn addTarget:self action:@selector(backspaceBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        //abc
        abcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcBtn.frame = CGRectMake(0, numHeight * 3 , numWidth, numHeight);
        [abcBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg_h.png"] forState:UIControlStateNormal];
        [abcBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg.png"] forState:UIControlStateHighlighted];
        abcBtn.titleLabel.font = KEYBOARDFONT;
        [abcBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [abcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcBtn setTitle:@"ABC" forState:UIControlStateNormal];
        abcBtn.enabled = NO;
        
        [self addSubview:abcBtn];
        
        [abcBtn addTarget:self action:@selector(abcBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        //0
        UIButton *zeroBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zeroBtn.frame = CGRectMake(numWidth,numHeight * 3, numWidth/2, numHeight);
        [zeroBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg.png"] forState:UIControlStateNormal];
        [zeroBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg_h.png"] forState:UIControlStateHighlighted];
        zeroBtn.titleLabel.font = KEYBOARDFONT;
        [zeroBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [zeroBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [zeroBtn setTitle:[NSString stringWithFormat:@"%d",0] forState:UIControlStateNormal];
        [self addSubview:zeroBtn];
        [zeroBtn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //搜索
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(numWidth * 2, numHeight * 3 , numWidth, numHeight);
        [returnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg_b.png"] forState:UIControlStateNormal];
        [returnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_num_bg.png"] forState:UIControlStateHighlighted];
        returnBtn.titleLabel.font = KEYBOARDFONT;
        [returnBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [returnBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:returnBtn];
        [returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 分割线
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, numHeight, SCREEN_WIDTH, SCREEN_SCALE)]];
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, numHeight * 2, SCREEN_WIDTH, SCREEN_SCALE)]];
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, numHeight * 3, SCREEN_WIDTH, SCREEN_SCALE)]];
        [self addSubview:[UIImageView graySplitWithFrame:CGRectMake(numWidth, 0, SCREEN_SCALE, self.keyboardHeight)]];
        [self addSubview:[UIImageView graySplitWithFrame:CGRectMake(numWidth * 2, 0, SCREEN_SCALE, self.keyboardHeight)]];
        [self addSubview:[UIImageView graySplitWithFrame:CGRectMake(SCREEN_WIDTH/2, numHeight * 3, SCREEN_SCALE, numHeight)]];
        
        //abckeyboard
        abcKeyboard = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.keyboardHeight)];
        abcKeyboard.backgroundColor = [UIColor whiteColor];
        abcKeyboard.hidden = YES;
        [self addSubview:abcKeyboard];
        
        //背景图
        UIImageView *abcBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.keyboardHeight)];
        abcBgView.image = [UIImage imageNamed:@"keyboard_bg.png"];
        [abcKeyboard addSubview:abcBgView];
        
        //字母键
        NSArray *oneLineKeys = [NSArray arrayWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",nil];
        NSArray *twoLineKeys = [NSArray arrayWithObjects:@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",nil];
        NSArray *threeLineKeys = [NSArray arrayWithObjects:@"Z",@"X",@"C",@"V",@"B",@"N",@"M",nil];
        NSArray *columKeys = [NSArray arrayWithObjects:oneLineKeys,twoLineKeys,threeLineKeys,nil];
        
        NSInteger columsCount = [columKeys count];
        NSInteger linesCount = 0;
        float leftMargin = 0;
        CGFloat abcLeftMargin = 1;
        CGFloat abcTopMargin = 10;
        CGFloat abcBottomMargin = 1;
        CGFloat abcSpaceW = 2;
        CGFloat abcSpaceH = 8;
        CGFloat abcWidth = (SCREEN_WIDTH - abcLeftMargin * 2 - (oneLineKeys.count - 1) * abcSpaceW)/oneLineKeys.count;
        CGFloat abcHeight = (self.keyboardHeight - abcTopMargin - abcBottomMargin - 3 * abcSpaceH)/4;
        for (int i = 0; i < columsCount; i++) {
            NSArray *line = (NSArray *)[columKeys safeObjectAtIndex:i];
            linesCount = [line count];
            if (i == 0) {
                leftMargin = abcLeftMargin;
            }else if (i == 1) {
                leftMargin = (SCREEN_WIDTH - twoLineKeys.count * abcWidth - (twoLineKeys.count - 1) * abcSpaceW)/2;
            }else if (i == 2) {
                leftMargin = (SCREEN_WIDTH - threeLineKeys.count * abcWidth - (threeLineKeys.count - 1) * abcSpaceW)/2;
            }
            
            for (int j = 0; j < linesCount; j++) {
                UIButton *abcKeyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                abcKeyBtn.frame = CGRectMake(leftMargin + (abcSpaceW + abcWidth) * j, abcTopMargin + i * (abcHeight + abcSpaceH), abcWidth, abcHeight);
                
                [abcKeyBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abckey_one.png"] forState:UIControlStateNormal];
                [abcKeyBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abckey_two.png"] forState:UIControlStateHighlighted];
                [abcKeyBtn setAdjustsImageWhenHighlighted:NO];
                abcKeyBtn.titleLabel.font = KEYBOARDFONT;
                [abcKeyBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                [abcKeyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [abcKeyBtn setTitle:[NSString stringWithFormat:@"%@",[line safeObjectAtIndex:j]] forState:UIControlStateNormal];
                
                [abcKeyboard addSubview:abcKeyBtn];
                [abcKeyBtn addTarget:self action:@selector(abcBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        //大写锁定
        //abc
        upperCaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upperCaseBtn.frame = CGRectMake(abcLeftMargin, abcTopMargin + 2 * (abcHeight + abcSpaceH) , abcHeight, abcHeight);
        [upperCaseBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
        [upperCaseBtn setAdjustsImageWhenHighlighted:NO];
        [upperCaseBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [upperCaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [abcKeyboard addSubview:upperCaseBtn];
        [upperCaseBtn addTarget:self action:@selector(upperCaseDown:) forControlEvents:UIControlEventTouchDown];
        [upperCaseBtn addTarget:self action:@selector(upperCaseUp:) forControlEvents:UIControlEventTouchUpInside];
        
        //退格
        UIButton *abcbackspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcbackspaceBtn.frame = CGRectMake(SCREEN_WIDTH - abcLeftMargin - abcHeight, abcTopMargin + 2 * (abcHeight + abcSpaceH), abcHeight, abcHeight);
        [abcbackspaceBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_delete.png"] forState:UIControlStateNormal];
        [abcbackspaceBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_delete_press.png"] forState:UIControlStateHighlighted];
        [abcKeyboard addSubview:abcbackspaceBtn];
        [abcbackspaceBtn addTarget:self action:@selector(backspaceBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [abcbackspaceBtn addTarget:self action:@selector(backspaceBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        
        //切换为数字键盘
        //abc
        UIButton *numSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numSwitchBtn.frame = CGRectMake(abcLeftMargin, abcTopMargin + 3 * (abcHeight + abcSpaceH) ,(SCREEN_WIDTH - abcWidth * 5 - 6 * abcSpaceW - 2 * abcLeftMargin)/2, abcHeight);
        [numSwitchBtn setBackgroundImage:[self noCacheImageNamed:@"keyboard_numswitch.png"] forState:UIControlStateNormal];
        [numSwitchBtn setBackgroundImage:[self noCacheImageNamed:@"keyboard_numswitch_press.png"] forState:UIControlStateHighlighted];
        numSwitchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [numSwitchBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [numSwitchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [numSwitchBtn setTitle:@"123" forState:UIControlStateNormal];
        [abcKeyboard addSubview:numSwitchBtn];
        [numSwitchBtn addTarget:self action:@selector(numBtnSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //空格
        UIButton *spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        spaceBtn.frame = CGRectMake((SCREEN_WIDTH - 5 * abcWidth - 4 * abcSpaceW)/2 ,abcTopMargin + 3 * (abcHeight + abcSpaceH), 5 * abcWidth + 4 * abcSpaceW, abcHeight);
        [spaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_space.png"] forState:UIControlStateNormal];
        [spaceBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_space_press.png"] forState:UIControlStateHighlighted];
        [abcKeyboard addSubview:spaceBtn];
        [spaceBtn addTarget:self action:@selector(spaceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        spaceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [spaceBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [spaceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [spaceBtn setTitle:@"space" forState:UIControlStateNormal];
        
        
        //确定
        UIButton *abcreturnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        abcreturnBtn.frame = CGRectMake(SCREEN_WIDTH - ((SCREEN_WIDTH - abcWidth * 5 - 6 * abcSpaceW - 2 * abcLeftMargin)/2) - abcLeftMargin, abcTopMargin + 3 * (abcHeight + abcSpaceH) , (SCREEN_WIDTH - abcWidth * 5 - 6 * abcSpaceW - 2 * abcLeftMargin)/2, abcHeight);
        [abcreturnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abcconfirm.png"] forState:UIControlStateNormal];
        [abcreturnBtn setBackgroundImage:[self stretchableImageWithPath:@"keyboard_abcconfirm_press.png"] forState:UIControlStateHighlighted];
        abcreturnBtn.titleLabel.font =[UIFont boldSystemFontOfSize:17.0f];
        [abcreturnBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
        [abcreturnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [abcreturnBtn setTitle:@"Done" forState:UIControlStateNormal];
        [abcKeyboard addSubview:abcreturnBtn];
        [abcreturnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (BOOL)abcEnabled
{
	return abcBtn.enabled;
}

- (void)setAbcEnabled:(BOOL)enabled
{
	abcBtn.enabled = enabled;
}

- (void)setIsBackToSystermKey:(BOOL)animated
{
	abcBtn.enabled = animated;
	isBackToSystermKey = animated;
}

- (void)setShowWordKeyboard:(BOOL)animated
{
	if (animated) {
		abcKeyboard.hidden = NO;
	}else{
        abcKeyboard.hidden = YES;
    }
}

#pragma mark -
#pragma mark 添加删除字符

- (void)addOneword:(NSString *)word
{
	NSRange range;
	range.location = targetTextView.text.length;
	range.length = 0;
	if ([targetTextView.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) ]) {
		if (![targetTextView.delegate textField:targetTextView shouldChangeCharactersInRange:range replacementString:word]) {
			return;
		}
	}
	
	if (targetTextView.text.length >= targetTextView.numberOfCharacter) {
		return;
	}
	targetTextView.text = [NSString stringWithFormat:@"%@%@",targetTextView.text,word];
	
	[self keytone];
}

- (void)deleteOneword
{
	if (targetTextView.text.length == 0) {
		return;
	}
	
	NSRange range;
	range.location = targetTextView.text.length - 1;
	range.length = 1;
	if ([targetTextView.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:) ]) {
		if (![targetTextView.delegate textField:targetTextView shouldChangeCharactersInRange:range replacementString:@""]) {
			return;
		}
	}
	
	targetTextView.text = [targetTextView.text substringToIndex:targetTextView.text.length - 1];
	
	[self keytone];
}

#pragma mark -
#pragma mark 删除键逻辑

- (void)backspaceBtnTouchDown:(id)sender
{
	//复原计数器和标志位
	backspaceDown = YES;
	backspaceCount = 0;
	
	[self deleteOneword];
		
	//延时0.6s后进行连续删除
	[self performSelector:@selector(backspaceTimework) withObject:nil afterDelay:0.6];
}

- (void)backspaceTimework
{
	//按钮抬起后中断连续删除
	if (!backspaceDown) {
		return;
	}
	
	//如果连续删除超过10个字符则全部删除剩余的文字
	if (targetTextView.text.length > 0 && backspaceCount > 10) {
		targetTextView.text = @"";
		//播放声音
		[self keytone];
		return;
	}
	
	[self deleteOneword];
	
	backspaceCount++;
	[self performSelector:@selector(backspaceTimework) withObject:nil afterDelay:0.1];
}

- (void)backspaceBtnTouchUp:(id)sender
{
	backspaceCount = 0;
	backspaceDown = NO;
	//取消计划执行的函数，防止连续点按触发长按效果
	[eLongKeyboardView cancelPreviousPerformRequestsWithTarget:self selector:@selector(backspaceTimework) object:nil];
}

- (void)keytone
{
   // AudioServicesPlayAlertSound(1104);
}

#pragma mark -
#pragma mark 键盘按键事件

//点按确定键
- (void)returnBtnClick:(id)sender
{
	//[targetTextView resignFirstResponder];
	
	if ([targetTextView.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
		[targetTextView.delegate textFieldShouldReturn:targetTextView];
	}
	
	if ([targetTextView.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
		[targetTextView.delegate textFieldDidEndEditing:targetTextView];
	}
	
	//[targetTextView sendActionsForControlEvents:UIControlEventEditingDidEndOnExit];
}

//点按清除键
- (void)clearBtnClick:(id)sender
{
	[targetTextView setText:@""];
}

//点按隐藏键
- (void)hideBtnClick:(id)sender
{
	[targetTextView resignFirstResponder];
}

//切换为字母键盘
- (void)abcBtnSwitch:(id)sender
{
	if (isBackToSystermKey) {
		targetTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		targetTextView.inputView = nil;
		
		[targetTextView resignFirstResponder];
		[targetTextView becomeFirstResponder];
	}
	else {
		abcKeyboard.hidden = NO;
	}
}

//切换为数字键盘
- (void)numBtnSwitch:(id)sender
{
	abcKeyboard.hidden = YES;
}

//点按数字键
- (void)numBtnClick:(id)sender
{
	UIButton *numBtn = (UIButton *)sender;
	[self addOneword:numBtn.titleLabel.text];
	
}

//大写锁定按下
- (void) upperCaseDown:(id)sender
{
	if (isUpperCase) {
		isUpperCase = NO;
		[upperCaseBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
	}else{
		isUpperCase = YES;
		isUpperCaseDown = YES;
		[upperCaseBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_uppercase_press.png"] forState:UIControlStateNormal];
	}
}

//大写锁定放开
- (void) upperCaseUp:(id)sender
{
	isUpperCaseDown = NO;
}

//空格键
- (void) spaceBtnClick:(id)sender
{
	[self addOneword:@" "];
}

//点按字母键
- (void) abcBtnClick:(id)sender
{
	UIButton *switchBtn = (UIButton *)sender;
	
	if (isUpperCaseDown) {
		[self addOneword:switchBtn.titleLabel.text];
	}else {
		if (isUpperCase) {
			[self addOneword:switchBtn.titleLabel.text];
			isUpperCase = NO;
			[upperCaseBtn setBackgroundImage:[UIImage imageNamed:@"keyboard_uppercase.png"] forState:UIControlStateNormal];
		}else {
			[self addOneword:[switchBtn.titleLabel.text lowercaseString]];
		}
	}
}

//图片处理函数
- (UIImage *)noCacheImageNamed:(NSString *)name
{
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	return image;
}

- (UIImage *)stretchableImageWithPath:(NSString *)path
{
	UIImage *stretchImg = [self noCacheImageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}

@end
