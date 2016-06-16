//
//  eLongJDeleteCustomer.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJDeleteCustomer : NSObject {
    NSMutableDictionary *contents;
}
- (void)clearBuildData;
- (void)setCustomerId:(NSInteger)customerId;
- (NSString *)requesString:(BOOL)iscompress;
- (NSDictionary *)requesDict:(BOOL)iscompress;
@end
