//
//  eLongAspects.m
//  eLongAnalytics
//
//  Created by zhaoyingze on 15/12/14.
//  Copyright © 2015年 elong. All rights reserved.
//

#import "eLongAspects.h"
#import "Aspects.h"

@implementation eLongAspects

+ (id)hookSelector:(SEL)selector
           inClass:(Class)theClass
       withOptions:(eAspectOptions)options
        usingBlock:(id)block
             error:(NSError **)error
{
    return [theClass aspect_hookSelector:selector withOptions:(NSInteger)options usingBlock:block error:error];
}

@end
