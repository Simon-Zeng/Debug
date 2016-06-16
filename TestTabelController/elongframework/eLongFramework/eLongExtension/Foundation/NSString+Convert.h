//
//  NSString+Convert.h
//  MyElong
//
//  Created by yangfan on 15/6/18.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)
/**
 *  全角转换为半角
 *
 *  @param originalString 原始全角字符串
 *
 *  @return 半角字符串
 */
-(NSString *)convertFullWidthToHalfWidth:(NSString *)originalString;

/**
 *  半角转换为全角
 *
 *  @param originalString 原始半角字符串
 *
 *  @return 全角字符串
 */
-(NSString *)convertHalfWidthToFullWidth:(NSString *)originalString;

@end
