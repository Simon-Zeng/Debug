//
//  eLongMyElongImageUploadManager.h
//  ElongClient
//
//  Created by Dawn on 14-7-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eLongMyElongImageUploadItem.h"
#import "eLongSingletonDefine.h"

@interface eLongMyElongImageUploadManager : NSObject
AS_SINGLETON(ImageUploadManager)

- (void) resume;
- (void) restore;
- (void) addItem:(eLongMyElongImageUploadItem *)item;
- (void) stop;


@end
