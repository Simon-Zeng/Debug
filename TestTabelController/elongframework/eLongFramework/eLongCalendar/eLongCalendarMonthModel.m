//
//  eLongCalendarMonthModel.m
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright © 2015年 top. All rights reserved.
//

#import "eLongCalendarMonthModel.h"

@implementation eLongCalendarMonthModel

-(NSString *)title {
    return [NSString stringWithFormat:@"%ld年%ld月", (long)self.year, (long)self.month];
}

@end
