
//  eLongDBLogger.m
//  eLongAnalytics
//
//  Created by chenggong on 15/12/3.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAnalyticsLogger.h"
#import "eLongDatabaseManager.h"
#import "eLongDBUserDefaults.h"
#import "eLongDefine.h"
#import "eLongLoggerRequest.h"
#import "JSONKit.h"
#import "eLongDebugManager.h"

#define kLogEventSendThreshold 30
#define kLogEventTimerSecond   (60 * 3)
#define kLogFixedEventTimerSecond   (60 * 15)

@interface eLongAnalyticsLogger()

@property (nonatomic, assign) NSUInteger recordLogFlexibleTotalCount;
@property (nonatomic, assign) NSUInteger recordFlexibleLogIndex;
@property (nonatomic, assign) NSUInteger recordLogFixedTotalCount;
@property (nonatomic, strong) dispatch_source_t flexibleTimer;
@property (nonatomic, strong) dispatch_source_t fixedTimer;
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@implementation eLongAnalyticsLogger

+ (eLongAnalyticsLogger *)shareLogger {
    static eLongAnalyticsLogger *shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shareInstance = [[eLongAnalyticsLogger alloc] init];
    });
    
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.recordFlexibleLogIndex = 1;
        if ([[eLongDatabaseManager shareDataInstance] isTableExist:@"eLongAnalyticsFlexibleLog" withDatabaseType:eLongAnalyticsLoggerType]) {
            self.recordLogFlexibleTotalCount = [[eLongDatabaseManager shareDataInstance] getTotalCountFromTable:@"eLongAnalyticsFlexibleLog"];
        }
        else {
            [[eLongDatabaseManager shareDataInstance] createTable:@"eLongAnalyticsFlexibleLog" withArguments:@"'id' integer primary key autoincrement not null, logContent text not null" withOwnerType:eLongAnalyticsLoggerType];
            self.recordLogFlexibleTotalCount = 0;
        }
        
        if ([[eLongDatabaseManager shareDataInstance] isTableExist:@"eLongAnalyticsFixedLog" withDatabaseType:eLongAnalyticsLoggerType]) {
            self.recordLogFixedTotalCount = [[eLongDatabaseManager shareDataInstance] getTotalCountFromTable:@"eLongAnalyticsFixedLog"];
        }
        else {
            [[eLongDatabaseManager shareDataInstance] createTable:@"eLongAnalyticsFixedLog" withArguments:@"'id' integer primary key autoincrement not null, logContent text not null" withOwnerType:eLongAnalyticsLoggerType];
            self.recordLogFixedTotalCount = 0;
        }
        
        self.selectIndex = 0;
        //[self sendEventTimerInit:kLogEventTimerSecond];
        [self sendFixedEventTimerInit:kLogFixedEventTimerSecond];
    }
    return self;
}

- (void)sendEventTimerInit:(NSUInteger)timerPeriod {
    NSTimeInterval period = timerPeriod; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.flexibleTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_flexibleTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_flexibleTimer, ^{
        NSUInteger totalColumn = [[eLongDatabaseManager shareDataInstance] getTotalCountFromTable:@"eLongAnalyticsFlexibleLog"];
        
        if (totalColumn >= kLogEventSendThreshold) {
            [weakSelf sendEventLog:eLongAnalyticsFlexibleLogType];
        }
    });
    
    dispatch_resume(_flexibleTimer);
}

- (void)sendFixedEventTimerInit:(NSUInteger)timerPeriod {
    NSTimeInterval period = timerPeriod; //设置时间间隔
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.fixedTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_fixedTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_fixedTimer, ^{
        [weakSelf sendEventLog:eLongAnalyticsFixedLogType];
    });
    
    dispatch_resume(_fixedTimer);
}

