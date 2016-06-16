//
//  eLongJCard.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "eLongJCard.h"
#import "JSONKit.h"
#import "eLongNetworking.h"
#import "eLongExtension.h"
#import "eLongAccountManager.h"

@implementation eLongJCard

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo]  forKey:@"CardNO"];
//		[contents safeSetObject:[NSNumber numberWithLongLong:2000000000619705016] forKey:@"CardNO"];
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

- (NSString *) javaRequestString{
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo]forKey:@"CardNO"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}
@end
