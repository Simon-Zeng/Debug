//
//  eLongJDeleteGrouponFavorite.m
//  ElongClient
//
//  Created by Dawn on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "eLongJDeleteGrouponFavorite.h"
#import "eLongAccountManager.h"
#import "eLongExtension.h"

@implementation eLongJDeleteGrouponFavorite

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[eLongPostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"ProductID"];
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

-(void)setProdId:(NSString *)string{
	[contents safeSetObject:string forKey:@"ProductID"];
}


-(NSString *)requesString:(BOOL)iscompress{
	
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *deleteDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([deleteDic  safeObjectForKey:@"Header"]) {
        [deleteDic  removeObjectForKey:@"Header"];
    }
    return [eLongNetworkSerialization jsonStringWithObject:deleteDic];
    
}

- (NSDictionary *)requesDictionary:(BOOL)iscompress {
    [contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
    NSMutableDictionary  *deleteDic = [NSMutableDictionary  dictionaryWithDictionary:contents];
    if ([deleteDic  safeObjectForKey:@"Header"]) {
        [deleteDic  removeObjectForKey:@"Header"];
    }
    return deleteDic;
}

@end