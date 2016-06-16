//
//  eLongDebugDB.h
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface eLongDebugDB : NSObject
/**
 *  被管理的数据上下文
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext  *managedObjectContext;
/**
 *  被管理的数据模型
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
/**
 *  持久化存储助理
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  单例
 *
 *  @return
 */
+ (instancetype) shareInstance;
/**
 *  数据存储
 */
- (void)saveContext;
/**
 *  数据插入
 *
 *  @param entityName 数据表名
 *
 *  @return 数据Model
 */
- (id)insertEntity:(NSString *)entityName;
/**
 *  数据查询
 *
 *  @param entityName  数据表名
 *  @param pageSize    每页数据量
 *  @param currentPage 当前页码
 *
 *  @return 查询结果数组
 */
- (NSArray *)selectDataFromEntity:(NSString *)entityName pageSize:(int)pageSize offset:(int)currentPage;
/**
 *  数据查询
 *
 *  @param entityName 数据表名
 *  @param query      查询表达式
 *
 *  @return 查询结果数组
 */
- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate;
/**
 *  数据查询
 *
 *  @param entityName 数据表名
 *  @param query      查询表达式
 *  @param sort       排序方式
 *
 *  @return 查询结果数组
 */
- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort;
/**
 *  删除数据Model
 *
 *  @param 数据Model
 *
 *  @return 是否删除成功
 */
- (BOOL)remove:(NSManagedObject *)model;
/**
 *  批量删除数据
 *
 *  @param entityName 数据表名
 *  @param query      查询表达式
 *
 *  @return 是否删除成功
 */
- (BOOL) removeDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate;
/**
 *  清空所有数据
 *
 *  @param entityName 数据表名
 */
- (void)clearEntity:(NSString *)entityName;
@end
