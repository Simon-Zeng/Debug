//
//  eLongCalendarWeekFlagView.m
//  TestCalendar
//
//  Created by top on 15/9/21.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import "eLongCalendarWeekFlagView.h"
#import "eLongCalendarDefine.h"

@implementation eLongCalendarWeekFlagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    self.backgroundColor = [UIColor colorWithWhite:0.965 alpha:1.000];
    NSArray *weekFlags = @[ @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六" ];
    float cSpan = (self.bounds.size.width - 20) / weekFlags.count;
    [weekFlags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(cSpan*idx+10, 0, cSpan, CGRectGetHeight(self.bounds))];
        tempLabel.text = obj;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.font = [UIFont systemFontOfSize:11.0];
        if (idx == 0 || idx == 6) {
            tempLabel.textColor = ELC_CELL_SELECT_BACKCOLOR;
        } else {
            tempLabel.textColor = ELC_CELL_DATE_COLOR;
        }
        tempLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tempLabel];
    }];
}

@end
