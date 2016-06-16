//
//  NSNumber+eLongExtension.m
//  Pods
//
//  Created by chenggong on 15/6/4.
//
//

#import "NSNumber+eLongExtension.h"

@implementation NSNumber (eLongExtension)

- (NSString *)roundNumberToString {
    if ([self isKindOfClass:[NSNumber class]]) {
        int num =  (int)round([self floatValue]);
        return [NSString stringWithFormat:@"%d",num];
    }
    else {
        return @"null";
    }
}


- (NSInteger)safeIntValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self intValue];
    }
    
    return 0;
}


- (CGFloat)safeFloatValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self floatValue];
    }
    
    return 0.0f;
}


- (CGFloat)safeDoubleValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self doubleValue];
    }
    
    return 0.0f;
}


- (BOOL)safeBoolValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return [self boolValue];
    }
    
    return FALSE;
}

@end
