//
//  authorizedState.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface authorizedState : NSObject<State>
@property (nonatomic, copy)NSString *feedName;

- (instancetype)initWithFeedName:(NSString *)feedName;

@end
