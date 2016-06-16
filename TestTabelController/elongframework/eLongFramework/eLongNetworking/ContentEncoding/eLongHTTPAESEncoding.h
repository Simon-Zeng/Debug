//
//  eLongHTTPAESEncoding.h
//  eLongNetworking
//
//  Created by Dawn on 14-12-1.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongHTTPContentEncoding.h"

@interface eLongHTTPAESEncoding : NSObject

- (NSString *)encryptString:(NSString *)string byKey:(NSString *)key;
@end
