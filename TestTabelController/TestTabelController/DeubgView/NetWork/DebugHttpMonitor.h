//
//  DebugHttpMonitor.h
//  TestTabelController
//
//  Created by 王智刚 on 16/7/3.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugHttpMonitor : NSURLProtocol
/**
 *  打开网络监听
 */
+ (void)setNetMonitorEnable:(BOOL)enable;
/**
 *  当前监听器是否可用
 */
+ (BOOL)isEnable;
/**
 *  替换请求
 *
 *  @param url 替换后的请求
 */
+ (void)exchangeRequestUrlWithNewUrl:(NSString *)url;

@end
