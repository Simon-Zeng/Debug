//
//  eLongJDeleteInvoiceTitle.m
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongJDeleteInvoiceTitle.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJDeleteInvoiceTitle
-(void)buildPostData:(BOOL)clearhotelsearch{
    if (clearhotelsearch) {
//        [contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"titleId"];
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

-(void)setInvoiceId:(int)invoiceId{
    [contents safeSetObject:[NSNumber numberWithInt:invoiceId] forKey:@"titleId"];
}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *invoiceDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([invoiceDic  safeObjectForKey:@"Header"]) {
        [invoiceDic  removeObjectForKey:@"Header"];
    }
    return invoiceDic;
}

@end
