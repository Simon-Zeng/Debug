//
//  eLongHTTPURLEncoding.m
//  eLongNetworking
//
//  Created by Dawn on 14-12-1.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPURLEncoding.h"

@implementation eLongHTTPURLEncoding
- (NSString *)encoding:(NSString *)string{
    CFStringRef cfResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                   (CFStringRef)string,
                                                                   NULL,
                                                                   CFSTR("&=@;!'*#%-,:/()<>[]{}?+ "),
                                                                   kCFStringEncodingUTF8);
    
    if (cfResult) {
        NSString *result = [NSString stringWithString:(__bridge NSString *)cfResult];
        CFRelease(cfResult);
        return result;
    }
    return @"";
}

- (NSString *)decoding:(NSString *)string{
    NSString *result = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)string,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}
@end