- (void)sendEventLog:(TableType)ownerType {
    if ([eLongLoggerRequest sharedInstance].isLogSending) {
        return;
    }
    
    @synchronized([[eLongDatabaseManager shareDataInstance] getFMDBAnalysticQueue]) {
        NSString *tableName = nil;
        switch (ownerType) {
            case eLongAnalyticsFixedLogType:
                tableName = @"eLongAnalyticsFixedLog";
                break;
            case eLongAnalyticsFlexibleLogType:
                tableName = @"eLongAnalyticsFlexibleLog";
                break;
            default:
                break;
        }
        
        switch (ownerType) {
            case eLongAnalyticsFixedLogType: {
                NSArray *resultArray = [[eLongDatabaseManager shareDataInstance] selectFromTable:tableName withDatabaseType:eLongAnalyticsLoggerType withRowLimit:1 withOffset:0];
                
                if (ARRAYHASVALUE(resultArray) && [resultArray count] == 1) {
                    id obj = [resultArray objectAtIndex:0];
                    if (obj) {
                        NSString *logContent = [obj objectForKey:@"logContent"];
                        [[eLongLoggerRequest sharedInstance] sendFixedLog:[logContent objectFromJSONString]];
                    }
                }
            }
                break;
            case eLongAnalyticsFlexibleLogType: {
                NSUInteger totalColumn = [[eLongDatabaseManager shareDataInstance] getTotalCountFromTable:@"eLongAnalyticsFlexibleLog"];
                NSUInteger limit = totalColumn > kLogEventSendThreshold ? kLogEventSendThreshold : totalColumn;
                
                //                if (_selectIndex >= limit && totalColumn <= kLogEventSendThreshold) {
                //                    self.selectIndex = 0;
                //                }
                //
                //                NSArray *resultArray = [[eLongDatabaseManager shareDataInstance] selectFromTable:tableName withDatabaseType:eLongAnalyticsLoggerType withRowLimit:limit withOffset:_selectIndex];
                //                self.selectIndex += kLogEventSendThreshold;
                
                NSArray *resultArray = [[eLongDatabaseManager shareDataInstance] selectFromTable:tableName withDatabaseType:eLongAnalyticsLoggerType withRowLimit:limit withOffset:0];
                
                if ([resultArray count] > 0) {
                    __block NSUInteger maxInt = [[[resultArray objectAtIndex:0] objectForKey:@"id"] integerValue];
                    __block NSUInteger minInt = maxInt;
                    
                    NSMutableArray *finalResultArray = [NSMutableArray arrayWithCapacity:0];
                    [resultArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        // NSArray is not thread safe, so add @synchronized to keep it won't cause crash.
                        @synchronized(resultArray) {
                            if (DICTIONARYHASVALUE(obj)) {
                                NSString *logContent = [obj objectForKey:@"logContent"];
                                NSUInteger idInt = [[obj objectForKey:@"id"] integerValue];
                                
                                if (idInt > maxInt) {
                                    maxInt = idInt;
                                }
                                if (idInt < minInt) {
                                    minInt = idInt;
                                }
                                
                                [finalResultArray addObject:[logContent objectFromJSONString]];
                            }
                        }
                    }];
                    
                    [[eLongLoggerRequest sharedInstance] sendFlexibleLog:@{@"logs":finalResultArray} from:minInt to:maxInt];
                }
            }
                break;
            default:
                break;
        }
    }
}

- (NSString *)getFlexibleSqlQuery {
    return @"insert into eLongAnalyticsFlexibleLog (logContent) values(?)";
}

- (NSString *)getFixedSqlQuery {
    NSString *sqlQuery = @"";
    
    if (_recordLogFixedTotalCount < 1) {
        sqlQuery = @"insert into eLongAnalyticsFixedLog (logContent) values(?)";
    }
    else {
        sqlQuery = @"update eLongAnalyticsFixedLog set logContent = ? where id = 1";
    }
    return sqlQuery;
}

- (void)recordLog:(NSString *)tableName withParameters:(NSDictionary *)parameters withResultBlock:(void(^)(void))block{
    @synchronized([[eLongDatabaseManager shareDataInstance] getFMDBAnalysticQueue]) {
        if (DICTIONARYHASVALUE(parameters)) {
            NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
            [arguments addObject:[parameters JSONString]];
            //        if (block) {
            //            [arguments addObject:block];
            //            [arguments addObject:@{@"blockPosition":@([arguments count] - 1)}];
            //        }
            
            NSString * sqlString = nil;
            
            if ([tableName isEqualToString:@"eLongAnalyticsFlexibleLog"]) {
                sqlString = [self getFlexibleSqlQuery];
            }
            else {
                sqlString = [self getFixedSqlQuery];
            }
            [[eLongDatabaseManager shareDataInstance] setCurrentDatabaseOwnerType:eLongAnalyticsLoggerType];
            if ([[eLongDatabaseManager shareDataInstance] executeUpdateTable:sqlString, arguments]) {
                block();
            }
        }
    }
}

- (void)recordLogFixed:(NSDictionary *)parameters {
    if (![parameters isKindOfClass:[NSDictionary class]] && !DICTIONARYHASVALUE(parameters)) {
        return;
    }
    
    dispatch_queue_t recordLogQueue = dispatch_queue_create("recordLogQueue", DISPATCH_QUEUE_SERIAL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(recordLogQueue, ^{
        [weakSelf recordLog:@"eLongAnalyticsFixedLog" withParameters:parameters withResultBlock:^(void){
            [weakSelf sendEventLog:eLongAnalyticsFixedLogType];
        }];
    });
}

- (void)recordLogFlexible:(NSDictionary *)parameters {
    if (![parameters isKindOfClass:[NSDictionary class]] && !DICTIONARYHASVALUE(parameters)) {
        return;
    }
    dispatch_queue_t recordLogQueue = dispatch_queue_create("recordLogQueue", DISPATCH_QUEUE_SERIAL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(recordLogQueue, ^{
        [weakSelf recordLog:@"eLongAnalyticsFlexibleLog" withParameters:parameters withResultBlock:^(void){
            if ([eLongDebugManager serverInstance].enabled) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:logDirectory]) {
                    [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
                }
                
                NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"eLongAnalytics.log"];
                
                NSString *crashString = [NSString stringWithFormat:@"%@\r\n\r\n", [parameters JSONString]];
                //把日志写到文件中
                if (![fileManager fileExistsAtPath:logFilePath]) {
                    [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                }else{
                    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
                    [outFile seekToEndOfFile];
                    [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
                    [outFile closeFile];
                }
            }
            
            NSUInteger totalColumn = [[eLongDatabaseManager shareDataInstance] getTotalCountFromTable:@"eLongAnalyticsFlexibleLog"];
            
            if (totalColumn >= kLogEventSendThreshold) {
                [weakSelf sendEventLog:eLongAnalyticsFlexibleLogType];
            }
        }];
    });
}

@end
