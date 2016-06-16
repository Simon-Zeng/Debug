//
//  eLongJModifyAddress.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJModifyAddress : NSObject {

	NSMutableDictionary *contents;
}
- (void)clearBuildData;
- (void)setModifyName:(NSString *)string;
- (void)setAddress:(NSString *)string;
//- (void)setPostcode:(NSString *)string;

- (void)setPhoneNo:(NSString *)string;
- (void)setProvince:(NSString *)string;
- (void)setCity:(NSString *)string;
- (void)setPostCode:(NSString *)string;
- (void)setAreaCode:(NSString *)string;

- (void)setAddressContent:(NSString *)string;
- (NSString *)requesString:(BOOL)iscompress;
- (NSDictionary *)requestDic;
- (NSMutableDictionary *)getAddress;
- (void)removeAddressContent;
- (void)setId:(NSInteger)idNum;
- (void)setIsdef:(BOOL)isDef;
@end
