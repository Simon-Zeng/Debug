//
//  eLongAnalyticsLogger.h
//  eLongAnalytics
//
//  Created by chenggong on 15/12/3.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TableType) {
    eLongAnalyticsFixedLogType = 0,
    eLongAnalyticsFlexibleLogType,
    TableTypeUnknown
};

NS_ASSUME_NONNULL_BEGIN

@interface eLongAnalyticsLogger : NSObject

+ (eLongAnalyticsLogger *)shareLogger;
- (instancetype)init;

- (void)recordLogFixed:(NSDictionary *)parameters;
- (void)recordLogFlexible:(NSDictionary *)parameters;
- (void)sendEventLog:(TableType)ownerType;

@end

NS_ASSUME_NONNULL_END
