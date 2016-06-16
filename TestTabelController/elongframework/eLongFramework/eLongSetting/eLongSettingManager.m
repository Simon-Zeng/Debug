//
//  eLongSettingManager.m
//  eLongFramework
//
//  Created by zhaoyingze on 15/7/28.
//  Copyright (c) 2015年 Kirn. All rights reserved.
//

#import "eLongSettingManager.h"

static eLongSetting *instanse = nil;

@implementation eLongSettingManager

+ (eLongSetting *)instanse {
    
    @synchronized(self) {
        
        if(!instanse) {
            
            instanse = [[eLongSetting alloc] init];
        }
    }
    
    return instanse;
}

@end
