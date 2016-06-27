//
//  DebugDB.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DebugDB : NSObject

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


+ (instancetype)shareInstance;
/**
 *  保存数据
 */
- (void)saveContext;
/**
 *  数据插入
 *
 *  @param entityName 数据表名
 *
 *  @return 数据model
 */
- (id)insertEntity:(NSString *)entityName;
/**
 *  数据查询
 *
 *  @param entityName  表
 *  @param pageSize    每页数量
 *  @param currentPage 当前页码
 *
 *  @return 结果
 */
- (NSArray *)selectDataFromEntity:(NSString *)entityName pageSize:(int)pageSize offset:(int)currentPage;

/**
 *  数据查询
 *
 *  @param entityName 表
 *  @param predicate  查询表达式
 *
 *  @return 结果
 */
- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate;
/**
 * 数据查询
 *
 *  @param entityName 表
 *  @param predicate  查询表达式
 *  @param sort       排序方式
 *
 *  @return 结果
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
