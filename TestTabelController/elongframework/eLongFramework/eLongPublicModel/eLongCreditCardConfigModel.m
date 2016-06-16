//
//  eLongCreditCardConfigModel.m
//  eLongFramework
//
//  Created by lina on 15/12/15.
//  Copyright © 2015年 Kirn. All rights reserved.
//

#import "eLongCreditCardConfigModel.h"
static eLongCreditCardConfigModel *model = nil;

@implementation eLongCreditCardConfigModel
+ (id)shared
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        model = [[self alloc] init];
        model.bussinessType = [NSNumber numberWithInteger:1005];
    });
    
    
    return model;
}

@end
