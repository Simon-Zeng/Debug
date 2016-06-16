//
//  eLongAssetsLibraryController.h
//  ElongClient
//
//  Created by chenggong on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface eLongAssetsLibraryController : NSObject

@property (nonatomic, copy) NSString *roomId;

+ (ALAssetsLibrary *)shareInstance;
+ (eLongAssetsLibraryController *)shareDataInstance;

@end
