//
//  Context.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "Context.h"
#import "authorizedState.h"
#import "UnauthorizedState.h"

@implementation Context
- (instancetype)init
{
    self = [super init];
    if (self) {
        _state = [[UnauthorizedState alloc]init];
    }
    return self;
}
- (BOOL)isAuth
{
    return [_state isAuthorizedWithContext:self];
}

- (NSString *)feedName
{
    return [_state feedNameOfContext:self];
}

- (void)changeStateToUnAuto
{
    _state = [[UnauthorizedState alloc]init];
}

- (void)changeStateToAutoWithFeedName:(NSString *)feedName
{
    _state = [[authorizedState alloc]initWithFeedName:feedName];
}
@end
