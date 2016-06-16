//
//  NSNumber+eLongExtension.h
//  Pods
//
//  Created by chenggong on 15/6/4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (eLongExtension)

// 返回对浮点数四舍五入之后的字符串
- (NSString *)roundNumberToString;

// 加了容错的intValue方法，如果有异常，返回0
- (NSInteger)safeIntValue;

// 加了容错的floatValue、doubleValue方法，如果有异常，返回0.0
- (CGFloat)safeFloatValue;
- (CGFloat)safeDoubleValue;

// 加了容错的boolValue方法，如果有异常，返回FALSE
- (BOOL)safeBoolValue;

@end
