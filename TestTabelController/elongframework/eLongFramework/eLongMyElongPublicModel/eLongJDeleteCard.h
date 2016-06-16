//
//  eLongJDeleteCard.h
//  ElongClient
//
//  Created by WangHaibin on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJDeleteCard : NSObject {
	NSMutableDictionary *contents;
	NSMutableDictionary *creditCardDictinoary;
	NSMutableDictionary *creditCardType;
}
-(void)clearBuildData;
-(NSString *)requesString:(BOOL)iscompress;

-(void)setCreditCardNo:(NSString *)string;

-(NSMutableDictionary *)getCard;
@end
