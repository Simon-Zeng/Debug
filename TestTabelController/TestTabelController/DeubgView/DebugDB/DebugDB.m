//
//  DebugDB.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugDB.h"

@implementation DebugDB

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)shareInstance
{
    static DebugDB *debugDB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        debugDB = [[DebugDB alloc]init];
    });
    return debugDB;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wzg.-.testCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DebugObject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DebugObject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (id)insertEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    id newsInfo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    return newsInfo;
}

- (NSArray *)selectDataFromEntity:(NSString *)entityName pageSize:(int)pageSize offset:(int)currentPage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setFetchLimit:pageSize];
    [fetch setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    return fetchedObjects;
}

- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate
{
     return [self selectDataFromEntity:entityName query:predicate sort:nil];
}

- (NSArray *)selectDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate sort:(NSSortDescriptor *)sort
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *requst = [[NSFetchRequest alloc]init];
    [requst setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    if (sort) {
        [requst setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    if (predicate) {
        [requst setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:requst error:&error];
    return result;
}

- (void)clearEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas.count) {
        for (NSManagedObject *obj in datas) {
            [context deleteObject:obj];
        }
        
        if (![context save:&error]) {
            NSLog(@"error:%@",error);
        }
    }
}

- (BOOL)remove:(NSManagedObject *)model
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:model];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"error:%@",error);
        return NO;
    }
    return YES;
}

- (BOOL)removeDataFromEntity:(NSString *)entityName query:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray *result = [self selectDataFromEntity:entityName query:predicate];
    for (NSManagedObject *obj in result) {
        [context deleteObject:obj];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"error:%@",error);
            return NO;
        }
    }
    return YES;
}
@end
