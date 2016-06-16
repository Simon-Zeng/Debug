//
//  eLongJCustomer.m  
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongJCustomer.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"
#import "eLongDefine.h"

@implementation eLongJCustomer

-(void)buildPostData:(BOOL)clearhotelsearch{
    if (clearhotelsearch) {
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"CustomerType"];
        [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
        [contents safeSetObject:[NSNumber numberWithInt:100] forKey:@"PageSize"];
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
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

-(void)setCustomerType:(int)type{
    [contents safeSetObject:[NSNumber numberWithInt:type] forKey:@"CustomerType"];
}

- (void)setPageSize:(NSInteger)pageSize {
    _pageSize = pageSize;
    [contents safeSetObject:[NSNumber numberWithInteger:_pageSize] forKey:@"PageSize"];
}

-(void)nextPage{
    int pageIndex = [[contents safeObjectForKey:@"PageIndex"] intValue];
    pageIndex=pageIndex+1;
    [contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
    
}

- (NSString *)javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}

- (NSDictionary *)javaRequestDictionary
{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
    return contents;
}
- (NSDictionary *)toRequestDic
{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNO"];
    return contents ;
}
@end
