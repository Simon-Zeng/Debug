//
//  eLongAssetsLibraryController.m
//  ElongClient
//
//  Created by chenggong on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "eLongAssetsLibraryController.h"

@interface eLongAssetsLibraryController()

@end

@implementation eLongAssetsLibraryController

- (void)dealloc
{
    self.roomId = nil;
    
}

+ (ALAssetsLibrary *)shareInstance
{
    static ALAssetsLibrary *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[ALAssetsLibrary alloc] init];
        
    });
    
    return _shareInstance;
}

+ (eLongAssetsLibraryController *)shareDataInstance
{
    static eLongAssetsLibraryController *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[eLongAssetsLibraryController alloc] init];
        
    });
    
    return _shareInstance;
}

@end
