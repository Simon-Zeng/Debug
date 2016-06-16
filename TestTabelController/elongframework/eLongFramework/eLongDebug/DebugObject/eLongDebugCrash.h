//
//  eLongDebugCrash.h
//  ElongClient
//
//  Created by Dawn on 15/3/23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugCrashModel.h"

@interface eLongDebugCrash : eLongDebugObject
/**
 *  开始记录crash
 *
 *  @return crashModel
 */
- (eLongDebugCrashModel *) beginCrash;
/**
 *  结束并存储crash数据
 */
- (void) endCrash;
/**
 *  所有的crash数据
 *
 *  @return 所有的crash数据
 */
- (NSArray *) crashes;
/**
 *  清空所有的crash数据
 */
- (void) clearCrash;
@end
