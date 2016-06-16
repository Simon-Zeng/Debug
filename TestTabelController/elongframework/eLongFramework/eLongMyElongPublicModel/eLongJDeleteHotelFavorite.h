//
//  eLongJDeleteHotelFavorite.h
//  ElongClient
//
//  Created by WangHaibin on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJDeleteHotelFavorite : NSObject {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(void)setHotelId:(NSString *)string;
- (NSString *)javaRequestString;
@end
