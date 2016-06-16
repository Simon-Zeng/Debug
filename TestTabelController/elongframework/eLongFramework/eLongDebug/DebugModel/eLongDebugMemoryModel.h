//
//  eLongDebugMemoryModel.h
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  free是空闲内存;
 *  active是已使用，但可被分页的(在iOS中，只有在磁盘上静态存在的才能被分页，例如文件的内存映射，而动态分配的内存是不能被分页的);
 *  inactive是不活跃的，实际上内存不足时，你的应用就可以抢占这部分内存，因此也可看作空闲内存;
 *  wire就是已使用，且不可被分页的。
 */
typedef struct elong_debug_memory{
    double free;
    double active;
    double inactive;
    double wire;
    double zero_fill;
    double reactivations;
    double pageins;
    double pageouts;
    double faults;
    double cow_faults;
    double lookups;
    double hits;
}elong_debug_memory;

@interface eLongDebugMemoryModel : NSObject
/**
 *  可使用内存
 */
@property (nonatomic,assign) double availableMemory;
/**
 *  已用内存
 */
@property (nonatomic,assign) double usedMemory;
/**
 *  内存详情
 */
@property (nonatomic,assign) elong_debug_memory memory;
@end
