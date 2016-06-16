//
//  State.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/11.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#ifndef State_h
#define State_h

@class Context;
@protocol State <NSObject>

- (BOOL)isAuthorizedWithContext:(Context *)context;
- (NSString *)feedNameOfContext:(Context *)context;

@end


#endif /* State_h */
