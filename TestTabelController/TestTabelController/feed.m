//
//  feed.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/12.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "feed.h"

@implementation feed
- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        _name = name.copy;
    }
    return self;
}
@end
