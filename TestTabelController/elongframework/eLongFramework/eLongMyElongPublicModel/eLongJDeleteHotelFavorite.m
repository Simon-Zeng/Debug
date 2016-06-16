//
//  eLongJDeleteHotelFavorite.m
//  ElongClient
//
//  Created by WangHaibin on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eLongJDeleteHotelFavorite.h"
#import "eLongAccountManager.h"
#import "JSONKit.h"
#import "eLongExtension.h"

@implementation eLongJDeleteHotelFavorite
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"HotelId"];
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

-(void)setHotelId:(NSString *)string{
	[contents safeSetObject:string forKey:@"HotelId"];
}


- (NSString *)javaRequestString{
	[contents safeSetObject:[[eLongAccountManager userInstance] cardNo] forKey:@"CardNo"];
        return [eLongNetworkSerialization jsonStringWithObject:contents];

}

@end
