//
//  eLongJGetAddress.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJGetAddress : NSObject {
	NSMutableDictionary *contents;
	
}
-(void)clearBuildData;
- (NSString *)javaRequestString;
- (NSDictionary *)requestDic;
@end
