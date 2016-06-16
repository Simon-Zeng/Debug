//
//  eLongJModifyCustomer.h
//  ElongClient
//
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"


@interface eLongJModifyCustomer : NSObject {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(void)setModifyName:(NSString *)string;
-(void)setIdTypeName:(NSString *)string;
-(void)setIdNumber:(NSString *)string;
-(void)setIdType:(NSNumber *)type;
-(void) setId:(NSNumber *)ID;
-(void)setBirthDay:(NSString *)string;
-(NSString *)requesString:(BOOL)iscompress;
-(NSMutableDictionary *)getCustomer;

@end
