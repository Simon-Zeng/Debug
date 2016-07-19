//
//  NSString+NumberMore.m
//  TestTabelController
//
//  Created by wzg on 16/7/15.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "NSString+NumberMore.h"
static NSString * const nums = @"一二三四五六七八九十";
static NSString * const measures = @"十百千万亿";
@implementation NSString (NumberMore)

- (NSString *)subToString:(NSString *)string
{
    if (!string.length) return nil;
    NSRange range = [self rangeOfString:string];
    if (range.location == NSNotFound) return nil;
    if (range.location > self.length) return nil;
    NSString *str = [self substringToIndex:range.location];
    return str;
}

+ (NSString *)transformToStringFromNum:(NSUInteger)num
{
    if (num == 0) return nil;
    NSString *str;
    if (num / 10 >= 1) {
        NSString *numStr1 = [nums substringWithRange:NSMakeRange(num%10 - 1,1)];
        NSString *numStr2 = [nums substringWithRange:NSMakeRange(num/10 - 1,1)];
        if ([numStr2 isEqualToString:@"一"]) {
            str = [NSString stringWithFormat:@"十%@",numStr1];
        }else{
            str = [NSString stringWithFormat:@"%@十%@",numStr2,numStr1];
        }
        
    }else{
        NSString *numStr = [nums substringWithRange:NSMakeRange(num-1,1)];
        str = numStr;
    }
    return str;
}

- (NSString *)removeTheZeroBehindPoint
{
    NSArray *arr = [self componentsSeparatedByString:@"."];
    if (!arr) return nil;
    if (arr.count<=1) return nil;
    NSString *behiendPoint = arr[1];
    if (behiendPoint.integerValue%10 == 0) {
        [behiendPoint stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    return [NSString stringWithFormat:@"%@%@",arr[0],behiendPoint];
}

-(NSString *)removeFloatAllZero
{
    NSString *result;
    if (self.doubleValue >= 1) {
        NSArray *arr = [self componentsSeparatedByString:@"."];
        if (arr.count > 1) {
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];
            if (str2.length) {
                if (str2.integerValue > 10) {
                    if (str2.integerValue % 10 == 0) {
                        result = [NSString stringWithFormat:@"%@.%@",str1,[str2 stringByReplacingOccurrencesOfString:@"0" withString:@""]];
                    }else{
                        result = [NSString stringWithFormat:@"%@.%@",str1,str2];
                    }
                }else{
                    if (!str2.integerValue) {
                        result = [NSString stringWithFormat:@"%@",str1];
                    }else{
                        result = [NSString stringWithFormat:@"%@.%@",str1,str2];
                    }
                }
            }else{
                result = [NSString stringWithFormat:@"%@",str1];
            }
        }else{
            
        }
    }
    return result;
}

-(NSString *)removeFloatAllZeroBothBeforeAndBehind
{
    NSString *result;
    if (self.doubleValue >= 1) {
        NSArray *arr = [self componentsSeparatedByString:@"."];
        if (arr.count > 1) {
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];
            if (str2.length) {
                if (str2.integerValue > 10) {
                    if (str2.integerValue % 10 == 0) {
                        result = [NSString stringWithFormat:@"%@.%@",str1,[str2 stringByReplacingOccurrencesOfString:@"0" withString:@""]];
                    }else{
                        result = [NSString stringWithFormat:@"%@.%@",str1,str2];
                    }
                }else{
                    if (!str2.integerValue) {
                        result = [NSString stringWithFormat:@"%@",str1];
                    }else{
                        result = [NSString stringWithFormat:@"%@.%@",str1,str2];
                    }
                }
            }else{
                result = [NSString stringWithFormat:@"%@",str1];
            }
        }else{
            
        }
    }else{
        result = self;
    }
    return result;
}

/**
 校验金额
 */
- (BOOL)checkMoneyNum:(NSString *)moneyNum withMoneyCount:(int)count decimalCount:(int)decimalCount{
    
    NSString *regex1 =  [NSString stringWithFormat:@"^([0]|[1-9]\\d{0,%d})(\\.\\d{0,%d})?$",count,decimalCount];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch = [pred evaluateWithObject:moneyNum];
    if (!isMatch) {
        return NO;
    }
    return YES;
}


#pragma mark - 限制第三方键盘输入非数字限制
- (BOOL)validateExpandNum:(NSString *)num
{
    NSString *emailRegex = @"^[0-9]+(\\.[0-9]+)?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:num];
}
- (BOOL)validateExpandNSUInteger:(NSString *)num //只能输入非负整数
{
    NSString *emailRegex = @"^[1-9][0-9]*|0$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:num];
}

- (BOOL)checkNum:(NSString *)str
{
    //    NSString *regex = @"^[1-9][0-9]*{9}+(.\[0-9]{2})?$";
    NSString *regex1 =  @"^[0-9]+(\\.[0-9]{1,2})?$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        return NO;
    }
    return YES;
}
@end
