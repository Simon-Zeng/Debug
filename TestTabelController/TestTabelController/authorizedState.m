//
//  authorizedState.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "authorizedState.h"

@implementation authorizedState

- (instancetype)initWithFeedName:(NSString *)feedName
{
    self = [super init];
    if (self) {
        self.feedName = feedName;
    }
    return self;
}

- (BOOL)isAuthorizedWithContext:(Context *)context
{
    return YES;
}

- (NSString *)feedNameOfContext:(Context *)context
{
    return self.feedName;
}


@end
