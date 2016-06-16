//
//  eLongLogger.m
//  eLongLogger
//
//  Created by Dawn on 14-12-2.
//  Copyright (c) 2014年 Kirn. All rights reserved.
//

#import "eLongLogger.h"
#import "eLongLogBonjour.h"
#import "eLongLoggerComment.h"

static NSInteger logServerCount = 10;
@implementation eLongLogger

+ (void) setLogServerCount:(NSInteger)count{
    logServerCount = count;
}

+ (NSInteger) logServerCount{
    return logServerCount;
}

/**
 *  把日志的严重级别转换为字符标识
 *
 *  @param severity 日志严重级别
 *
 *  @return 日志严重级别字符标识
 */
+ (NSString *)labelForSeverity:(eLongLoggerSeverity)severity {
    switch (severity) {
        case eLongLoggerSeverityDebug:  return @"DEBUG";
        case eLongLoggerSeverityInfo:   return @"INFO";
        case eLongLoggerSeverityWarn:	return @"WARN";
        case eLongLoggerSeverityError:	return @"ERROR";
        case eLongLoggerSeverityFatal:	return @"FATAL";
        default: return @"";
    }
}

+ (void) logMessage:(NSString *)message tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line{
    [eLongLogger logObject:message tag:tag severity:severity file:file line:line];
}

+ (void) logObject:(NSObject *)object tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line{
    NSString *severityLab = [eLongLogger labelForSeverity:severity];
    NSString *thread = [NSString stringWithFormat:@"%@",[NSThread currentThread]];
    NSMutableString *logString = [[NSMutableString alloc] initWithString:@""];
    if (file && line) {
        [logString appendFormat:@"[%@->%@]",file,line];
    }
    if (tag) {
        [logString appendFormat:@"[%@]",tag];
    }
    if (severity) {
        [logString appendFormat:@"[%@]",severityLab];
    }
    if (object) {
        [logString appendFormat:@"[%@]",object];
    }
    
    NSLog(@"%@",logString);
    
    NSDictionary *dict = @{
                           eLongLogger_tag : (tag ? tag : @""),
                           eLongLogger_severity : (severityLab ? severityLab : @""),
                           eLongLogger_file : (file ? file : @""),
                           eLongLogger_line : (line ? line : @""),
                           eLongLogger_message : (object ? object : @""),
                           eLongLogger_thread : (thread ? thread : @""),
                           eLongLogger_time : @([[NSDate date] timeIntervalSince1970])
                           };
    [[eLongLogBonjour sharedInstance] sendMessage:dict service:NO];
}

+ (void) logServer:(NSString *)message tag:(NSString *)tag severity:(eLongLoggerSeverity)severity file:(NSString *)file line:(NSNumber *)line{
    NSString *severityLab = [eLongLogger labelForSeverity:severity];
    NSString *thread = [NSString stringWithFormat:@"%@",[NSThread currentThread]];
    NSDictionary *dict = @{
                           eLongLogger_tag : tag,
                           eLongLogger_severity : severityLab,
                           eLongLogger_file : file,
                           eLongLogger_line : line,
                           eLongLogger_message : message,
                           eLongLogger_thread : thread,
                           eLongLogger_time : @([[NSDate date] timeIntervalSince1970])
                           };
    [[eLongLogBonjour sharedInstance] sendMessage:dict service:YES];
}

+ (void) logMark:(NSString *)mark{
    NSLog(@"mark:%@",mark);
    NSDictionary *dict = @{@"mark":mark};
    [[eLongLogBonjour sharedInstance] sendMessage:dict service:NO];
}

+ (void) sendLogToServer{
    [[eLongLogBonjour sharedInstance] sendLogToServer];
}

@end
