//
//  eLongDebugPerformance.m
//  ElongClient
//
//  Created by Kirn on 15/3/22.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugPerformance.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation eLongDebugPerformance

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

BOOL memoryInfo(vm_statistics_data_t *vmStats) {
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)vmStats,
                                               &infoCount);
    
    return kernReturn == KERN_SUCCESS;
}

- (eLongDebugMemoryModel *)memery{
    if (!self.enabled) {
        return nil;
    }
    eLongDebugMemoryModel *memoryModel = [[eLongDebugMemoryModel alloc] init];
    memoryModel.availableMemory = [self availableMemory];
    memoryModel.usedMemory = [self usedMemory];
    
    vm_statistics_data_t vmStats;
    /*
     调用memoryInfo()就能拿到内存信息了，它的类型是vm_statistics_data_t。这个结构体有很多字段，在logMemoryInfo()中展示了如何获取它们。注意这些字段大都是页面数，要乘以vm_page_size才能拿到字节数。
     
     顺便再简要介绍下：free是空闲内存;active是已使用，但可被分页的(在iOS中，只有在磁盘上静态存在的才能被分页，例如文件的内存映射，而动态分配的内存是不能被分页的);inactive是不活跃的，实际上内存不足时，你的应用就可以抢占这部分内存，因此也可看作空闲内存;wire就是已使用，且不可被分页的。
     */
    if (memoryInfo(&vmStats)) {
        elong_debug_memory memoryStr;
        memoryStr.free = vmStats.free_count * vm_page_size/1024.0/1024.0;
        memoryStr.active = vmStats.active_count * vm_page_size/1024.0/1024.0;
        memoryStr.inactive = vmStats.inactive_count * vm_page_size/1024.0/1024.0;
        memoryStr.wire = vmStats.wire_count * vm_page_size/1024.0/1024.0;
        memoryStr.zero_fill = vmStats.zero_fill_count * vm_page_size/1024.0/1024.0;
        memoryStr.reactivations = vmStats.reactivations * vm_page_size/1024.0/1024.0;
        memoryStr.pageins = vmStats.pageins * vm_page_size/1024.0/1024.0;
        memoryStr.pageouts = vmStats.pageouts * vm_page_size/1024.0/1024.0;
        memoryStr.faults = vmStats.faults;
        memoryStr.cow_faults = vmStats.cow_faults;
        memoryStr.lookups = vmStats.lookups;
        memoryStr.hits = vmStats.hits;
        memoryModel.memory = memoryStr;
    }
    return memoryModel;
}


@end
