//
//  Ads.h
//  ElongClient
//
//  Created by Dawn on 15/4/20.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface eLongDebugAdsModel : NSManagedObject

@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@end
