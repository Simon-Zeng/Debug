//
//  NSString+NumberMore.h
//  TestTabelController
//
//  Created by wzg on 16/7/15.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NumberMore)

/**
 *  截取到某个字符
 */
- (NSString *)subToString:(NSString *)string;
/**
 *  将1~20转换成一,二...
 */
+ (NSString *)transformToStringFromNum:(NSUInteger)num;
/**
 *  移除小数点后的补位零
 */
- (NSString *)removeTheZeroBehindPoint;

/**
 校验金额
 */
- (BOOL)checkMoneyNum:(NSString *)moneyNum withMoneyCount:(int)count decimalCount:(int)decimalCount;
/**
 *  检验数字
 */
- (BOOL)validateExpandNum:(NSString *)num;

- (BOOL)validateExpandNSUInteger:(NSString *)num; //只能输入非负整数

- (BOOL)checkNum:(NSString *)str;

/**
 *  移除零
 */
-(NSString *)removeFloatAllZeroBothBeforeAndBehind;
@end
