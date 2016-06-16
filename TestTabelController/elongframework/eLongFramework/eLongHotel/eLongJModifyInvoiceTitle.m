//
//  eLongJModifyInvoiceTitle.m
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongJModifyInvoiceTitle.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

#define _INVOICE_DEFTITLE       @"defTitle"

@implementation eLongJModifyInvoiceTitle

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

- (void)setModifyCompanyNameContent:(NSString *)string{
    [contents safeSetObject:string forKey:@"value"];
}

-(void)setModifyTitleID:(int)idNum{
    [contents safeSetObject:[NSNumber numberWithInt:idNum] forKey:@"titleId"];
}

- (void)setIsDef:(BOOL)isDef{
    [contents safeSetObject:@(isDef)forKey:_INVOICE_DEFTITLE];
}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *modiCard = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([modiCard  safeObjectForKey:@"Header"]) {
        [modiCard  removeObjectForKey:@"Header"];
    }
    return contents;
}

@end