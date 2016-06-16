//
//  eLongJAddInvoiceTitle.h
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJAddInvoiceTitle : NSObject{
    NSMutableDictionary *contents;
}
-(void)clearBuildData;
- (void)setCompanyName:(NSString *)string;
- (void)setPostcode:(NSString *)string;
- (void)removeInvoiceContent;
- (NSMutableDictionary *)getInvoice;
- requesString:(BOOL)iscompress;
- (NSDictionary *)requestDic;

@end
