//
//  eLongCalendarMonthModel.h
//  TestCalendar
//
//  Created by top on 15/9/18.
//  Copyright © 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongCalendarMonthModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger year;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger weeks;

@property (nonatomic, strong) NSArray *days;

@end
