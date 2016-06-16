//
//  Crash.h
//  ElongClient
//
//  Created by Dawn on 15/3/23.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface eLongDebugCrashModel : NSManagedObject

/**
 *  crash所在页面
 */
@property (nonatomic, retain) NSString * page;
/**
 *  crash名称
 */
@property (nonatomic, retain) NSString * name;
/**
 *  App版本号
 */
@property (nonatomic, retain) NSString * version;
/**
 *  操作系统版本
 */
@property (nonatomic, retain) NSString * osversion;
/**
 *  设备类型
 */
@property (nonatomic, retain) NSString * device;
/**
 *  网络类型
 */
@property (nonatomic, retain) NSString * network;
/**
 *  渠道号
 */
@property (nonatomic, retain) NSString * channel;
/**
 *  crash时间
 */
@property (nonatomic, retain) NSDate * date;
/**
 *  设备状态
 */
@property (nonatomic, retain) NSString * mark;
/**
 *  崩溃的堆栈信息
 */
@property (nonatomic, retain) NSString * stack;

@end
