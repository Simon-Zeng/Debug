//
//  eLongAnalyticsTracker.h
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/11/22.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eLongAnalyticsTracker : NSObject

+ (instancetype)sharedInstance;

- (void)setUp;

@end
