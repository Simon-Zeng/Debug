//
//  ReadAndWriteLock.h
//  TestTabelController
//
//  Created by wzg on 16/8/15.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadAndWriteLock : NSObject

- (void)setCount:(NSUInteger)count forKey:(NSString *)key;
- (NSUInteger)countForKey:(NSString *)key;
@end
