//
//  DebugURLSessionConfiguration.h
//  TestTabelController
//
//  Created by 王智刚 on 16/7/3.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugURLSessionConfiguration : NSObject
@property (nonatomic, assign,getter=isSwizzle)BOOL swizzle;

+ (DebugURLSessionConfiguration *)defaultConfiguration;
/**
 *  加载并替换NSURLSessionConfiguration的protocol方法
 */
- (void)load;
/**
 *  卸载替换NSURLSessionConfiguration的protocol方法
 */

- (void)unload;

@end
