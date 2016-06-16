//
//  eLongLoggerRequest.h
//  eLongAnalytics
//
//  Created by chenggong on 15/12/8.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eLongSingletonDefine.h"

@interface eLongLoggerRequest : NSObject
AS_SINGLETON(eLongLoggerRequest)

@property (atomic, assign) BOOL isLogSending;

- (void)sendFixedLog:(NSDictionary *)logContent;
- (void)sendFlexibleLog:(NSDictionary *)logContent from:(NSUInteger)fromIndex to:(NSUInteger)toIndex;

@end
