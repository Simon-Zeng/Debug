//
//  eLongCalendarHeaderReusableView.m
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import "eLongCalendarHeaderReusableView.h"
#import "eLongCalendarDefine.h"
#import "UIView+LayoutMethods.h"
#import "UIColor+eLongExtension.h"

@interface eLongCalendarHeaderReusableView ()

@end

@implementation eLongCalendarHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height-20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.textColor = ELC_CELL_DATE_COLOR;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, ELC_SCREEN_WIDTH, ELC_SCREEN_SCALE)];
    _splitView.backgroundColor = [UIColor colorWithHexStr:@"#ebebeb"];
    [self addSubview:_splitView];
}

@end
