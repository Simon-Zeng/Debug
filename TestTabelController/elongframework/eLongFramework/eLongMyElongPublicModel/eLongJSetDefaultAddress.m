//
//  eLongJSetDefaultAddress.m
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongJSetDefaultAddress.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJSetDefaultAddress

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

-(void)buildPostData:(BOOL)clearhotelsearch{
    if (clearhotelsearch) {
        [contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
        [contents safeSetObject:@(1) forKey:@"type"];
    }
}

- (void)setAddressID:(NSString *)addressID{
    [contents safeSetObject:addressID forKey:@"id"];
}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *addressDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([addressDic  safeObjectForKey:@"Header"]) {
        [addressDic  removeObjectForKey:@"Header"];
    }
    return addressDic;
}

@end
