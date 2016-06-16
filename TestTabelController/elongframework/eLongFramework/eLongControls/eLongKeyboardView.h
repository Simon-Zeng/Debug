//
//  KeyboardView.h
//  Keybord
//
//  Created by Wang Shuguang on 12-8-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class eLongCustomTextField;
@interface eLongKeyboardView : UIView {
@private
	eLongCustomTextField __weak *targetTextView;
	BOOL backspaceDown;
	NSInteger backspaceCount;

	UIView *abcKeyboard;
	BOOL isUpperCase;
	BOOL isUpperCaseDown;
	UIButton *upperCaseBtn;
	UIButton *abcBtn;
}

@property (nonatomic, weak) eLongCustomTextField *targetTextView;
@property (nonatomic) BOOL abcEnabled;
@property (nonatomic) BOOL isBackToSystermKey;
@property (nonatomic) BOOL showWordKeyboard;	

@end
