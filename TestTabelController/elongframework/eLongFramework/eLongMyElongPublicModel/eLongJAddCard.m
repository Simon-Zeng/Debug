//
//  eLongJAddCard.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJAddCard.h"
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"

@implementation eLongJAddCard
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:[NSNull	null] forKey:@"OperatorName"];
		[contents safeSetObject:[NSNull	null] forKey:@"OperatorIp"];
		[contents safeSetObject:creditCardDictinoary forKey:@"CreditCard"];
	}
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		
		creditCardDictinoary = [[NSMutableDictionary alloc] init];
		creditCardType = [[NSMutableDictionary alloc] init];
		
		[creditCardDictinoary safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"ElongCardNo"];
		[creditCardDictinoary safeSetObject:creditCardType forKey:@"CreditCardType"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"CreditCardNumber"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"HolderName"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"VerifyCode"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"CertificateType"];
		[creditCardDictinoary safeSetObject:@"" forKey:@"CertificateNumber"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"ExpireYear"];
		[creditCardDictinoary safeSetObject:[NSNumber numberWithInt:0] forKey:@"ExpireMonth"];
		
		[creditCardType safeSetObject:@"" forKey:@"Id"];
		[creditCardType safeSetObject:[NSNull null] forKey:@"Name"];
		
		
		
		
		[self clearBuildData];
	}
	return self;
}

-(NSMutableDictionary *)getCard{
	
	NSMutableDictionary *card=[[NSMutableDictionary alloc] initWithDictionary:contents copyItems:YES];
	[card removeObjectForKey:@"Header"];
	[card removeObjectForKey:@"OperatorName"];
	[card removeObjectForKey:@"OperatorIp"];
	
	return [card mutableCopy];
	
}
-(void)setVerifyCode:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"VerifyCode"];
}

-(void)setHolderName:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"HolderName"];
}

-(void)setCreditCardTypeName:(NSString *)string{
	[[[contents safeObjectForKey:@"CreditCard"] safeObjectForKey:@"CreditCardType"] safeSetObject:string forKey:@"Name"];
}

-(void)setCreditCardTypeID:(NSString *)string{
	[[[contents safeObjectForKey:@"CreditCard"] safeObjectForKey:@"CreditCardType"] safeSetObject:string forKey:@"Id"];
}
-(void)setCreditCardNumber:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"CreditCardNumber"];
}

-(void)setExpireYear:(int)year{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:[NSNumber numberWithInt:year] forKey:@"ExpireYear"];
}

-(void)setExpireMonth:(int)Month{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:[NSNumber numberWithInt:Month] forKey:@"ExpireMonth"];
}

-(void)setCertificateType:(NSNumber *)type{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:type forKey:@"CertificateType"];
}

-(void)setCertificateNumber:(NSString *)string{
	[[contents safeObjectForKey:@"CreditCard"] safeSetObject:string forKey:@"CertificateNumber"];
}

-(void)clearBuildData{
	[self buildPostData:YES];
    
    [[contents safeObjectForKey:@"CreditCard"] safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"ElongCardNo"];
}

-(NSString *)requesString:(BOOL)iscompress{
    NSLog(@"%@",[contents JSONRepresentation]);
//	return [NSString stringWithFormat:@"action=AddCreditCard&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
    NSMutableDictionary  *cardDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([cardDic  safeObjectForKey:@"Header"]) {
        [cardDic  removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:cardDic];
}
@end
