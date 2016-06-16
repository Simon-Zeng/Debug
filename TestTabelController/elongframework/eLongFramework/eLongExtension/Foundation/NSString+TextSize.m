//
//  NSString+eLongTextSize.m
//  InterHotel
//
//  Created by Dean on 15/6/3.
//  Copyright (c) 2015年 eLong. All rights reserved.
//

#import "NSString+TextSize.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@implementation NSString (TextSize)

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize font:font];
}

- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont *)font  {
    CGSize resultSize;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        resultSize = [self sizeWithFont:font
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByTruncatingTail];
    } else {
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGRect rect = [self boundingRectWithSize:size
                                         options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading)
                                      attributes:attrs
                                         context:nil];
        resultSize = rect.size;
        resultSize = CGSizeMake(ceil(resultSize.width), ceil(resultSize.height));
    }
    return resultSize;
}

- (BOOL)isNotEmpty
{
    return (self != nil && [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [self isKindOfClass:[NSString class]]);
}

- (BOOL)isEmptyOrNull
{
    BOOL isEmptyOrNull = YES;
    if (![self isEqual:[NSNull null]] && self != nil && self.length != 0) {
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [self componentsSeparatedByString:@" "];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        NSString *weakSelf = [filteredArray componentsJoinedByString:@""];
        if (weakSelf.length > 0) {
            isEmptyOrNull = NO;
        }
    }
    return isEmptyOrNull;
}


- (NSUInteger)wordsCount
{
    NSUInteger i,n = [self length], l = 0, a = 0, b = 0;
    unichar c;
    for(i = 0;i < n; i++)
    {
        c = [self characterAtIndex:i];
        if(isblank(c))
        {
            b++;
        }else if(isascii(c))
        {
            a++;
        }else{
            l++;
        }
    }
    if(a == 0 && l == 0) return 0;
    return l + (int)ceilf((float)(a + b) / 2.0);
}

- (int)byteSize
{//4E00-9FBF
    int length = 0;
    for (int i = 0; i < self.length; i++){
        const unichar a = [self characterAtIndex:i];
        if ((int)a >= 0x4E00 && (int)a <= 0x9FBF) {
            length +=2;
        }
        else{
            length +=1;
        }
    }
    return length;
}
@end
