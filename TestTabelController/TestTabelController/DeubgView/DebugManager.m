//
//  DebugManager.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/20.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "DebugManager.h"

@implementation DebugManager

+ (DebugNetWork *)networkInstance
{
    static DebugNetWork *network = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[DebugNetWork alloc]init];
    });
    
    return network;
}

@end
