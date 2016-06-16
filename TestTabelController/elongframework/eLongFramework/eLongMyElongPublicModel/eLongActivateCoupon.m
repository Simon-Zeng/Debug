//
//  eLongActivateCoupon.m
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongActivateCoupon.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongActivateCoupon
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"CouponCode"];
		[contents safeSetObject:@"" forKey:@"CouponPassWord"];
		
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

-(void)setCouponCode:(NSString *)string{
	return [contents safeSetObject:string forKey:@"CouponCode"];
}

-(void)setCouponPassWord:(NSString *)string{
	return [contents safeSetObject:string forKey:@"CouponPassWord"];
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
	return [NSString stringWithFormat:@"action=ActivateCoupon&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
