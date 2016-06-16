//
//  eLongDebugDB.m
//  ElongClient
//
//  Created by Dawn on 15/3/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongDebugDB.h"

@implementation eLongDebugDB

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype) shareInstance{
    static eLongDebugDB *debugDB = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        debugDB = [[eLongDebugDB alloc] init];
    });
    return debugDB;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"eLongDebug" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:@"eLongDebug.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                             NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],
                             NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// 保存改变
- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationCachesDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (id)insertEntity:(NSString *)entityName{
    NSManagedObjectContext *context = [self managedObjectContext];
    id newsInfo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return newsInfo;
}

// 查询
- (NSArray *)selectDataFromEntity:(NSString *)entityName pageSize:(int)pageSize offset:(int)currentPage {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate{
    return [self selectDataFromEntity:entityName query:predicate sort:nil];
}

// 查询表达式
- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    if (sort) {
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    if (predicate) {
        [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    }
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    return result;
}

// 删除
- (BOOL) remove:(NSManagedObject *)model{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:model];
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"error:%@",error);
        return NO;
    }
    return YES;
}

// 批量删除数据
- (BOOL) removeDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate{
    NSArray *deleteResult = [self selectDataFromEntity:entityName query:predicate];
    NSManagedObjectContext *context = [self managedObjectContext];
    for (NSManagedObject *object in deleteResult) {
        [context deleteObject:object];
        NSError *error = nil;
        if (![context save:&error]){
            NSLog(@"error:%@",error);
            return NO;
        }
    }
    return YES;
}

// 清空
- (void)clearEntity:(NSString *)entityName{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]){
        for (NSManagedObject *obj in datas){
            [context deleteObject:obj];
        }
        if (![context save:&error]){
            NSLog(@"error:%@",error);
        }
    }
}
@end
