//
//  eLongJDeleteCustomer.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJDeleteCustomer.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
@implementation eLongJDeleteCustomer

-(void)buildPostData:(BOOL)clearhotelsearch{
    if (clearhotelsearch) {
        [contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
        [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        [contents safeSetObject:[NSNumber numberWithInteger:0] forKey:@"CustomerId"];
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

- (void)setCustomerId:(NSInteger)customerId{
    [contents safeSetObject:[NSNumber numberWithInteger:customerId] forKey:@"CustomerId"];
}


- (NSString *)requesString:(BOOL)iscompress{
    NSMutableDictionary  *deleteDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([deleteDic  safeObjectForKey:@"Header"]) {
        [deleteDic  removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:deleteDic];
    
}

- (NSDictionary *)requesDict:(BOOL)iscompress {
    NSMutableDictionary  *deleteDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([deleteDic  safeObjectForKey:@"Header"]) {
        [deleteDic  removeObjectForKey:@"Header"];
    }
    return deleteDic;
}

@end
