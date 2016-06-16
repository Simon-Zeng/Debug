//
//  eLongJAddAddress.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJAddAddress.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
#import "JSONKit.h"

@implementation eLongJAddAddress
-(void)buildPostData:(BOOL)clearhotelsearch{
    if (clearhotelsearch) {
        [contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
        [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        [contents safeSetObject:@"" forKey:@"OperatorName"];
        [contents safeSetObject:@"" forKey:@"OperatorIP"];
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"Id"];
        [contents safeSetObject:@"" forKey:@"Name"];
        [contents safeSetObject:@"" forKey:@"Address"];
        [contents safeSetObject:@"" forKey:@"PhoneNo"];
        //		[contents safeSetObject:@"" forKey:@"Postcode"];
        [contents safeSetObject:@"" forKey:@"PostCode"];
        
        [contents safeSetObject:@"" forKey:@"Province"];
        [contents safeSetObject:@"" forKey:@"City"];
        [contents safeSetObject:@"" forKey:@"AreaCode"];
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
//{"Id":33,"AddressContent":"33","PostCode":"33","Name":"33","PhoneNo":"33"}
-(NSMutableDictionary *)getAddress{
    
    NSMutableDictionary *customer=[[NSMutableDictionary alloc] initWithDictionary:contents];
    [customer removeObjectForKey:@"Header"];
    [customer removeObjectForKey:@"CardNo"];
    [customer removeObjectForKey:@"OperatorName"];
    [customer removeObjectForKey:@"OperatorIP"];
    
    return customer;
    
}

-(void)setAddName:(NSString *)string{
    [contents safeSetObject:string forKey:@"Name"];
}
-(void)setAddress:(NSString *)string{
    [contents safeSetObject:string forKey:@"Address"];
}
-(void)setAddressContent:(NSString *)string{
    [contents safeSetObject:string forKey:@"AddressContent"];
}

- (void)setPhoneNo:(NSString *)string {
    [contents safeSetObject:string forKey:@"PhoneNo"];
}
- (void)setProvince:(NSString *)string {
    [contents safeSetObject:string forKey:@"Province"];
}
- (void)setCity:(NSString *)string {
    [contents safeSetObject:string forKey:@"City"];
}
- (void)setPostCode:(NSString *)string {
    [contents safeSetObject:string forKey:@"PostCode"];
}
- (void)setAreaCode:(NSString *)string {
    [contents safeSetObject:string forKey:@"AreaCode"];
}

-(void)removeAddressContent{
    [contents removeObjectForKey:@"AddressContent"];
}
//-(void)setPostcode:(NSString *)string{
//	[contents safeSetObject:string forKey:@"Postcode"];
//}

-(NSString *)requesString:(BOOL)iscompress{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *addressDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    [addressDic removeObjectForKey:@"Header"];
    return [addressDic JSONString];
}

- (NSDictionary *)requestDic{
    return [NSDictionary dictionaryWithDictionary:contents];
}
@end
