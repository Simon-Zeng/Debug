//
//  eLongAreaPhoneModel.m
//  ElongClient
//
//  Created by nieyun on 15-1-4.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "eLongAreaPhoneModel.h"

@implementation eLongAreaPhoneModel

- (void)setAttributes:(NSDictionary *)dataDic{
    [super  setAttributes:dataDic];
    if (_acCode ) {
        _numCount = [self  checkNumCount:[NSString stringWithFormat:@"%@",_length]];
    }
}


- (NSInteger )checkNumCount:(NSString  *)accode{
    return [_length  intValue];
}




@end
