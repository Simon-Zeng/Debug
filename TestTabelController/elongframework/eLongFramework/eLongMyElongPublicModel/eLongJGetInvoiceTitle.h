//
//  eLongJGetInvoiceTitle.h
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJGetInvoiceTitle : NSObject{
    NSMutableDictionary *contents;
}
-(void)clearBuildData;
- (NSString *)javaRequestString;
- (NSDictionary *)requestDic;
@end
