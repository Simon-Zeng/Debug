//
//  eLongJDeleteCard.m
//  ElongClient
//
//  Created by WangHaibin on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJDeleteCard.h"
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"

@implementation eLongJDeleteCard
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:@"" forKey:@"CreditCardNo"];
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


-(NSMutableDictionary *)getCard{
	
	NSMutableDictionary *card=[[NSMutableDictionary alloc] initWithDictionary:contents copyItems:YES];
	[card removeObjectForKey:@"Header"];
	return [card mutableCopy];
	
}

-(void)setCreditCardNo:(NSString *)string{
	[contents safeSetObject:string forKey:@"CreditCardNo"];
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *cardDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([cardDic  safeObjectForKey:@"Header"]) {
        [cardDic removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:cardDic];
    
}

@end
