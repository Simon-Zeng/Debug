//
//  eLongJCard.h
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"
@interface eLongJCard : NSObject {
	NSMutableDictionary *contents;
	
}
-(void)clearBuildData;
- (NSString *) javaRequestString;
@end
