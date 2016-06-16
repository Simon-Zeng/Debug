//
//  checkFeed.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "checkFeed.h"
@implementation checkFeed
+ (void)saveStateWithMemento:(Memento *)memento keyName:(NSString *)keyName
{
    NSString *key = keyName ? : modelStateKey;
    /**
     * 存储方式
     *
     *  @param Memento <#Memento description#>
     *
     *  @return <#return value description#>
     */
//    [[NSUserDefaults standardUserDefaults] setObject:memento forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (Memento *)restorePreviousStateWithKeyName:(NSString *)keyName
{
    NSString *key = keyName ? :modelStateKey;
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
@end
