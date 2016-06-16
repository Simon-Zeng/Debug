//
//  eLongJHotelOrderHistory.h
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJHotelOrderHistory : NSObject {
	NSMutableDictionary *contents;
	NSInteger pageIndex;
}

-(void)clearBuildData;

-(void)nextPage;
-(void)prePage;     //上一页
- (void)setPageZero;             // 页数归零
- (NSString *)javaRequestString;
-(void)setHalfYear;
-(void)setOneYear;
-(void)setPageSize:(int)aPageSize;

- (NSDictionary *)requestDic;

@end
