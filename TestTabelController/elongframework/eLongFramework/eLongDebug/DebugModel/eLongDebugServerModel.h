//
//  Server.h
//  ElongClient
//
//  Created by Kirn on 15/3/21.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface eLongDebugServerModel : NSManagedObject
/**
 *  服务器名称
 */
@property (nonatomic, retain) NSString * name;
/**
 *  服务器地址
 */
@property (nonatomic, retain) NSString * url;
/**
 *  是否为当前可用服务器
 */
@property (nonatomic, retain) NSNumber * enabled;

@end
