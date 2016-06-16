//
//  eLongJGetInvoiceTitle.m
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongJGetInvoiceTitle.h"
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"

@implementation eLongJGetInvoiceTitle

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

- (NSString *)javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    return [NSDictionary dictionaryWithDictionary:contents];
}
@end