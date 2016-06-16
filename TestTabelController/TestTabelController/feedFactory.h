//
//  feedFactory.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/12.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feed.h"

@interface feedFactory : NSObject
{
    NSMutableDictionary *_feedDict;
}

- (feed<feed> *)createFeedWithName:(NSString *)name;
- (NSUInteger)amount;

@end
