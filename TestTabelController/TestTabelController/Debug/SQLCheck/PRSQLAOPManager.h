//
//  PRSQLAOPManager.h
//  TestTabelController
//
//  Created by wzg on 16/9/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRManager.h"

@interface PRSQLAOPManager : PRManager
@property (nonatomic, assign) CFTimeInterval begin;
@property (nonatomic, assign) CFTimeInterval end;
/**
 *  监听fmdb的sql执行时间
 */
+ (void)aopFMDBQuery;

@end
