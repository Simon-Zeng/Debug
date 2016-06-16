//
//  eLongJVerifyCard.h
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongPostHeader.h"

@interface eLongJVerifyCard : UITableViewCell {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(NSString *)requesString:(BOOL)iscompress;
@end
