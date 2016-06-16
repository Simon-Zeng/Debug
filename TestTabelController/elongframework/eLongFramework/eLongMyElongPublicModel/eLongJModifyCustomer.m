//
//  eLongJModifyCustomer.m
//  ElongClient
//
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJModifyCustomer.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJModifyCustomer

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
//		action=ModifyCustomer&compress=false&req={"Header":{"ChannelId":"1234","DeviceId":"4321","AuthCode":null,"ClientType":1},
//			"CardNO":2000000000158279941,"OperatorName":"333","OperatorIP":"333","Id":123123,"Name":"333",
//			"Sex":"333","PhoneNo":"333","IdType":0,"IdTypeName":null,"IdNumber":"333","Email":"33"}
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
		[contents safeSetObject:@"" forKey:@"OperatorName"];
		[contents safeSetObject:@"" forKey:@"OperatorIP"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"Id"];
		[contents safeSetObject:@"" forKey:@"Name"];
		[contents safeSetObject:@"" forKey:@"Sex"];
		[contents safeSetObject:@"" forKey:@"PhoneNo"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"IdType"];
		[contents safeSetObject:[NSNull null] forKey:@"IdTypeName"];
		[contents safeSetObject:@"" forKey:@"IdNumber"];
		[contents safeSetObject:@"" forKey:@"Email"];
        [contents safeSetObject:@"" forKey:@"BirthDay"];

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
-(NSMutableDictionary *)getCustomer{
	
	NSMutableDictionary *customer=[[NSMutableDictionary alloc] initWithDictionary:contents copyItems:YES];
	[customer removeObjectForKey:@"Header"];
	[customer removeObjectForKey:@"CardNO"];
	[customer removeObjectForKey:@"OperatorName"];
	[customer removeObjectForKey:@"OperatorIP"];
	
	return customer;
	
}

-(void)setModifyName:(NSString *)string{
	[contents safeSetObject:string forKey:@"Name"];
}
-(void)setIdTypeName:(NSString *)string{
	[contents safeSetObject:string forKey:@"IdTypeName"];
}
-(void)setIdNumber:(NSString *)string{
	[contents safeSetObject:string forKey:@"IdNumber"];
}
-(void)setIdType:(NSNumber *)type{
	[contents safeSetObject:type forKey:@"IdType"];
}

- (void) setId:(NSNumber *)ID{
    [contents safeSetObject:ID forKey:@"Id"];
}

-(void)setBirthDay:(NSString *)string{
    [contents safeSetObject:string forKey:@"BirthDay"];
}

-(NSString *)requesString:(BOOL)iscompress{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
    NSMutableDictionary  *modiCardDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([modiCardDic  safeObjectForKey:@"Header"]) {
        [modiCardDic removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:modiCardDic];
}

@end
