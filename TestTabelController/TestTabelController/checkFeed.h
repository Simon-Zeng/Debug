//
//  checkFeed.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "feedState.h"

@interface checkFeed : NSObject
+ (void)saveStateWithMemento:(Memento *)memento keyName:(NSString *)keyName;

+ (Memento *)restorePreviousStateWithKeyName:(NSString *)keyName;


@end
