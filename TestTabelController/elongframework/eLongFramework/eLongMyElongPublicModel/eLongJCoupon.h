//
//  eLongJCoupon.h
//  ElongClient
//
//  Created by bin xing on 11-2-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJCoupon : NSObject {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
- (NSString *)javaRequestActivedCouponString;
-(NSString *)requesCounponString:(BOOL)iscompress;
@end
