//
//  eLongJCustomer.h
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongPostHeader.h"
@interface eLongJCustomer : NSObject {
    NSMutableDictionary *contents;
    
}

@property (nonatomic, assign) NSInteger pageSize;

-(void)clearBuildData;
-(void)setCustomerType:(int)type;
-(void)nextPage;
- (NSString *)javaRequestString;
- (NSDictionary *)toRequestDic;
- (NSDictionary *)javaRequestDictionary;
@end
