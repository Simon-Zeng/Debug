//
//  NSMutableArray+Stack.h
//  TestTabelController
//
//  Created by wzg on 16/8/31.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<T> (Stack)
- (void)push:(T)obj;
- (T)popObj;
- (void)popFromIndex:(NSUInteger)index;
@end
