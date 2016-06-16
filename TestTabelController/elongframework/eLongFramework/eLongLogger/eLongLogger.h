//
//  eLongLogger.h
//  eLongLogger
//
//  Created by Dawn on 14-12-2.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  日志的严重级别
 */
typedef NS_ENUM(NSInteger, eLongLoggerSeverity) {
    /**
     *  未分级，默认
     */
    eLongLoggerSeverityUnset = 0,
    /**
     *  Debug
     */
    eLongLoggerSeverityDebug,
    /**
     *  Infomation
     */
    eLongLoggerSeverityInfo,
    /**
     *  Warning
     */
    eLongLoggerSeverityWarn,
    /**
     *  Error
     */
    eLongLoggerSeverityError,
    /**
     *  Fatal，最高级别
     */
    eLongLoggerSeverityFatal
};

// 开发测试过程中，随行日志
#ifndef __OPTIMIZE__
#   define eLongLog(f,...) [eLongLogger logMessage:[NSString stringWithFormat:(f), ##__VA_ARGS__] tag:nil severity:0 file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:[NSNumber numberWithInt:__LINE__]]
#   define eLongLogMessage(t, s, f, ...) [eLongLogger logMessage:[NSString stringWithFormat:(f), ##__VA_ARGS__] tag:(t) severity:(s) file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:[NSNumber numberWithInt:__LINE__]]
#   define eLongLogObject(t,s,o) [eLongLogger logObject:(o) tag:(t) severity:(s) file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:[NSNumber numberWithInt:__LINE__]]
#   define eLongLogMark(m) [eLongLogger logMark:m]
#else
#   define eLongLog(f,...)
#   define eLongLogMessage(t, s, f, ...)
#   define eLongLogObject(t,s,o)
#   define eLongLogMark(m)
#endif

// 发送到服务器的日志
#define eLongLogServer(t, s, f, ...) [eLongLogger logServer:[NSString stringWithFormat:(f), ##__VA_ARGS__] tag:(t) severity:(s) file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] line:[NSNumber numberWithInt:__LINE__]]



@interface eLongLogger : NSObject

/**
 *  设置发送服务器的日志的缓存数量
 *
 *  @param count 缓存数量
 */
+ (void) setLogServerCount:(NSInteger)count;

/**
 *  获取发送服务器的日志的缓存数量
 *
 *  @return 缓存数量
 */
+ (NSInteger) logServerCount;

/**
 *  在用户允许的情况下批量发送日志到服务器
 */
+ (void) sendLogToServer;

/**
 *  字符串日志
 *
 *  @param message  日志Message
 *  @param tag      Tag
 *  @param severity 日志的严重级别
 *  @param file     发送日志的文件
 *  @param line     发送日志的文件位置
 */
+ (void) logMessage:(NSString *)message tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line;

/**
 *  对象日志
 *
 *  @param object   日志Object
 *  @param tag      Tag
 *  @param severity 日志的严重级别
 *  @param file     发送日志的文件
 *  @param line     发送日志的文件位置
 */
+ (void) logObject:(NSObject *)object tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line;

/**
 *  发送到服务器的日志
 *
 *  @param message  日志Message
 *  @param tag      Tag
 *  @param severity 日志的严重级别
 *  @param file     发送日志的文件
 *  @param line     发送日志的文件位置
 */
+ (void) logServer:(NSString *)message tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line;

/**
 *  特殊标记
 *
 *  @param mark 特殊标记
 */
+ (void) logMark:(NSString *)mark;
@end
