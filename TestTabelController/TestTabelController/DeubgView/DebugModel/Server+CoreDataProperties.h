//
//  Server+CoreDataProperties.h
//  
//
//  Created by wzg on 16/7/6.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Server.h"

NS_ASSUME_NONNULL_BEGIN

@interface Server (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *enable;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
