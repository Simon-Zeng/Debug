//
//  eLongJAddCustomer.h
//  ElongClient
//
//  Created by WangHaibin on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJAddCustomer : NSObject {

		NSMutableDictionary *contents;
}
-(void)clearBuildData;

-(void)setAddName:(NSString *)string;
-(void)setIdType:(NSNumber *)type;
-(void)setIdTypeName:(NSString *)string;
-(void)setIdNumber:(NSString *)string;
-(void)setPhoneNO:(NSString *)string;
-(void)setID:(NSNumber *)type;
- (void)setBirthDay:(NSString *)string;
-(NSMutableDictionary *)getCustomer;
-(NSString *)requesString:(BOOL)iscompress;
@end
