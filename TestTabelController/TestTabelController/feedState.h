//
//  feedState.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSDictionary<NSString *,id> Memento;

static NSString * const modelKey = @"mementoKeyModel";
static NSString * const modelNameKey = @"mementoKeyModelName";
static NSString * const modelStateKey = @"mementoKeyState";

@interface feedState : NSObject
@property (nonatomic, strong)id model;
@property (nonatomic, copy)NSString *modelName;

- (Memento *)toMemento;
- (void)restoreMementoFromMemento:(Memento *)memento;
@end
