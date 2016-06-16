//
//  UnauthorizedState.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "UnauthorizedState.h"

@implementation UnauthorizedState

- (BOOL)isAuthorizedWithContext:(Context *)context
{
    return NO;
}

- (NSString *)feedNameOfContext:(Context *)context
{
    return nil;
}

@end
