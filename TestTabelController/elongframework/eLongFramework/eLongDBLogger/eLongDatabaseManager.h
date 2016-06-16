//
//  eLongDatabaseManager.h
//  eLongAnalytics
//
//  Created by chenggong on 15/11/26.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

typedef NS_ENUM(NSInteger, DatabaseOwnerType) {
    eLongUserDefaultsType = 0,
    eLongAnalyticsLoggerType,
    DatabaseOwnerUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface eLongDatabaseManager : NSObject

+ (instancetype)shareDataInstance;

// Create table, write sql by yourself.
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments withOwnerType:(DatabaseOwnerType)ownerType;
// Create index for one column.
- (BOOL)createIndex:(NSString *)columnName withIndexName:(NSString *)indexName withOwnerType:(DatabaseOwnerType)ownerType;

// Query column name by key.
- (nullable id)queryByKey:(NSString *)defaultName;

// According DatabaseOwnerType to set an object for key.
- (void)setObject:(nullable id)value forKey:(NSString *)defaultName withDatabaseOwnerType:(DatabaseOwnerType)ownerType;

// Receive variable arguments to execute sql.
- (BOOL)executeUpdateTable:(NSString*)sql, ...;

// Remove an object by key.
- (void)removeObjectForKey:(NSString *)key withDatabaseOwnerType:(DatabaseOwnerType)ownerType;

- (void)setCurrentDatabaseOwnerType:(DatabaseOwnerType)ownerType;

- (NSUInteger)getTotalCountFromTable:(NSString *)tableName;

- (BOOL)isTableExist:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType;

- (NSArray *)selectFromTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType withRowLimit:(NSUInteger)rowLimit withOffset:(NSUInteger)rowOffset;
- (void)eraseTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType withRowLimit:(NSUInteger)rowLimit;

- (void)eraseTable:(NSString *)tableName withDatabaseType:(DatabaseOwnerType)ownerType fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (FMDatabaseQueue *)getFMDBAnalysticQueue;

@end

NS_ASSUME_NONNULL_END