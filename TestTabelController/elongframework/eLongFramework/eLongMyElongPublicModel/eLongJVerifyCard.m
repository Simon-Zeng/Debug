//
//  eLongJVerifyCard.m
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJVerifyCard.h"
#import "JSONKit.h"
#import "eLongExtension.h"


@implementation eLongJVerifyCard
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:@"" forKey:@"CreditCardNo"];
		[contents safeSetObject:@"" forKey:@"VerifyCode"];
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


-(NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=VerifyCreditCard&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}


@end
