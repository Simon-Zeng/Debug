//
//  eLongJModifyInvoiceTitle.h
//  ElongClient
//
//  Created by lvyue on 15/3/13.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"

@interface eLongJModifyInvoiceTitle : NSObject{
    
    NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(void)setModifyTitleID:(int)idNum;
- (void)setModifyCompanyNameContent:(NSString *)string;
- (void)setIsDef:(BOOL)isDef;
- (NSDictionary *)requestDic;

@end
