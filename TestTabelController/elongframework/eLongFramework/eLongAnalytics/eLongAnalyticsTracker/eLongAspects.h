//
//  eLongAspects.h
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/12/14.
//  Copyright © 2015年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, eAspectOptions)
{
    eAspectPositionAfter   = 0,            /// Called after the original implementation (default)
    eAspectPositionInstead = 1,            /// Will replace the original implementation.
    eAspectPositionBefore  = 2,            /// Called before the original implementation.
    
    eAspectOptionAutomaticRemoval = 1 << 3 /// Will remove the hook after the first execution.
};

@interface eLongAspects : NSObject

/**
 *  hook某个方法
 *
 *  @param selector 方法
 *  @param class    类
 *  @param options  hook时序
 *  @param block    需要执行的代码
 *  @param error    错误描述
 *
 *  @return A token which allows to later deregister the aspect
 */
+ (id)hookSelector:(SEL)selector
           inClass:(Class)theClass
       withOptions:(eAspectOptions)options
        usingBlock:(id)block
            error:(NSError **)error;

@end
