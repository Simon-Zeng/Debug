//
//  eLongJSetDefaultAddress.h
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJSetDefaultAddress : NSObject{
    NSMutableDictionary *contents;
}
- (void)clearBuildData;
- (void)setAddressID:(NSString *)addressID;
- (NSDictionary *)requestDic;
@end
