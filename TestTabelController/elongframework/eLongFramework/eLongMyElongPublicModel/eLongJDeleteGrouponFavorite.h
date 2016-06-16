//
//  eLongJDeleteGrouponFavorite.h
//  ElongClient
//
//  Created by Dawn on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJDeleteGrouponFavorite : NSObject{
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(void)setProdId:(NSString *)string;
-(NSString *)requesString:(BOOL)iscompress;
- (NSDictionary *)requesDictionary:(BOOL)iscompress;
@end
