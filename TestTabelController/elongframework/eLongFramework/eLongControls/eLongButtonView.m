//
//  ButtonView.m
//  ElongClient
//
//  Created by haibo on 11-12-22.
//  Copyright 2011 elong. All rights reserved.
//

#import "eLongButtonView.h"


@implementation eLongButtonView

@synthesize isSelected;
@synthesize canCancelSelected;
@synthesize sectionNum;
@synthesize delegate;


- (void)dealloc {
    delegate = nil;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        isSelected			= NO;
        canCancelSelected	= YES;
        sectionNum			= -1;
    }
    
    return self;
}


- (void)setIsSelected:(BOOL)animated {
    if (animated) {
        isSelected = animated;
        if (delegate && [delegate respondsToSelector:@selector(ButtonViewIsPressed:)]) {
            [delegate ButtonViewIsPressed:self];
        }
    }
    else if (!animated && canCancelSelected) {
        isSelected = animated;
        if (delegate && [delegate respondsToSelector:@selector(ButtonViewIsPressed:)]) {
            [delegate ButtonViewIsPressed:self];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //	self.isSelected = !self.isSelected;
    [self setIsSelected:!self.isSelected];
}




//此处如果不重写，会有崩溃的问题
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


@end