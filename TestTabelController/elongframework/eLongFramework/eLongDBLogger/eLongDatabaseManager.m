//
//  eLongDatabaseManager.m
//  eLongAnalytics
//
//  Created by chenggong on 15/11/26.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongDatabaseManager.h"
#import "fmdb/FMDatabaseAdditions.h"
#import <mach/mach_time.h> // for mach_absolute_time
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "eLongDefine.h"

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static const NSString *kElongUserDefaultsTableName = @"eLongDBUserDefaults";
static const NSString *kElongAnalyticsLoggerTableName = @"eLongAnalyticsLogger";

@interface eLongDatabaseManager()

@property (nonatomic, strong) NSString *eLongUserDefaultsDbPath;
@property (nonatomic, strong) NSString *eLongAnalyticsLoggerDbPath;
@property (nonatomic, strong) FMDatabase *eLongUserDefaultsDB;
@property (nonatomic, strong) FMDatabase *eLongAnalyticsLoggerDB;
@property (nonatomic, assign) DatabaseOwnerType currentDatabaseOwnerType;
@property (nonatomic, strong) FMDatabaseQueue * analysticDatabaseQueue;
@property (nonatomic, strong) FMDatabaseQueue * defaultsDatabaseQueue;

@end

@implementation eLongDatabaseManager

+ (instancetype)shareDataInstance
{
    static eLongDatabaseManager *shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shareInstance = [[eLongDatabaseManager alloc] init];
    });
    
    return shareInstance;
}

- (FMDatabaseQueue *)getFMDBAnalysticQueue {
    return _analysticDatabaseQueue;
}

- (instancetype)init {
    if (self = [super init]) {
        self.analysticDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self getDatabasePathByOwnerType:eLongAnalyticsLoggerType]];
        self.defaultsDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self getDatabasePathByOwnerType:eLongUserDefaultsType]];
    }
    return self;
}

- (void)setCurrentDatabaseOwnerType:(DatabaseOwnerType)ownerType {
    _currentDatabaseOwnerType = ownerType;
}

// 计时方法
double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer / (double)timebase.denom / 1e9;
}

- (nullable FMDatabase *)getDatabaseInstanceByOwnerType:(DatabaseOwnerType)ownerType {
    switch (ownerType) {
        case eLongUserDefaultsType: {
            if (!_eLongUserDefaultsDB) {
                self.eLongUserDefaultsDbPath = [self getDatabasePathByOwnerType:ownerType];
                self.eLongUserDefaultsDB = [FMDatabase databaseWithPath:_eLongUserDefaultsDbPath];
            }
            return _eLongUserDefaultsDB;
        }
        case eLongAnalyticsLoggerType:
            if (!_eLongAnalyticsLoggerDB) {
                self.eLongAnalyticsLoggerDbPath = [self getDatabasePathByOwnerType:ownerType];
                self.eLongAnalyticsLoggerDB = [FMDatabase databaseWithPath:_eLongAnalyticsLoggerDbPath];
            }
            return _eLongAnalyticsLoggerDB;
        default:
            break;
    }
    return nil;
}

- (nullable NSString *)getDatabasePathByOwnerType:(DatabaseOwnerType)ownerType {
    NSString * doc = PATH_OF_DOCUMENT;
    switch (ownerType) {
        case eLongUserDefaultsType:
            return [doc stringByAppendingPathComponent:@"elongDBUserDefaults.db"];
        case eLongAnalyticsLoggerType:
            return [doc stringByAppendingPathComponent:@"elongAnalyticsLogger.db"];
        default:
            break;
    }
    
    return nil;
}

- (nullable NSString *)getTableNameByOwnerType:(DatabaseOwnerType)ownerType {
    switch (ownerType) {
        case eLongUserDefaultsType:
            return [NSString stringWithFormat:@"%@", kElongUserDefaultsTableName];
        case eLongAnalyticsLoggerType:
            return [NSString stringWithFormat:@"%@", kElongAnalyticsLoggerTableName];
        default:
            break;
    }
    
    return nil;
}

