//
//  eLongDebugPerformance.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugObject.h"
#import "eLongDebugMemoryModel.h"

@interface eLongDebugPerformance : eLongDebugObject
/**
 *  获取当前系统的内存情况
 *
 *  @return 内存Model
 */
- (eLongDebugMemoryModel *) memery;
@end
