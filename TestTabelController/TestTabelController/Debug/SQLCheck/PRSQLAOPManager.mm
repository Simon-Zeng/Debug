//
//  PRSQLAOPManager.m
//  TestTabelController
//
//  Created by wzg on 16/9/5.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "PRSQLAOPManager.h"
#import "Aspects.h"
#import "EXTScope.h"
#import <QuartzCore/QuartzCore.h>

@implementation PRSQLAOPManager

- (void)aopFMDBQuery
{
    do {
        Class cls = NSClassFromString(@"FMDatabase");
        if (!cls) {
            //输出错误信息到控制台
            fprintf(stderr, "没有fmdb这个库\n");
            break;
        }
        
        __block CFTimeInterval beginT;
        __block CFTimeInterval endT;
        @weakify(self);
        [cls aspect_hookSelector:@selector(executeUpdate:error:withArgumentsInArray:orDictionary:orVAList:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo){
            beginT = CACurrentMediaTime();
        } error:NULL];
        
        
        [cls aspect_hookSelector:@selector(executeUpdate:error:withArgumentsInArray:orDictionary:orVAList:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            endT = CACurrentMediaTime();
        } error:NULL];
        

        NSLog(@"sql执行时间:%zi",endT - beginT);
        
    } while (0);
}


@end
