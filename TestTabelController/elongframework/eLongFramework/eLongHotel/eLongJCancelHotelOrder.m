//
//  eLongJCancelHotelOrder.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongJCancelHotelOrder.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
#import "JSONKit.h"

@implementation eLongJCancelHotelOrder
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
		[contents safeSetObject:[NSNull null] forKey:@"OrderNo"];
	}
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}

-(void)clearBuildData{
	[self buildPostData:YES];
}
-(void)setOrderNo:(id)orderNo{
	[contents safeSetObject:orderNo forKey:@"OrderNo"];
}

- (NSString *)javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
    return [contents JSONString];
}

-(NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance]cardNo] forKey:@"CardNo"];
    return [NSDictionary dictionaryWithDictionary:contents];
}
@end


