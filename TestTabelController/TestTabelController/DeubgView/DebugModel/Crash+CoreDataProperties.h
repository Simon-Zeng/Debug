//
//  Crash+CoreDataProperties.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Crash.h"

NS_ASSUME_NONNULL_BEGIN

@interface Crash (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *channel;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *device;
@property (nullable, nonatomic, retain) NSString *mark;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *netWork;
@property (nullable, nonatomic, retain) NSString *page;
@property (nullable, nonatomic, retain) NSString *osversion;
@property (nullable, nonatomic, retain) NSString *stack;

@end

NS_ASSUME_NONNULL_END
