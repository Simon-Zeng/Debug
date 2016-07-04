//
//  NSString+Extension.m
//  TestTabelController
//
//  Created by wzg on 16/6/30.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)safeString
{
    return self == nil? @"":self;
}

@end