- (BOOL)createIndex:(NSString *)columnName withIndexName:(NSString *)indexName withOwnerType:(DatabaseOwnerType)ownerType {
    // TODO: Have to modify for thread safe.
    FMDatabase *fmDatabase = [self getDatabaseInstanceByOwnerType:ownerType];
    if ([fmDatabase open]) {
        NSString *sqlCreateIndex;
        switch (ownerType) {
            case eLongUserDefaultsType: {
                sqlCreateIndex = [NSString stringWithFormat:@"CREATE INDEX if not exists %@ on elongDBUserDefaults (%@)", indexName, columnName];
            };
                break;
            case eLongAnalyticsLoggerType: {
            }
                break;
            default:
                break;
        }
        
        
        if (![fmDatabase executeUpdate:sqlCreateIndex]) {
            [fmDatabase close];
            return NO;
        }
        [fmDatabase close];
        return YES;
    }
    return  NO;
}

- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments withOwnerType:(DatabaseOwnerType)ownerType {
    __block BOOL createTableSuccess = NO;
    FMDatabaseQueue * fmDatabaseQueue = nil;
    
    switch (ownerType) {
        case eLongUserDefaultsType: {
            fmDatabaseQueue = _defaultsDatabaseQueue;
        };
            break;
        case eLongAnalyticsLoggerType: {
            fmDatabaseQueue = _analysticDatabaseQueue;
        }
            break;
        default:
            break;
    }
    
    if (fmDatabaseQueue) {
        [fmDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if ([db tableExists:tableName]) {
                createTableSuccess = YES;
            }
            
            NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
            if (![db executeUpdate:sqlCreateTable]) {
                createTableSuccess = YES;
            }
        }];
    }
    
    return createTableSuccess;
}

- (nullable id)queryByKey:(NSString *)defaultName {
    __block id result = [NSNull null];
    
    [_defaultsDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSentence = [NSString stringWithFormat:@"select value from %@ where key = ?", kElongUserDefaultsTableName];
        FMResultSet *rs = [_eLongUserDefaultsDB executeQuery:selectSentence, defaultName];
        if ([rs next]) {
            result = [rs objectForColumnIndex:0];
        }
        [rs close];
    }];
    
    return result;
}

- (BOOL)executeUpdateTable:(NSString*)sql, ...
{
    @synchronized(self) {
        __block BOOL result = NO;
        va_list args;
        va_start(args, sql);
        if (sql) {
            NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:0];
            id arg = va_arg(args, id);
            //            void (^resultBlock)(void) = nil;
            while (arg != nil) {
                if ([arg isKindOfClass:[NSArray class]]) {
                    arguments = arg;
//                    if ([[arguments objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
//                        [arg replaceObjectAtIndex:0 withObject:[((NSDictionary *)[arguments objectAtIndex:0]) JSONString]];
//                    }
                    //                    id lastArgument = [arguments objectAtIndex:(arguments.count - 1)];
                    //                    if ([[arguments objectAtIndex:(arguments.count - 1)] isKindOfClass:[NSDictionary class]]) {
                    //                        NSNumber *blockPosition = lastArgument[@"blockPosition"];
                    //                        resultBlock = [[arguments objectAtIndex:[blockPosition integerValue]] copy];
                    //                        [arguments removeObjectsInRange:NSMakeRange(arguments.count - 2, 2)];
                    //                    }
                    break;
                }
                
                [arguments addObject:arg];
                arg = va_arg(args, id);
            }
            
            if (ARRAYHASVALUE(arguments)) {
                [_analysticDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    result = [db executeUpdate:sql withArgumentsInArray:arguments];
                }];
            }
        }
        va_end(args);
        return result;
    }
}

