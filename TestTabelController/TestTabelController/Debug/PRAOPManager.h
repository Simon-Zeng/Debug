//
//  PRAOPManager.h
//  TestTabelController
//
//  Created by wzg on 16/8/31.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSUInteger, FSAspectOptions) {
    FSAspectPositionAfter   = 0,            /// Called after the original implementation (default)
    FSAspectPositionInstead = 1,            /// Will replace the original implementation.
    FSAspectPositionBefore  = 2,            /// Called before the original implementation.
    
    FSAspectOptionAutomaticRemoval = 1 << 3 /// Will remove the hook after the first execution.
};

@interface PRAOPManager : NSObject



+ (void)FS_hookSelector:(SEL)selector
                inClass:(Class)aclass withOptions:(FSAspectOptions)options
             usingBlock:(id)block
                  error:(NSError **)error;

/// Adds a block of code before/instead/after the current `selector` for a specific instance.
+ (void)FS_hookSelector:(SEL)selector
               inObject:(NSObject *)object withOptions:(FSAspectOptions)options
             usingBlock:(id)block
                  error:(NSError **)error;

/**
 *  关闭所有类的hook方法
 */
+ (void)removeAllHook;
@end
