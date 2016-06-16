//
//  Channel.h
//  ElongClient
//
//  Created by Dawn on 15/4/2.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface eLongDebugChannelModel : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL enabled;
@end
