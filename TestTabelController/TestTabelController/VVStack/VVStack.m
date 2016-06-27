//
//  VVStack.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/26.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "VVStack.h"

@interface VVStack()
@property (nonatomic, strong)NSMutableArray *arrM;
@end

@implementation VVStack
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrM = [NSMutableArray array];
    }
    return self;
}

- (double)stop
{
    return [[_arrM lastObject]doubleValue];
}

- (void)push:(double)num
{
    [self.arrM addObject:@(num)];
}

- (void)dealloc
{
    NSLog(@"对象被释放了");
}
@end
