//
//  feedState.m
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import "feedState.h"
#import <objc/runtime.h>

@implementation feedState

- (Memento *)toMemento
{
    return @{
             modelKey:_model,
             modelNameKey:_modelName
             };
}

- (void)restoreMementoFromMemento:(Memento *)memento
{
    self.model = memento[modelKey];
}

- (void)setModel:(id)model
{
    _model = model;
    if (model) {
        NSString *name = @(object_getClassName(model));
        if (name.length) {
            self.modelName = name;
        }
    }
}



@end
