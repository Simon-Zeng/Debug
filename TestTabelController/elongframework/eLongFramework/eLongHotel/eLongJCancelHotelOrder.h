//
//  eLongJCancelHotelOrder.h
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJCancelHotelOrder : NSObject {
	NSMutableDictionary *contents;
}


-(void)clearBuildData;
-(void)setOrderNo:(id)orderNo;
- (NSString *)javaRequestString;
- (NSDictionary *)requestDic;
@end
