//
//  NSString+Convert.m
//  MyElong
//
//  Created by yangfan on 15/6/18.
//  Copyright (c) 2015年 lvyue. All rights reserved.
//

#import "NSString+Convert.h"
#import "eLongDefine.h"

@implementation NSString (Convert)

-(NSString *)convertFullWidthToHalfWidth:(NSString *)originalString{
//    if (IOSVersion_7) {
        NSMutableString*convertedString= [originalString mutableCopy];
        CFStringTransform((CFMutableStringRef)convertedString,NULL,kCFStringTransformFullwidthHalfwidth,false);
        return convertedString;
//    }else{
        //ios 6的API有问题
        //        NSMutableString*convertedString= [originalString mutableCopy];
        //        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //        NSString *trimmedString = [convertedString stringByTrimmingCharactersInSet:set];
        //        return trimmedString;
//        return originalString;
//    }
}

-(NSString *)convertHalfWidthToFullWidth:(NSString *)originalString{
    NSMutableString*convertedString= [originalString mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString,NULL,kCFStringTransformHiraganaKatakana,false);
    return convertedString;
}


@end
