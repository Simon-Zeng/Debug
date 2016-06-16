//
//  eLongJAddCustomer.m
//  ElongClient
//
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJAddCustomer.h"
#import <math.h>
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"

@implementation eLongJAddCustomer
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
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
	
	return [customer mutableCopy];

}

-(void)setAddName:(NSString *)string{
	[contents safeSetObject:string forKey:@"Name"];
}
-(void)setPhoneNO:(NSString *)string{
	[contents safeSetObject:string forKey:@"PhoneNo"];
}
-(void)setIdType:(NSNumber *)type{
	[contents safeSetObject:type forKey:@"IdType"];
}
-(void)setIdTypeName:(NSString *)string{
	[contents safeSetObject:string forKey:@"IdTypeName"];
}

-(void)setIdNumber:(NSString *)string{
	[contents safeSetObject:string forKey:@"IdNumber"];
}

-(void)setID:(NSNumber *)type{
	[contents safeSetObject:type forKey:@"Id"];
}

-(void)setBirthDay:(NSString *)string{
    [contents safeSetObject:string forKey:@"BirthDay"];
}

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
	NSLog(@"%@", contents);
//	return [NSString stringWithFormat:@"action=AddCustomer&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
    NSMutableDictionary  *cusDic =[NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([cusDic  safeObjectForKey:@"Header"]) {
        [cusDic  removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:cusDic];
}

@end
