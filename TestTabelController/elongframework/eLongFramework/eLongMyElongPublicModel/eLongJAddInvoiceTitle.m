//
//  eLongJAddInvoiceTitle.m
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongJAddInvoiceTitle.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJAddInvoiceTitle

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
//{"Id":33,"InvoiceContent":"33","PostCode":"33","Name":"33","PhoneNo":"33"}
-(NSMutableDictionary *)getInvoice{
    
    NSMutableDictionary *customer=[[NSMutableDictionary alloc] initWithDictionary:contents];
    [customer removeObjectForKey:@"Header"];
    [customer removeObjectForKey:@"CardNo"];
    return customer;
}

-(void)setCompanyName:(NSString *)string{
    [contents safeSetObject:string forKey:@"value"];
}

-(void)removeInvoiceContent{
    [contents removeObjectForKey:@"InvoiceContent"];
}
-(void)setPostcode:(NSString *)string{
    [contents safeSetObject:string forKey:@"Postcode"];
}


-(NSString *)requesString:(BOOL)iscompress{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];

    NSMutableDictionary  *invoiceTitleDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    [invoiceTitleDic removeObjectForKey:@"Header"];
    return [eLongNetworkSerialization jsonStringWithObject:invoiceTitleDic];
}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *invoiceTitleDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    [invoiceTitleDic removeObjectForKey:@"Header"];
    return invoiceTitleDic;
}
@end