//
//  feed.h
//  TestTabelController
//
//  Created by 王智刚 on 16/6/12.
//  Copyright © 2016年 王智刚. All rights reserved.
//

#import <Foundation/Foundation.h>

@class feeData;
@protocol feed <NSObject>

- (void)feedWihthFeedData:(feeData *)data;

@end

@interface feed : NSObject
{
    @protected
    NSString *_name;
}
- (instancetype)initWithName:(NSString *)name;

@end
