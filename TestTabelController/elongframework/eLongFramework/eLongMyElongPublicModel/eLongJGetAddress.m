//
//  eLongJGetAddress.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJGetAddress.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJGetAddress
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
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

- (NSString *)javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}

- (NSDictionary *)requestDic{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *addressDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    return addressDic;
}
@end
