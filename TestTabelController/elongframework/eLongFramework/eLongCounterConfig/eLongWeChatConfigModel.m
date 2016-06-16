//
//  eLongWeChatConfigModel.m
//  eLongFramework
//
//  Created by zhaoyingze on 16/3/4.
//  Copyright © 2016年 Kirn. All rights reserved.
//

#import "eLongWeChatConfigModel.h"

@implementation eLongWeChatConfigModel

+ (id)shared
{
    static eLongWeChatConfigModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        model = [[self alloc] init];
        model.urlScheme = @"elongIPhone";
        model.appId = @"wx2a5825d706b3bb6a";
        model.appKey = @"278f7c0cd5880644d322aaf214c8a4c6";
    });
    
    return model;
}

@end
