//
//  eLongLunarCalendar.h
//  TestCalendar
//
//  Created by top on 15/9/14.
//  Copyright (c) 2015年 top. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongLunarCalendar : NSObject

@property (nonatomic, readonly) NSString *dayOfLunar;

@property (nonatomic, readonly) NSString *monthOfLunar;

- (NSString *)dayOfLunarWithDate:(NSDate *)date;

@end
