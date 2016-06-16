//
//  eLongCountryModel.m
//  eLongCounter
//
//  Created by zhaoyingze on 16/3/21.
//  Copyright © 2016年 elong. All rights reserved.
//

#import "eLongCountryModel.h"

@implementation eLongCountryModel

-(id) copyWithZone:(NSZone *)zone{
    eLongCountryModel *cModel = [[[self class] allocWithZone:zone] init];
    cModel.countryName =  [self.countryName copy];
    cModel.countryID =  [self.countryID copy];
    return cModel;
}

@end
