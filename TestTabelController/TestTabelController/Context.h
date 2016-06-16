//
//  Context.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface Context : NSObject
{
    @private
    id<State> _state;
}

@property (nonatomic, assign,readonly,getter=isAuth)BOOL Auth;
@property (nonatomic, copy,readonly)NSString *feedName;

- (void)changeStateToAutoWithFeedName:(NSString *)feedName;
- (void)changeStateToUnAuto;
@end
