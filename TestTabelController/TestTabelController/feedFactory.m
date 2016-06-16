//
//  feedFactory.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/12.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "feedFactory.h"
#import "concrteFeed.h"

@implementation feedFactory
- (instancetype)init
{
    self = [super init];
    if (self) {
        _feedDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (feed<feed> *)createFeedWithName:(NSString *)name
{
    if (nil == _feedDict[name]) {
        feed *feed = [[concrteFeed alloc]initWithName:name];
        [_feedDict setValue:feed forKey:name];
    }
    return [_feedDict valueForKey:name];
}

- (NSUInteger)amount
{
    return _feedDict.count;
}
@end
