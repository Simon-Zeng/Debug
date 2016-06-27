//
//  NetWork+CoreDataProperties.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NetWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetWork (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *beginDate;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSString *header;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSNumber *size;
@property (nullable, nonatomic, retain) NSNumber *statusCode;
@property (nullable, nonatomic, retain) NSString *type;

@end

NS_ASSUME_NONNULL_END