- (void)setObject:(nullable id)value forKey:(NSString *)defaultName withDatabaseOwnerType:(DatabaseOwnerType)ownerType {
    NSString *tableName = [self getTableNameByOwnerType:ownerType];
    self.currentDatabaseOwnerType = ownerType;
    
    if ([value isKindOfClass:[UIImage class]]) {
        value = UIImagePNGRepresentation(value);
    }
    
    if ([[self queryByKey:defaultName] isEqual:[NSNull null]]) {
        switch (ownerType) {
            case eLongUserDefaultsType: {
                NSString *sql = @"insert into eLongDBUserDefaults (key, value) values(?, ?)";
                [self executeUpdateTable:sql, defaultName, value, nil];
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (ownerType) {
            case eLongUserDefaultsType: {
                NSString *sql = [NSString stringWithFormat:@"update %@ set value = ? where key = ?", tableName];
                [self executeUpdateTable:sql, defaultName, value, nil];
            }
                break;
            default:
                break;
        }
    }
}

- (void)removeObjectForKey:(NSString *)key withDatabaseOwnerType:(DatabaseOwnerType)ownerType {
    NSString *tableName = [self getTableNameByOwnerType:ownerType];
    self.currentDatabaseOwnerType = ownerType;
    switch (ownerType) {
        case eLongUserDefaultsType: {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where key = ?", tableName];
            [self executeUpdateTable:sql, key, nil];
        }
            break;
        default:
            break;
    }
}

- (NSUInteger)getTotalCountFromTable:(NSString *)tableName {
    __block NSUInteger totalCount = 0;
    NSString *sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
    
    [_analysticDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:sqlString];
        if ([rs next]) {
            totalCount = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    
    return totalCount;
}

- (BOOL)isTableExist:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType
{
    __block BOOL isTableExist = NO;
    
    [_analysticDatabaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next]) {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            
            if (count > 0)
            {
                isTableExist = YES;
            }
        }
        [rs close];
    }];
    
    return isTableExist;
}

- (NSArray *)selectFromTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType withRowLimit:(NSUInteger)rowLimit withOffset:(NSUInteger)rowOffset{
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    FMDatabaseQueue * databaseQueue = nil;
    switch (ownerType) {
        case eLongAnalyticsLoggerType:
            databaseQueue = _analysticDatabaseQueue;
            break;
        case eLongUserDefaultsType:
            databaseQueue = _defaultsDatabaseQueue;
        default:
            break;
    }
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY ID LIMIT %lu OFFSET %lu", tableName, (unsigned long)rowLimit, (unsigned long)rowOffset];
        FMResultSet *rs = [db executeQuery:querySql];
        while ([rs next]) {
            [resultArray addObject:[rs resultDictionary]];
        }
        [rs close];
    }];
    
    return resultArray;
}

// 清除表
- (void)eraseTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType withRowLimit:(NSUInteger)rowLimit
{
    FMDatabaseQueue * databaseQueue = nil;
    switch (ownerType) {
        case eLongAnalyticsLoggerType:
            databaseQueue = _analysticDatabaseQueue;
            break;
        case eLongUserDefaultsType:
            databaseQueue = _defaultsDatabaseQueue;
        default:
            break;
    }
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ROWID IN (SELECT ROWID FROM %@ LIMIT %lu)", tableName, tableName, (unsigned long)rowLimit];
        [db executeUpdate:deleteSql];
    }];
}

- (void)eraseTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    FMDatabaseQueue * databaseQueue = nil;
    switch (ownerType) {
        case eLongAnalyticsLoggerType:
            databaseQueue = _analysticDatabaseQueue;
            break;
        case eLongUserDefaultsType:
            databaseQueue = _defaultsDatabaseQueue;
        default:
            break;
    }
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ID >= %lu and ID <= %lu", tableName, (unsigned long)fromIndex, (unsigned long)toIndex];
        [db executeUpdate:deleteSql];
    }];
}

@end
