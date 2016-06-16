//
//  eLongPhotoPickerDefines.h
//  eLongPhotoPickerKitExample
//
//  Created by Lvyue on 16/2/26.
//  Copyright © 2016年 Lvyue. All rights reserved.
//

#ifndef eLongPhotoPickerDefines_h
#define eLongPhotoPickerDefines_h

#import <UIKit/UIDevice.h>

#define keLongBarBackgroundColor  ([UIColor colorWithRed:(34/255.0) green:(34/255.0) blue:(34/255.0) alpha:1.0])
#define keLongButtonTitleColorNormal ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0])
#define keLongButtonTitleColorDisable  ([UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:0.5])

#define keLongMargin 4
#define keLongThumbnailWidth ([UIScreen mainScreen].bounds.size.width - 2 * keLongMargin - 4) / 4 - keLongMargin
#define keLongThumbnailSize CGSizeMake(keLongThumbnailWidth, keLongThumbnailWidth)

#define keLongCamera 1
#define keLongPhotoLibrary 2
#define keLongCancel  999
#define keLongConfirm 998

#endif /* eLongPhotoPickerDefines_h */
