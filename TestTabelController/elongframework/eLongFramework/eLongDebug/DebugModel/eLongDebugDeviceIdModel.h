//
//  eLongDebugDeviceIdModel.h
//  eLongFramework
//
//  Created by Dean on 16/4/15.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface eLongDebugDeviceIdModel : NSManagedObject
@property (nonatomic, strong) NSNumber * enabled;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * deviceid;

@end
