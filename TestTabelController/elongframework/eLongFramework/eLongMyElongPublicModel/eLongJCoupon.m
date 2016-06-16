//
//  eLongJCoupon.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongJCoupon.h"
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"


@implementation eLongJCoupon

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
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


-(NSString *)requesCounponString:(BOOL)iscompress{
    [contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
	return [NSString stringWithFormat:@"action=GetCouponDetailList&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

- (NSString *)javaRequestActivedCouponString{
    [contents removeObjectForKey:@"Header"];
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}
	
@end
