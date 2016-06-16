//
//  eLongHTTPURLEncoding.h
//  eLongNetworking
//
//  Created by Dawn on 14-12-1.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongHTTPURLEncoding : NSObject
- (NSString *) encoding:(NSString *)string;
- (NSString *) decoding:(NSString *)string;
@end
